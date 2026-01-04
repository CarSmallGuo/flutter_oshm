# ci编译脚本
# 编译命令为：sh ./third_party/flutter_flutter/ci/compile.sh

ROOT_DIR=$(pwd)
# 项目目录
PROJECT_DIR="$ROOT_DIR/third_party"
# 引擎目录
ENGINE_DIR="$PROJECT_DIR/flutter_flutter/engine"
# 归档目录
ARCHIVE_DIR="$ROOT_DIR/Archive/out"
# 编译模式，随机从debug、profile和release中选择一个
MODES=("debug" "profile" "release")
BUILD_MODE=${MODES[$RANDOM % ${#MODES[@]}]}

# 目标分支
TARGET_FLUTTER_BRANCH="oh-3.35.7-dev"

# 同步项目依赖
function gclient_sync() {
    echo "同步项目依赖"
    echo "$ cd $PROJECT_DIR/flutter_flutter"
    cd $PROJECT_DIR/flutter_flutter
    echo "同步 .gclient"
    echo "$ cp -a ./ci/resources/. ."
    cp -a ./ci/resources/. .
    echo "$ ls -al"
    ls -al

    echo "$ gclient sync --ignore-dep-type=cipd -n"
    gclient sync --ignore-dep-type=cipd -n
    if [ $? -ne 0 ]; then
        echo "Failed to execute: gclient sync --ignore-dep-type=cipd -n"
        return 1
    fi

    echo "$ cipd ensure -root . -ensure-file cipd_manifest.txt"
    cipd ensure -root . -ensure-file cipd_manifest.txt
    if [ $? -ne 0 ]; then
        echo "Failed to execute: cipd ensure -root . -ensure-file cipd_manifest.txt"
        return 1
    fi

    # 临时，替换下载地址
    sed -i 's|https://commondatastorage.googleapis.com|file:///home/tools/Flutter/repo/binary|g' $ENGINE_DIR/src/build/linux/sysroot_scripts/install-sysroot.py

    echo "$ gclient runhooks"
    gclient runhooks
    if [ $? -ne 0 ]; then
        echo "Failed to execute: gclient runhooks"
        return 1
    fi

    # 3.7 以上跳过单元测试模块
    if [ "$TARGET_FLUTTER_BRANCH" = "dev" ]; then
        echo "无需跳过单元测试模块"
        return 0
    fi
    sed -i 's|enable_unittests = current_toolchain == host_toolchain \|\| is_fuchsia \|\| is_mac|enable_unittests = false|g' $ENGINE_DIR/src/flutter/testing/testing.gni
}

# 编译 engine，随机从debug、profile和release中选择一个
function compile_engine_random() {
    echo "构建模式：$BUILD_MODE"
    echo "$ cd $ENGINE_DIR"
    cd $ENGINE_DIR

    echo "开始编译engine"
    echo "$ ./ohos -t $BUILD_MODE"
    ./ohos -t $BUILD_MODE
    if [ $? -ne 0 ]; then
        echo "Failed to execute: ./ohos -t $BUILD_MODE"
        return 1
    fi

    # 3.7 需要额外编译host
    if [ "$TARGET_FLUTTER_BRANCH" = "dev" ]; then
        echo "$ ./ohos -t $BUILD_MODE -n host"
        ./ohos -t $BUILD_MODE -n host
        if [ $? -ne 0 ]; then
            echo "Failed to execute: ./ohos -t $BUILD_MODE -n host"
            return 1
        fi
    fi

    # 归档
    (cp -a $ENGINE_DIR/src/out/. $ARCHIVE_DIR &)
}

# 编译 engine，全量
function compile_engine_all() {
    echo "编译 engine，全量"
    echo "$ cd $ENGINE_DIR"
    cd $ENGINE_DIR

    echo "开始编译engine"
    if [ "$TARGET_FLUTTER_BRANCH" = "dev" ]; then
        # 3.7 需要额外编译host
        echo "$ ./ohos && ./ohos -n host && ./ohos --ohos-cpu x64"
        ./ohos && ./ohos -n host && ./ohos --ohos-cpu x64
    else
        echo "$ ./ohos && ./ohos --ohos-cpu x64"
        ./ohos && ./ohos --ohos-cpu x64
    fi
    if [ $? -ne 0 ]; then
        echo "engine 编译失败"
        return 1
    fi

    # 归档
    (cp -a $ENGINE_DIR/src/out/. $ARCHIVE_DIR &)
}

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
    if [ "$TARGET_FLUTTER_BRANCH" = "dev" ]; then
        # 3.7版本不需要--local-engine-host
        echo "$ flutter build hap --$BUILD_MODE --local-engine-src-path=$ENGINE_DIR/src --local-engine=ohos_${BUILD_MODE}_arm64"
        flutter build hap --$BUILD_MODE --local-engine-src-path=$ENGINE_DIR/src --local-engine=ohos_${BUILD_MODE}_arm64
    else
        echo "$ flutter build hap --$BUILD_MODE --local-engine-src-path=$ENGINE_DIR/src --local-engine=ohos_${BUILD_MODE}_arm64 --local-engine-host=host_$BUILD_MODE"
        flutter build hap --$BUILD_MODE --local-engine-src-path=$ENGINE_DIR/src --local-engine=ohos_${BUILD_MODE}_arm64 --local-engine-host=host_$BUILD_MODE
    fi
    # 归档
    cp $PROJECT_DIR/flutter_tester/ohos/entry/build/default/outputs/default/entry-default-unsigned.hap $ARCHIVE_DIR/entry-default-unsigned.hap
    if [ $? -ne 0 ]; then
        echo "Failed to execute: flutter build hap --$BUILD_MODE"
        return 1
    fi
}

# 上传到obs
function upload_to_obs() {
    echo "上传到obs"
    # 待完成
}

function compile() {
    echo "开始编译"
    pack_flutter
    if [ $? -ne 0 ]; then
        echo "Failed to execute: pack_flutter"
        return 1
    fi

    gclient_sync
    if [ $? -ne 0 ]; then
        echo "Failed to execute: gclient_sync"
        return 1
    fi

    if [ -z "${PR_URL}" ]; then
        # PR_URL 为空，说明是每日构建，需要编译全量
        echo "PR_URL 为空，说明是每日构建，需要编译全量"
        compile_engine_all
    else
        # 门禁
        echo "PR_URL 不为空，说明是门禁构建，需要编译随机"
        compile_engine_random
    fi
    if [ $? -ne 0 ]; then
        echo "engine 编译失败"
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
if [ $? -ne 0 ]; then
    # 后台删除，src文件夹已被污染
    (rm -rf $ENGINE_DIR/src &)
    echo "编译阶段失败"
    exit 1
fi
exit 0
