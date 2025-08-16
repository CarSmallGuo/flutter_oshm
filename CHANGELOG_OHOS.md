# Changelog
## 6.0.0.504
- 图片编解码替换不拷贝内存接口 ([5973e3ba](https://gitcode.com/openharmony-tpc/flutter_engine/commit/5973e3ba0d5d3899617cac331a102ac494041373?ref=oh-3.27.4-dev&prId=972))
## 6.0.0.503
- 系统字体配置改为先从系统接口获取再从json文件获取 ([545ef790](https://gitcode.com/openharmony-tpc/flutter_engine/commit/545ef790c825abbaa0b429d4288739638b56a95e?ref=font&prId=961))
## 6.0.0.502
- 修正鸿蒙化Encoder遗留问题 ([51b67bec](https://gitcode.com/openharmony-tpc/flutter_engine/commit/51b67becae5d0457d17b8e233cabd6c912dcca1b?ref=encoder&prId=947))
## 6.0.0.501
- 修改模拟器上竖屏视频播放倒转的问题 ([98cb51ca](https://gitcode.com/openharmony-tpc/flutter_engine/commit/98cb51ca11cc2b9ad6f652f63599298770acdcfb?ref=oh-3.27.4-dev&prId=935))
- 修复多FlutterEntry情况下，生命周期异常的问题 ([921911f9](https://gitcode.com/openharmony-tpc/flutter_engine/commit/921911f9564863c95683321920b490f01ff2ff98?ref=oh-3.27.4-dev&prId=932))
- 修复鼠标点击事件导致的hover异常问题 ([42973093](https://gitcode.com/openharmony-tpc/flutter_engine/commit/42973093e067f578b521af816a1853da85cb983e?ref=oh-3.27.4-dev&prId=939))
- 解决api20外接键盘无法输入问题 ([4cd36549](https://gitcode.com/openharmony-tpc/flutter_engine/commit/4cd365496b6a9bd59c64fc3af36b4eda0b0804fa?ref=oh-3.27.4-dev&prId=946))
- 修复ets中void运算符使用方法错误 ([f51fc662](https://gitcode.com/openharmony-tpc/flutter_engine/commit/f51fc6620506e2501ea06b406b800296b715105f?ref=oh-3.27.4-dev&prId=927))
## 6.0.0.402
- 修复MediaQuery.of(context).accessibleNavigation状态值异常 ([97de11b7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/97de11b755fa845fe3096ef3b32affbb19cae4ab?ref=3.27-dev&prId=915))
- flutter_embedding支持ets产物和native产物分开引用 ([6ebf1786](https://gitcode.com/openharmony-tpc/flutter_engine/commit/6ebf178696dc32ff42a2914bab5ea48c7c8f55e0?ref=feature-build-3.27&prId=867))
## 6.0.0.401
- 修正轴事件API版本 ([1a179415](https://gitcode.com/openharmony-tpc/flutter_engine/commit/1a179415b81707f8eb3d649f3197cc6b17159f9d?ref=api&prId=898))
- 解决ltpo使能下，外接纹理的页面上60和120帧率来回跳变 ([66d4e46c](https://gitcode.com/openharmony-tpc/flutter_engine/commit/66d4e46c7867b17d23b74dcbd334aa9dc89b68e6?ref=oh-3.27.4-dev&prId=907))
- 新增单独上传flutter.har和symbols.zip的脚本 ([395ce7a1](https://gitcode.com/openharmony-tpc/flutter_engine/commit/395ce7a1a4a76ca554904f1b2e7b421216acdf6c?ref=oh-3.27.4-dev&prId=912))
- 修改超大gif图场景的内存泄露问题 ([66d4e46c](https://gitcode.com/openharmony-tpc/flutter_engine/commit/66d4e46c7867b17d23b74dcbd334aa9dc89b68e6?ref=oh-3.27.4-dev&prId=907))
## 6.0.0.303
- 增加查询ltpo开启状态的接口 ([51a1e089](https://gitcode.com/openharmony-tpc/flutter_engine/commit/51a1e08992de33eb15d6374fa855bd65dbcb5a58?ref=oh-3.27.4-dev&prId=884))
- 更改xcomponentMap_mutex为可重入锁 ([465cfba4](https://gitcode.com/openharmony-tpc/flutter_engine/commit/465cfba41f898730f622c9cfab75265765d39226?ref=oh-3.27.4-dev&prId=883))
- 外接物理键盘,用中文输入法输入内容后按删除键,导致额外删除输入框中的字符 ([73fc9b55](https://gitcode.com/openharmony-tpc/flutter_engine/commit/73fc9b55f0224d8c361c116c4d01e96af5f4458e?ref=oh-3.27.4-dev&prId=865))
- 添加DEP_ohos，依赖三方库分仓构建 ([091c6562](https://gitcode.com/openharmony-tpc/flutter_engine/commit/091c65622b430469aaaa9de29837ea918a0766eb?ref=deps&prId=854))
- 优化帧率投票；新增纹理投票 ([7c0bf0f7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/7c0bf0f7367055e6f325c1f03895d57945d15520?ref=oh-3.27.4-dev))
## 6.0.0.302
- 重构轴事件处理，适配更多场景 ([bdcd16cd](https://gitcode.com/openharmony-tpc/flutter_engine/commit/bdcd16cd33b6cb565bf1be04752ff417e7d5bf54?ref=oh-3.27.4-dev))
- 修复web应用启动时，平台识别异常 ([3654ae13](https://gitcode.com/openharmony-tpc/flutter_engine/commit/3654ae13f45755995bafe92566ec92aa775ab962?ref=oh-3.27.4-dev&prId=852))
## 6.0.0.301
- flutter3.27.4适配鸿蒙(engine:[cea23e09](https://gitcode.com/openharmony-tpc/flutter_engine/commit/cea23e09695b1daabf7e01537ef653e2c76ef26e?ref=oh-3.27.4-dev), sdk:[223e96a7](https://gitcode.com/openharmony-tpc/flutter_flutter/commit/223e96a76fe57cc8630ac561de11b99bb8d6427f?ref=oh-3.27.4-dev))