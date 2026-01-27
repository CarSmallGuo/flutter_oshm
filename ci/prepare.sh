#! /bin/bash
# Copyright (c) 2025 Huawei Device Co., Ltd. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE_HW file.
#
# USE IN CI
# preCompile：sh ./third_party/flutter_flutter/ci/prepare.sh

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_step() {
    echo -e "\n${GREEN}========================================${NC}"
    echo -e "${GREEN}$*${NC}"
    echo -e "${GREEN}========================================${NC}\n"
}

# Command execution wrapper
run_cmd() {
    local cmd="$1"
    echo "$ $cmd"
    eval "$cmd"
}

ROOT_DIR=$(pwd)
# Project directory
PROJECT_DIR="$ROOT_DIR/third_party"
# Archive directory
ARCHIVE_DIR="$ROOT_DIR/Archive/out"
# repo cache repository
REPO_CACHE_DIR="/home/tools/Flutter/repo"
# fluttertpc repository list
readonly FLUTTERTPC_REPOS=(
    fluttertpc_angle
    fluttertpc_boringssl_gen
    fluttertpc_buildroot
    fluttertpc_dart_native
    fluttertpc_dart_sdk
    fluttertpc_libcxx
    fluttertpc_libcxxabi
    fluttertpc_skia
    fluttertpc_spirv-headers
    fluttertpc_swiftshader
    fluttertpc_vulkan-deps
    fluttertpc_vulkan-headers
    fluttertpc_zlib
)

# Target branch
readonly TARGET_FLUTTER_BRANCH="oh-3.32.4-dev"
readonly TARGET_TESTER_BRANCH="main"

# Set environment variables
function setup_env_vars() {
    log_info "Setting up environment variables"
    # command-line-tools
    export TOOL_HOME=/home/tools/command-line-tools
    export DEVECO_SDK_HOME=$TOOL_HOME/sdk
    # Flutter
    export PUB_CACHE=/home/tools/Flutter/PUB
    export PUB_HOSTED_URL=https://pub.flutter-io.cn
    export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
    # Flutter gclient
    export DEPOT_TOOLS_UPDATE=0
    export GCLIENT_SUPPRESS_GIT_VERSION_WARNING=1
    # Flutter cipd
    export CIPD_CACHE_DIR=/home/tools/cipd_cache
    export CIPD_HTTP_USER_AGENT_PREFIX="offline"
    export CIPD_NO_SELF_UPDATE=true

    # Build PATH in correct order
    local path_components=(
        "$DEVECO_SDK_HOME/default/openharmony/toolchains"
        "$TOOL_HOME/ohpm/bin"
        "$TOOL_HOME/hvigor/bin"
        "$TOOL_HOME/tool/node/bin"
        "/home/tools/depot_tools"
        "$DEVECO_SDK_HOME/default/openharmony/native/llvm/bin"
        "$PROJECT_DIR/cipd/bin"
        "$PATH"
    )
    export PATH=$(IFS=:; echo "${path_components[*]}")
}

# Check system information
function check_system_info() {
    log_info "Checking system information"
    run_cmd "uname -a"
    run_cmd "cat /etc/os-release"
    run_cmd "id -un"
}

# Verify tool versions
function check_tool_versions() {
    log_info "Verifying tool versions"
    local tools=(
        "node:-v"
        "npm:-v"
        "ohpm:-v"
        "hvigorw:-v"
        "hdc:-v"
        "git:--version"
        "java:-version"
    )

    for tool in "${tools[@]}"; do
        local name="${tool%:*}"
        local flag="${tool#*:}"
        run_cmd "$name $flag"
    done

    # Configure git
    log_info "Configuring git"
    run_cmd "git config --global user.name \"Flutter CI\""
    run_cmd "git config --global user.email \"flutter_ci@huawei.com\""
    run_cmd "git config -l"
}

# Check network connectivity
function check_network() {
    log_info "Checking network connectivity"
    local urls=(
        "$PUB_HOSTED_URL"
        "$FLUTTER_STORAGE_BASE_URL"
        "https://chrome-infra-packages.appspot.com/prpc/cipd.Repository/GetInstanceURL"
    )

    for url in "${urls[@]}"; do
        local status=$(curl -s -o /dev/null -w "%{http_code}" -m 5 "$url" || echo "failed")
        if [[ "$status" =~ ^[23] ]]; then
            log_info "✓ $url: $status"
        else
            log_warn "✗ $url: $status"
        fi
    done
}

# Check project structure
function check_project_structure() {
    log_info "Checking project structure"
    run_cmd "pwd"

    if [[ ! -d "$PROJECT_DIR" ]]; then
        log_error "Project directory does not exist: $PROJECT_DIR"
        exit 1
    fi

    run_cmd "ls -la $PROJECT_DIR"

    # Create necessary directories
    run_cmd "mkdir -p $ARCHIVE_DIR/out"
}

# Check environment
function check_env() {
    log_step "Checking Environment"
    check_system_info
    setup_env_vars
    run_cmd "env"
    check_tool_versions
    check_network
    check_project_structure
}

# Prepare cipd
function prepare_cipd() {
    log_step "Preparing CIPD"

    if [[ ! -d "$CIPD_CACHE_DIR" ]]; then
        log_error "CIPD cache directory does not exist: $CIPD_CACHE_DIR"
        return 1
    fi

    if [[ ! -d "$CIPD_CACHE_DIR/instances" ]]; then
        log_error "instances directory does not exist in $CIPD_CACHE_DIR"
        return 1
    fi

    log_info "Refreshing CIPD cache timestamps"
    run_cmd "find $CIPD_CACHE_DIR -type f -exec touch {} +" "Touch all cache files"

    log_info "Clearing CIPD state database"
    local state_db="$CIPD_CACHE_DIR/instances/state.db"
    if [[ -f "$state_db" ]]; then
        run_cmd "rm $state_db"
    fi

    # if [[ ! -d "$PROJECT_DIR/cipd" ]]; then
    #     log_warn "CIPD directory does not exist, skipping"
    #     return 0
    # fi

    # cd "$PROJECT_DIR/cipd" || {
    #     log_error "Failed to cd to cipd directory"
    #     return 1
    # }

    # run_cmd "git branch -a"
    # run_cmd "git checkout main"
    # run_cmd "git reset --hard origin/main" "Reset to origin/main"
    # run_cmd "git pull --rebase"
    cd $PROJECT_DIR
    run_cmd "git clone -b main https://gitcode.com/xiedrsz/cipd.git"
    cd cipd
    run_cmd "patchcipd"

    log_info "CIPD instances statistics"
    run_cmd "ls -al $CIPD_CACHE_DIR/instances"
    local cipd_count=$(ls -1A "$CIPD_CACHE_DIR/instances" | wc -l)
    log_info "Total CIPD instances: $cipd_count"
}

# Preparing REPOS
function prepare_repos() {
    log_step "Preparing REPOS"

    if [[ ! -d "$REPO_CACHE_DIR" ]]; then
        log_error "Repo cache directory does not exist: $REPO_CACHE_DIR"
        return 1
    fi

    cd "$REPO_CACHE_DIR" || {
        log_error "Failed to cd to repo cache directory"
        return 1
    }

    log_info "Fetching FLUTTERTPC repositories"

    local success_count=0
    local fail_count=0

    for repo in "${FLUTTERTPC_REPOS[@]}"; do
        if [[ -d "$repo" ]]; then
            log_info "Fetching: $repo"
            if (cd "$repo" && git fetch --all); then
                ((success_count++))
            else
                log_error "Failed to fetch: $repo"
                ((fail_count++))
            fi
        else
            log_warn "Repository does not exist: $repo"
            ((fail_count++))
        fi
    done

    log_info "Fetch summary: $success_count succeeded, $fail_count failed"

    log_info "Repo cache statistics"
    run_cmd "ls -al $REPO_CACHE_DIR"
    local repo_count=$(ls -1A "$REPO_CACHE_DIR" | wc -l)
    log_info "Total repo cache entries: $repo_count"
}

# Sync cache
function sync_cache() {
    log_step "Syncing Cache"
    prepare_cipd
    prepare_repos
}

# Write commit ID to version files
function write_commit_id() {
    local commit_id="$1"
    log_info "Writing commit ID: $commit_id"

    run_cmd "echo $commit_id > $ARCHIVE_DIR/engine.ohos.har.version"
    run_cmd "echo $commit_id > $ARCHIVE_DIR/engine.ohos.version"
}

# Prepare SDK
function prepare_flutter() {
    log_step "Preparing Flutter Project"

    if [[ ! -d "$PROJECT_DIR/flutter_flutter" ]]; then
        log_error "Flutter project directory does not exist: $PROJECT_DIR/flutter_flutter"
        return 1
    fi

    cd "$PROJECT_DIR/flutter_flutter" || {
        log_error "Failed to cd to flutter_flutter directory"
        return 1
    }

    log_info "Fetching remote branches"
    run_cmd "git fetch --all"
    run_cmd "git branch -a"

    log_info "Rebasing to $TARGET_FLUTTER_BRANCH"
    if ! run_cmd "git rebase remotes/gitcode/$TARGET_FLUTTER_BRANCH"; then
        log_error "Rebase failed!"
        return 1
    fi

    log_info "Git status after rebase"
    run_cmd "git log -10 --pretty=format:'%h - %s'"
    run_cmd "git status"
    run_cmd "git diff"

    # Get commit id
    local commit_id=$(git rev-parse HEAD)
    log_info "Current commit: $commit_id"
    write_commit_id "$commit_id"

    log_info "Check if engine exists"
    if [[ ! -d "engine" ]]; then
        log_error "engine directory does not exist"
        return 1
    fi
}

# Prepare Tester
function prepare_tester() {
    log_step "Preparing Tester"

    if [[ ! -d "$PROJECT_DIR/flutter_tester" ]]; then
        log_warn "flutter_tester does not exist, skipping"
        return 0
    fi

    cd "$PROJECT_DIR/flutter_tester" || {
        log_error "Failed to cd to flutter_tester directory"
        return 1
    }

    run_cmd "git branch -a"
    run_cmd "git checkout $TARGET_TESTER_BRANCH"
    run_cmd "git reset --hard origin/$TARGET_TESTER_BRANCH" "Reset to origin/$TARGET_TESTER_BRANCH"
    run_cmd "git pull --rebase"

    log_info "Tester preparation completed"
}

# Cleanup on error
function cleanup_on_error() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script failed with exit code: $exit_code"
    fi
}

trap cleanup_on_error EXIT

# Main preparation function
function prepare() {
    local start_time=$(date +%s)

    log_step "Starting Flutter Preparation Script"
    log_info "Branch: $TARGET_FLUTTER_BRANCH"
    log_info "Date: $(date)"

    check_env || {
        log_error "Environment check failed"
        return 1
    }

    sync_cache || {
        log_error "Cache sync failed"
        return 1
    }

    prepare_flutter || {
        log_error "Flutter preparation failed"
        return 1
    }

    prepare_tester || {
        log_error "Tester preparation failed"
        return 1
    }

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    log_step "Preparation Completed Successfully"
    log_info "Total duration: ${duration}s"

    return 0
}

# Main entry point
main() {
    prepare "$@"
    local exit_code=$?
    exit $exit_code
}

main "$@"
