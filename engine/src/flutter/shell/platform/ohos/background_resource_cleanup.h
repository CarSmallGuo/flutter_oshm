/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#ifndef FLUTTER_SHELL_PLATFORM_OHOS_BACKGROUND_RESOURCE_CLEANUP_H_
#define FLUTTER_SHELL_PLATFORM_OHOS_BACKGROUND_RESOURCE_CLEANUP_H_

namespace flutter {

    /**
     * GPU reclaim level defines the intensity of GPU resource cleanup.
     *
     * kNone: No cleanup, foreground state, normal operation.
     * kAggressive: Aggressive cleanup for background state or surface destroyed.
     *              Actions: freeGpuResources, teardown onscreen/swapchain.
     */
    enum class GpuReclaimLevel {
        kNone,       // Level 0: Foreground, normal operation
        kAggressive  // Level 1: Background, release GPU resources
    };

    /**
     * Application lifecycle state.
     */
    enum class AppLifecycleState {
        kResumed,   // App is in foreground and visible
        kInactive,  // App is inactive (e.g., receiving a phone call)
        kHidden,    // App is not visible but still running
        kPaused,    // App is in background
        kDetached   // App is detached
    };

}  // namespace flutter

#endif  // FLUTTER_SHELL_PLATFORM_OHOS_BACKGROUND_RESOURCE_CLEANUP_H_
