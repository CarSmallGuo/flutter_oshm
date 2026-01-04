# ci预编译脚本
# 预编译命令为：sh ./third_party/flutter_flutter/ci/prepare.sh

ROOT_DIR=$(pwd)
# 项目目录
PROJECT_DIR="$ROOT_DIR/third_party"
# 引擎目录
ENGINE_DIR="$PROJECT_DIR/flutter_flutter/engine"
# 归档目录
ARCHIVE_DIR="$ROOT_DIR/Archive/out"
# 备份目录
BACKUP_DIR="$ROOT_DIR/Backup"
# repo 缓存仓库
REPO_CACHE_DIR="/home/tools/Flutter/repo"
# fluttertpc仓库列表
FLUTTERTPC_REPOS=(
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

# 目标分支
TARGET_FLUTTER_BRANCH="oh-3.35.7-dev"
TARGET_TESTER_BRANCH="main"

# 检查环境
function check_env() {
    echo "检查环境"
    echo "$ uname -a"
    uname -a
    echo "$ cat /etc/os-release"
    cat /etc/os-release
    echo "$ id -un"
    id -un
    echo "$ env"
    env
    # set
    echo "检查工具"
    echo "$ node -v"
    node -v
    echo "$ npm -v"
    npm -v
    echo "$ ohpm -v"
    ohpm -v
    echo "$ hvigorw -v"
    hvigorw -v
    echo "$ hdc -v"
    hdc -v
    echo "$ git --version"
    git --version
    echo "$ git config -l"
    git config -l
    echo "$ java -version"
    java -version
    echo "$ 检查网络"
    echo "$ curl -s -o /dev/null -w \"%{http_code}\n\" -m 5 $PUB_HOSTED_URL"
    curl -s -o /dev/null -w "%{http_code}\n" -m 5 $PUB_HOSTED_URL
    echo "$ curl -s -o /dev/null -w \"%{http_code}\n\" -m 5 $FLUTTER_STORAGE_BASE_URL"
    curl -s -o /dev/null -w "%{http_code}\n" -m 5 $FLUTTER_STORAGE_BASE_URL
    echo "$ curl -s -o /dev/null -w \"%{http_code}\n\" -m 5 https://chrome-infra-packages.appspot.com/prpc/cipd.Repository/GetInstanceURL"
    curl -s -o /dev/null -w "%{http_code}\n" -m 5 https://chrome-infra-packages.appspot.com/prpc/cipd.Repository/GetInstanceURL
    echo "检查项目文件"
    echo "$ pwd"
    pwd
    echo "$ cd $PROJECT_DIR"
    cd $PROJECT_DIR
    echo "$ ls -al"
    ls -al
    mkdir -p $ARCHIVE_DIR
    mkdir -p $BACKUP_DIR
}

# 同步缓存
function sync_cache() {
    echo "同步缓存"
    # 刷新CIPD缓存时间，避免缓存过期被删除
    echo "$ find $CIPD_CACHE_DIR -type f -exec touch {} +"
    find $CIPD_CACHE_DIR -type f -exec touch {} +
    # 刷新FLUTTERTPC仓库
    echo "$ cd $REPO_CACHE_DIR"
    cd $REPO_CACHE_DIR
    for repo in "${FLUTTERTPC_REPOS[@]}"; do
        echo "Fetching in $repo"
        (cd "$repo" && git fetch --all)
    done
    echo "$ repo forall -c 'git fetch --all'"
    repo forall -c 'git fetch --all'
    echo "$ 检查缓存"
    echo "$ ls -al $REPO_CACHE_DIR"
    ls -al $REPO_CACHE_DIR
    echo "$ ls -1A \"$REPO_CACHE_DIR\" | wc -l"
    ls -1A "$REPO_CACHE_DIR" | wc -l
    echo "$ ls -al $CIPD_CACHE_DIR/instances"
    ls -al $CIPD_CACHE_DIR/instances
    echo "$ ls -1A \"$CIPD_CACHE_DIR/instances\" | wc -l"
    ls -1A "$CIPD_CACHE_DIR/instances" | wc -l
}

# 恢复engine
function maybe_restore_engine() {
    if [ ! -d $ENGINE_DIR/src/flutter ]; then
        cp -a $BACKUP_DIR/src $ENGINE_DIR
    fi
}

# 准备SDK
function prepare_flutter() {
    echo "准备项目文件"
    echo "变基"
    echo "$ cd $PROJECT_DIR/flutter_flutter"
    cd $PROJECT_DIR/flutter_flutter
    echo "$ git fetch --all"
    git fetch --all
    echo "$ git branch -a"
    git branch -a
    echo "$ git rebase remotes/gitcode/$TARGET_FLUTTER_BRANCH"
    git rebase remotes/gitcode/$TARGET_FLUTTER_BRANCH
    if [ $? -ne 0 ]; then
        echo "rebase failed!!!"
        return 1
    fi
    git log -10 --pretty=format:"%h - %s"
    git status
    git diff

    # 获取commitid
    COMMIT_ID=$(git rev-parse HEAD)
    echo "COMMIT_ID: $COMMIT_ID"
    # 写入 commitid 文件
    echo $COMMIT_ID > $ARCHIVE_DIR/engine.ohos.har.version
    echo $COMMIT_ID > $ARCHIVE_DIR/engine.ohos.version

    # 备份（gclient sync失败时可能会将src里面的flutter文件夹删除，或src文件夹被污染）
    echo "$ rm -rf $BACKUP_DIR/src"
    rm -rf $BACKUP_DIR/src
    echo "$ cp -a $ENGINE_DIR/src $BACKUP_DIR/src"
    cp -a $ENGINE_DIR/src $BACKUP_DIR/src
}

# 准备Tester
function prepare_tester() {
    echo "准备Tester"
    echo "$ cd $PROJECT_DIR/flutter_tester"
    cd $PROJECT_DIR/flutter_tester
    if [ $? -ne 0 ]; then
        echo "flutter_tester 不存在"
        return 1
    fi
    echo "$ git branch -a"
    git branch -a
    echo "$ git checkout $TARGET_TESTER_BRANCH"
    git checkout $TARGET_TESTER_BRANCH
    echo "$ git reset --hard"
    git reset --hard
    echo "$ git pull --rebase"
    git pull --rebase
}

# 入口
function prepare() {
    check_env
    sync_cache
    maybe_restore_engine

    prepare_flutter
    if [ $? -ne 0 ]; then
        echo "Failed to execute: prepare_flutter"
        return 1
    fi

    prepare_tester
    if [ $? -ne 0 ]; then
        echo "Failed to execute: prepare_tester"
        return 1
    fi

    echo "准备阶段完成"
}

prepare $@
exit $?
