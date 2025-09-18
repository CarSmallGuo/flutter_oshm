# Changelog
## 6.0.0.701
- 修复多web时，鼠标/双指滑动无法滚动的问题
## 6.0.0.700
- 修复PC调用setWindowLayoutFullScreen接口不生效的问题 ([da1a2ce7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/da1a2ce70777ac9459ee3e6cbc99828675088a3a?ref=dev&prId=1011))
- 添加hover事件 ([1e2b3f4a](https://gitcode.com/openharmony-tpc/flutter_engine/commit/1e2b3f4a3d58919cedf5227d935f17cb8fac96d2?ref=dev&prId=1018))
- 解决delta模式下删除异常的问题 ([20c3ad6b](https://gitcode.com/openharmony-tpc/flutter_engine/commit/20c3ad6bfcfbb2ca1488a777c24f7953f0062d70?ref=dev&prId=978))
## 6.0.0.603
- release模式下嵌入icu数据到so中 ([f42fde19](https://gitcode.com/openharmony-tpc/flutter_engine/commit/f42fde19782ca03c5f44ca12d0e1a0beb5711c7b?ref=icu_37&prId=1001))
- 在FlutterEntry中添加系统环境变化监听器，把深色模式、字体等变化发送到dart层 ([24b182e4](https://gitcode.com/openharmony-tpc/flutter_engine/commit/24b182e4c03df73dbb793f126309dd95ccfd647e?ref=dev&prId=1003))
- 解决bottomRect of undefined的问题 ([c14cf409](https://gitcode.com/openharmony-tpc/flutter_engine/commit/c14cf4099bf541496ad14bcdfa2be8f7d46a0935?ref=dev&prId=1004))
## 6.0.0.602
- 修复pc下面抛滑事件 ([f77615bd](https://gitcode.com/openharmony-tpc/flutter_engine/commit/f77615bdc5948ec8d9fd2889825980725b1aefd7?ref=dev&prId=991))
## 6.0.0.600
- 适配webview鼠标hover功能 ([147b19b2](https://gitcode.com/openharmony-tpc/flutter_engine/commit/147b19b278955340a98a0a466ca0d521a5307a8a?ref=dev&prId=924))
## 6.0.0.504
- 解决DeltaTextInputClient回车和删除操作异常的问题 ([b3b5deff](https://gitcode.com/openharmony-tpc/flutter_engine/commit/b3b5deff3b35ffa2e8d9e9daac3f4ba2a1f13b98?ref=dev&prId=925))
## 6.0.0.503
- 支持系统字体热重载 ([42d1d865](https://gitcode.com/openharmony-tpc/flutter_engine/commit/42d1d865edce59bbe6c11cecde4b77c78975bd88?ref=dev&prId=965))
- 修复FlutterAbilityAndEntryDelegate.ets中代表页面是否在前台的变量初始值设置错误 ([6f7aa793](https://gitcode.com/openharmony-tpc/flutter_engine/commit/6f7aa793f08bfb839c9263efd104675f265095a6?ref=dev&prId=964))
- 修改候选词位置为光标的右下角 ([cf15e39e](https://gitcode.com/openharmony-tpc/flutter_engine/commit/cf15e39e12051e16a91b72c413340903a352ac19?ref=dev&prId=940))
- 修复多FlutterEntry情况下，生命周期异常的问题 ([00335081](https://gitcode.com/openharmony-tpc/flutter_engine/commit/003350811535dabbcc3dc3b868c68bd55d939a83?ref=dev&prId=949))
- 修复didChangeAppLifecycleState切换多任务后台未执行 ([bff6b81f](https://gitcode.com/openharmony-tpc/flutter_engine/commit/bff6b81ff1768141cef97792947ff14c4f3989c9?ref=dev&prId=948))
- 系统字体配置改为先从系统接口获取再从json文件获取 ([be488dfc](https://gitcode.com/openharmony-tpc/flutter_engine/commit/be488dfce98bcdb51980a8dc520c99edfd68eca3?ref=dev&prId=968))
## 5.1.0.601
- 解决api20外接键盘无法输入问题 ([e5b41e25](https://gitcode.com/openharmony-tpc/flutter_engine/commit/e5b41e25234b2bb611af0e837ba09ad5cba0be38?ref=dev&prId=943))
- 修改模拟器上竖屏视频播放倒转的问题 ([07318f24](https://gitcode.com/openharmony-tpc/flutter_engine/commit/07318f24da2beb44794fa60a8b0df788027bed79?ref=dev&prId=933))
- 修复鼠标点击事件导致的hover异常问题 ([745d585c](https://gitcode.com/openharmony-tpc/flutter_engine/commit/745d585c79c4a0c3375b7a09155332e2f9ace56f?ref=dev2&prId=936))
## 6.0.0.402
- 对hideTextInput方法的优化 ([970048b7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/970048b717836ef2b51dff7dcebcdb8c843852f0?ref=dev&prId=910))
- 修复webview关于NodeController的严重内存泄漏问题 ([f200cc51](https://gitcode.com/openharmony-tpc/flutter_engine/commit/f200cc51b8d28bc73e7dbc876f265ca583625712?ref=fix-webview-memoryleak&prId=886))
- 修正 FlutterView 中 routerPageUpdate 监听器的添加和移除 ([ba3bbf52](https://gitcode.com/openharmony-tpc/flutter_engine/commit/ba3bbf52d9efae1de66979faca422f87cd8eef2c?ref=dev&prId=902))
## 5.1.0.503
- API15后通过轴事件实现触控板捏合和抛滑手势，及鼠标滚轮滚动和Ctrl+滚轮缩放 ([c6dab8d7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/c6dab8d7478a81e8593a482bdb6e1e366a66967c?ref=axis&prId=900))
- 更改xcomponentMap_mutex为可重入锁 ([81f4f3f7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/81f4f3f7be9557681d18583eb344e9443f25e684?ref=3.7_merge_api18&prId=895))
- 新增性能雷达特性 ([2526bd55](https://gitcode.com/openharmony-tpc/flutter_engine/commit/2526bd5540102135c1da8d8d7a7ec65944b66633?ref=3.7_merge_api18&prId=895))
- result.notImplemented()实现中，修改reply方法参数为null ([44a1d5db](https://gitcode.com/openharmony-tpc/flutter_engine/commit/44a1d5dbc22e3f2f3223220308453e338ae6f9f1?ref=notImplemented&prId=868))
- flutter_embedding支持ets和native产物分开引用 ([79aa68df](https://gitcode.com/openharmony-tpc/flutter_engine/commit/79aa68dfda758e60957b46c9b495b8ca56d909b1?ref=feature-build&prId=824))
- 解决3.7单元测试报错问题 ([05556e66](https://gitcode.com/openharmony-tpc/flutter_engine/commit/05556e66cdc537db7f7a134029006ce505dbfe26?ref=dev&prId=837))
## 5.1.0.502
- 无障碍支持xcomponent多实例/多引擎场景 ([12247ac6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/12247ac613a9e446bd806bc4bc8c1d7fd512401c?ref=dev))
- 修复输入法文本光标位置更新和文本错误替换的问题 ([8fcb9342](https://gitcode.com/openharmony-tpc/flutter_engine/commit/8fcb93420b80727fde29571fbd3c22d570b5fcc2?ref=fix-input-changeselection-3.7&prId=846))
- 修复外接物理键盘时,用中文输入法输入内容后按删除键,导致额外删除输入框中的字符的问题 ([89d3ce09](https://gitcode.com/openharmony-tpc/flutter_engine/commit/89d3ce097aa21bc79b75db3d85b2975beb93269b?ref=feature-keyevent-3.7&prId=839))
- 修复输入框导致的闪动的问题 ([945678e6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/945678e632034583ea226f93b2880025a98645e1?ref=dev&prId=826))
- 同步3.22外接纹理改动,主动调用ScheduleFrame触发更新 ([b5c03b92](https://gitcode.com/openharmony-tpc/flutter_engine/commit/b5c03b92f1ae279bd2ee79fc337b781bb5450ed9?ref=feature-texture&prId=825))
## 5.1.0.403SP1
- Window内存泄露修复 ([4942fe4f](https://gitcode.com/openharmony-tpc/flutter_engine/commit/4942fe4f8214c1139c4c839c4e78d9e52c613759?ref=xcomponent&prId=817))
- 避免主线程外接纹理生产端死锁 ([acc7426f](https://gitcode.com/openharmony-tpc/flutter_engine/commit/acc7426f028ed3523a943d67aded6fcfcffa71ea?ref=cherry-pick3.22&prId=807))
- 同步3.22外接纹理改动:1.取消外接纹理无用的状态变量;2.外接纹理使用全局textureID ([7a3a5375](https://gitcode.com/openharmony-tpc/flutter_engine/commit/7a3a5375337f9fb8349c2ee0fa16372837d466c4?ref=golbal_textureId&prId=812))
- darwin-arm64中云端产物打包增加flutter_tester,禁用flutter_tester编译 ([fd051fa6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/fd051fa6c48be1f078f272ec045b2e1bbd8f61d4?ref=dev&prId=813))
- 修正外接纹理第一帧背景色颜色格式为ABGR ([49d603ae](https://gitcode.com/openharmony-tpc/flutter_engine/commit/49d603ae4dac2bb59d21574cf140dd97513fd067?ref=7-ABGR&prId=792))
- 取消设置请求本地窗口请求缓冲区的超时等待时间为0，解决某些场景下的闪烁问题([7b637946](https://gitcode.com/openharmony-tpc/flutter_engine/commit/7b63794671380e6507cb5122774d3399cdc82343?ref=flash&prId=808))
- 修复外接键盘时，shift加方向键文字被删除的问题 ([2f33bb4b](https://gitcode.com/openharmony-tpc/flutter_engine/commit/2f33bb4b3fb52a6b94727c686193f20e97a07eab?ref=dev&prId=785))
- 分支同步外接纹理LRU缓存策略优化 ([37b61a9a](https://gitcode.com/openharmony-tpc/flutter_engine/commit/37b61a9a93dbfafc04e5706a991ecd632436e68b?ref=lru&prId=791))
- 路由跳转软键盘状态异常处理 ([ea4535da](https://gitcode.com/openharmony-tpc/flutter_engine/commit/ea4535da5ec422c546e64785145be76a483213b3?ref=dev&prId=799))
- 增加导出接口EventSink, StreamHandler ([4a976c5e](https://gitcode.com/openharmony-tpc/flutter_engine/commit/4a976c5e68a422db60bda964d634751d3a72608f?ref=dev&prId=787))
## 5.1.0.403
- 修复showModalBottomSheet动画失效 ([4341076e](https://gitcode.com/openharmony-tpc/flutter_engine/commit/4341076e353a46148be0d76c896e12abef99ead6?ref=dev))
## 5.1.0.402
- 在flutternapi的析构函数中执行napi_reference_unref，取消在nativeDestroy中的napi_delete_reference,避免destroy后又调用napi方法导致的crash ([1a3a3617](https://gitcode.com/openharmony-tpc/flutter_engine/commit/1a3a3617f2a1b1eea380e337df4bf54552ab6d9c?ref=dev))
- pick !684 支持输入法输入成对符号时，光标自动调整到成对符号中间 ([1102b9d8](https://gitcode.com/openharmony-tpc/flutter_engine/commit/1102b9d825a32948f63166ff7ffc6147448cf766?ref=dev))
- ohos拉起键盘的方法新增参数,传入设备类型 ([f88aff02](https://gitcode.com/openharmony-tpc/flutter_engine/commit/f88aff02415bc28db852fde6445b01084d01f840?ref=dev))
- pick !129 !133 !766键盘焦点 ([fd53890c](https://gitcode.com/openharmony-tpc/flutter_engine/commit/fd53890c0b4478bd1ccdb7132d41dd67df11f57f?ref=dev))
- 修复napi和FlutterManager内存泄露问题 ([3b1069a7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/3b1069a773760466461c1a6aa692f3724ac21c30?ref=dev))
- 合入3.22的PR95，修正aibar避让逻辑 ([b1b571f5](https://gitcode.com/openharmony-tpc/flutter_engine/commit/b1b571f51bd63506f14c5f7b491210ce78672ad1?ref=dev))
## 5.1.0.401
- 同步3.22底部规避区域逻辑,pr21 ([b437aff6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/b437aff6bf24afaea4a81f28b6d39e060b44d4f7?ref=dev))
- 修复双指离开页面，导致会有一个手指事件无法结束的的问题 ([3d56dd26](https://gitcode.com/openharmony-tpc/flutter_engine/commit/3d56dd261cda0e8ab95489b1c83ff173872d7180?ref=dev))
## 5.1.0.305
- 3.22和3.7.12版本无障碍功能同步 ([334d31d6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/334d31d6658567e2b4164272a8548e6ac92ba21c?ref=dev))
- 对部分未使用接口添加遗弃标志 ([c48a1e26](https://gitcode.com/openharmony-tpc/flutter_engine/commit/c48a1e26086ba543fd2da5e8d9df2bffd739350b?ref=dev))
- 同步pr672，解决没有cutout导致的白屏问题 ([a867e970](https://gitcode.com/openharmony-tpc/flutter_engine/commit/a867e9709d64daf237d17cf840b7902d42d88a7e?ref=dev))
- 解决拉伸窗口后view不刷新的问题 ([efa8a96b](https://gitcode.com/openharmony-tpc/flutter_engine/commit/efa8a96bf589d5f27e438c9d3a035a883430f624?ref=dev))
- 修复外接纹理触摸事件逻辑里的一处语法错误 ([9324db2a](https://gitcode.com/openharmony-tpc/flutter_engine/commit/9324db2a61e1ca1d64328d27453ef4ba9155ebad?ref=dev))
- 修复一个del删除两个字符的问题 ([bdbda191](https://gitcode.com/openharmony-tpc/flutter_engine/commit/bdbda19131aa42688fb21364cd2a58855dee0b93?ref=dev))
## 5.1.0.304
- 修改napi接口nativeGetFlutterNavigationAction为nativeSetFlutterNavigationAction ([57d19b13](https://gitcode.com/openharmony-tpc/flutter_engine/commit/57d19b13541bbc5738c552ff99bf8fa58b057daf?ref=dev))
- 切换外接纹理实现方案 ([efbdeeb7](https://gitcode.com/openharmony-tpc/flutter_engine/commit/efbdeeb7e4a96c6a9ec909002fb8192ff58d2adf?ref=dev))
- 修复设置路由是否导航操作 ([a9bc1eb8](https://gitcode.com/openharmony-tpc/flutter_engine/commit/a9bc1eb84a102de39939f6fbe0208cc9e2a9eeda?ref=dev))
- 更新README文档 ([a936e6b6](https://gitcode.com/openharmony-tpc/flutter_engine/commit/a936e6b6beaa1b4b3042e44a87fc031fec614ca8?ref=dev))
- 屏幕朗读模式uiviewer中root和View组件类型无法识别 ([266c3001](https://gitcode.com/openharmony-tpc/flutter_engine/commit/266c300183928b1b8d37dafc0d34db815afd9886?ref=dev))

## 5.1.0.303
- 取消flutterView断言，避免crash ([b1d21bcd](https://gitcode.com/openharmony-tpc/flutter_engine/commit/b1d21bcd22282c2d3990734c054f360382f6d493?ref=dev))
- 修改部分场景下顶部状态栏规避高度不对的问题 ([452c4359](https://gitcode.com/openharmony-tpc/flutter_engine/commit/452c4359a250dfc62e2e1ca69677526471258ce1?ref=dev))
- 无障碍卡顿优化 ([3a064176](https://gitcode.com/openharmony-tpc/flutter_engine/commit/3a064176a0310730ba29e676374d940d6a45b690?ref=dev))
- fix: 当鼠标离开组件时，传递鼠标离开事件到FlutterEngine ([d1714c06](https://gitcode.com/openharmony-tpc/flutter_engine/commit/d1714c060563df0f4486d2eda124fc9a390df1f0?ref=dev))
## 5.1.0.204 
- fix: flutter输入框，一次del偶现删除两个字符 ([6cd1b210](https://gitcode.com/openharmony-tpc/flutter_engine/commit/6cd1b210edcd66cb9dfc659fd7affcde69ac634b?ref=mr_0226&prId=649))
- 修改Flutter输入框输入字符的逻辑,KeyDown事件发生时输入字符 ([9743030e](https://gitcode.com/openharmony-tpc/flutter_engine/commit/9743030e66dfb24faa470df4150ce509ef0376c4?ref=dev))
- 滑动区间的trace名修复 ([0ee82b4d](https://gitcode.com/openharmony-tpc/flutter_engine/commit/0ee82b4d621597c75b6bb670eb7b1dd1f9841671?ref=dev))
- 修复gclient配置文件格式问题 ([0606b72a](https://gitcode.com/openharmony-tpc/flutter_engine/commit/0606b72a505ac64713f903609f61fbf80b542337?ref=dev))
- !641 [无障碍]修复非触摸模式下滚动截屏和自动化测试出现绿框，并减少部分冗余遍历开销 ([16487fce](https://gitcode.com/openharmony-tpc/flutter_engine/commit/16487fcedd2dee7cc2348fd1d2a92cd3d4e7bcaa?ref=dev))
- !642 Revert "fix: 去除TextInputPlugin.ets中多余的delete监听；这部分删除逻辑，会在FlutterView.e… ([35ff2f10](https://gitcode.com/openharmony-tpc/flutter_engine/commit/35ff2f1004a23632efba51cddb42f258db7a273e?ref=dev))
- !639 codecheck扫描，ohos适配部分问题修改 ([9da923df](https://gitcode.com/openharmony-tpc/flutter_engine/commit/9da923df349879b069b37e69f878c4d1e95c107e?ref=dev))
