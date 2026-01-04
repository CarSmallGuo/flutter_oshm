# ci预编译脚本
# 预编译命令为：sh ./third_party/flutter_flutter/ci/prepare.sh

ROOT_DIR=$(pwd)
# 项目目录
PROJECT_DIR="$ROOT_DIR/third_party"
# 归档目录
ARCHIVE_DIR="$ROOT_DIR/Archive/out"

# 目标分支
TARGET_FLUTTER_BRANCH="oh-3.27.4-dev"
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
