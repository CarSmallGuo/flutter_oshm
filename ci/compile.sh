# ci编译脚本
# 编译命令为：sh ./third_party/flutter_flutter/ci/compile.sh

ROOT_DIR=$(pwd)
# 项目目录
PROJECT_DIR="$ROOT_DIR/third_party"
# 归档目录
ARCHIVE_DIR="$ROOT_DIR/Archive/out"
# 编译模式，随机从debug、profile和release中选择一个
MODES=("debug" "profile" "release")
BUILD_MODE=${MODES[$RANDOM % ${#MODES[@]}]}

# 目标分支
TARGET_FLUTTER_BRANCH="oh-3.27.4-dev"

# 打包SDK
function pack_flutter() {
    echo "打包SDK"
    echo "$ cd $PROJECT_DIR/flutter_flutter"
    cd $PROJECT_DIR/flutter_flutter
    echo "$ zip -r $ARCHIVE_DIR/flutter.ohos.zip *"
    zip -r $ARCHIVE_DIR/sdk-$TARGET_FLUTTER_BRANCH.zip *
}

# 编译Tester
function compile_tester() {
    echo "编译Tester"
    # 检查 flutter 环境
    export PATH=$PROJECT_DIR/flutter_flutter/bin:$PATH
    echo "$ echo \$PATH"
    echo $PATH
    echo "$ flutter doctor -v"
    flutter doctor -v

    echo "$ cd $PROJECT_DIR/flutter_tester"
    cd $PROJECT_DIR/flutter_tester
    flutter build hap --$BUILD_MODE
    # 归档
    cp $PROJECT_DIR/flutter_tester/ohos/entry/build/default/outputs/default/entry-default-unsigned.hap $ARCHIVE_DIR/entry-default-unsigned.hap
    if [ $? -ne 0 ]; then
        echo "Failed to execute: flutter build hap --$BUILD_MODE"
        return 1
    fi
}

function compile() {
    echo "开始编译"
    pack_flutter
    if [ $? -ne 0 ]; then
        echo "Failed to execute: pack_flutter"
        return 1
    fi

    compile_tester
    if [ $? -ne 0 ]; then
        echo "Failed to execute: compile_tester"
        return 1
    fi
    echo "编译阶段完成"
}

compile $@
exit $?
