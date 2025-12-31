/*
 * Copyright (c) 2025 Huawei Device Co., Ltd. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE_HW file.
 */
#include "ohos_vsync_voting_mgr.h"

#include <dlfcn.h>
#include <algorithm>
#include <unordered_map>
#include <vector>
#include <string>
#include <sstream>
#include <cmath>

#include "flutter/fml/logging.h"
#include "flutter/fml/trace_event.h"
#include "flutter/shell/platform/ohos/napi/platform_view_ohos_napi.h"

namespace flutter {

thread_local int64_t touchUpTimestamp = 0;

static std::shared_ptr<OhosVsyncVotingMgr> instance = nullptr;
static std::once_flag instanceFlag;

// default is 160 DPI
static constexpr int32_t PHYSICAL_PIXEL_DENSITY = 160;
// 1 inch equals 25.4 millimeters
static constexpr double INCH_2_MILL = 25.4;

// After the touch up event, the frame rate drops to 60 after some time.
static constexpr int32_t TOUCH_UP_MILLIS_TIME_OUT_FPS_60 = 3000;
// After the touch up event, the frame rate remains at 120 for a period of time.
static constexpr int32_t TOUCH_UP_MILLIS_TIME_OUT_FPS_120 = 100;

static constexpr int32_t HIGH_FPS_MAINTAINED_TIMES = 4;

static constexpr int32_t FPS_120 = 120;
static constexpr int32_t FPS_90 = 90;
static constexpr int32_t FPS_72 = 72;
static constexpr int32_t FPS_60 = 60;
static constexpr int32_t FPS_30 = 30;
static constexpr int32_t FPS_NO_VOTING = 0;

static constexpr int32_t DEFAULT_FPS = FPS_120;

static constexpr int32_t RET_FAILED = -1;
static constexpr int32_t RET_SUCCEED = 0;

constexpr char LIB_NATIVE_VSYNC_NAME[] = "libnative_vsync.so";
constexpr char FUN_SET_FREAM_RATE_NAME[] =
    "OH_NativeVSync_SetExpectedFrameRateRange";

constexpr char FRAMES_CFG_JSON[] = "framesconfig.json";
constexpr char SWITCH_KEY[] = "SWITCH";
constexpr char TRANSLATE_KEY[] = "TRANSLATE";
constexpr char SCALE_KEY[] = "SCALE";
constexpr char ROTATION_KEY[] = "ROTATION";

static unordered_map<VVMVotingType, std::string> votingTypeUnorderedMap = {
  {VVMVotingType::VOTING_TYPE_NOTHING, std::string("NOTHING")},
  {VVMVotingType::VOTING_TYPE_TOUCH_DOWN_FPS_120, std::string("TOUCH_DOWN_FPS_120")},
  {VVMVotingType::VOTING_TYPE_TOUCH_UP_FPS_60, std::string("TOUCH_UP_FPS_60")},
  {VVMVotingType::VOTING_TYPE_TOUCH_UP_FPS_120, std::string("TOUCH_UP_FPS_120")},
  {VVMVotingType::VOTING_TYPE_COMMON_PLATFORMVIEW_FPS_120, std::string("COMMON_PLATFORMVIEW_FPS_120")},
  {VVMVotingType::VOTING_TYPE_ANIMATION, std::string("ANIMATION")},
};

std::shared_ptr<OhosVsyncVotingMgr> OhosVsyncVotingMgr::GetInstance() {
  std::call_once(instanceFlag, [&] {
    instance = std::make_shared<OhosVsyncVotingMgr>();
  });

  return instance;
}

OhosVsyncVotingMgr::OhosVsyncVotingMgr()
    : assetProvider_(nullptr), libHandle_(nullptr) {
  switchStatus_ = LTPOSwitchState::LTPO_SWITCH_NOT_INIT;
  delayFrameRateDropTimes_ = HIGH_FPS_MAINTAINED_TIMES;

  libHandle_ = dlopen(LIB_NATIVE_VSYNC_NAME, RTLD_LAZY | RTLD_LOCAL);
  if (libHandle_ == nullptr) {
    FML_LOG(ERROR) << "Failed to dlopen libnative_vsync.so";
    return;
  }

  setExpectedFrameRateRangeFunc_ =
      reinterpret_cast<SetExpectedFrameRateRangeFunc_>(
          dlsym(libHandle_, FUN_SET_FREAM_RATE_NAME));
  if (setExpectedFrameRateRangeFunc_ == nullptr) {
    dlclose(libHandle_);
    libHandle_ = nullptr;
    FML_LOG(ERROR)
        << "Failed to dlsym OH_NativeVSync_SetExpectedFrameRateRange";
  }
}

OhosVsyncVotingMgr::~OhosVsyncVotingMgr() {
  if (libHandle_ != nullptr) {
    dlclose(libHandle_);
  }
}

void OhosVsyncVotingMgr::VoteAnimationValue(AnimationType ANType,
                                            double devicePixelRatio,
                                            double velocity) {
  if (libHandle_ == nullptr || switchStatus_ != LTPOSwitchState::LTPO_SWITCH_ON) {
    return;
  }

  double velocityTmp = std::abs(velocity);
  if (devicePixelRatio != 0.0) {
    // V(millimeter) = V(pixel) * 25.4 / (devicePixelRatio * 160)
    velocityTmp = velocityTmp / (devicePixelRatio * PHYSICAL_PIXEL_DENSITY);
    velocityTmp = velocityTmp * INCH_2_MILL;
  }

  switch (ANType) {
    case AnimationType::AN_TYPE_TRANSLATE:
      VoteANTranslate(velocityTmp);
      break;
    case AnimationType::AN_TYPE_SCALE:
    case AnimationType::AN_TYPE_ROTATION:
    default:
      break;
  }
  return;
}

void OhosVsyncVotingMgr::VoteTouchValue(VVMTouchType type, int64_t timestamp) {
  if (libHandle_ == nullptr || switchStatus_ != LTPOSwitchState::LTPO_SWITCH_ON) {
    return;
  }

  switch (type) {
    case VVMTouchType::TOUCH_TYPE_DOWN:
      isTouchDown_ = true;
      touchVoting_.store(FPS_120);
      VotingBySelf();
      break;
    case VVMTouchType::TOUCH_TYPE_UP:
      isTouchDown_ = false;
      touchVoting_.store(FPS_120);
      touchUpTimestamp = timestamp;
      VotingBySelf();
      break;
    case VVMTouchType::TOUCH_TYPE_UP_3_SEC_AFTER:
      // During the continuous swiping process, maintain a stable frame rate(FPS).
      if (isTouchDown_) {
        break;
      }
      if (timestamp - touchUpTimestamp >= TOUCH_UP_MILLIS_TIME_OUT_FPS_60) {
        touchVoting_.store(0);
        VotingBySelf();
      }
      break;
    default:
      break;
  }
  return;
}

void OhosVsyncVotingMgr::VoteVideoValue(int second, int frameCount) {
  if (libHandle_ == nullptr || switchStatus_ != LTPOSwitchState::LTPO_SWITCH_ON) {
    return;
  }

  if (second <= 0 || frameCount <= 0) {
    return;
  }

  int frameRate = frameCount / second;
  if (frameRate <= FPS_30) {
    videoVoting_.store(FPS_30);
  } else {
    videoVoting_.store(FPS_60);
  }
  return;
}

void OhosVsyncVotingMgr::VoteANTranslate(double velocity) {
  // Determine the maximum velocity withthin one vsync.
  if (velocity < curAnimationTranslateVelocity_) {
    return;
  }

  curAnimationTranslateVelocity_ = velocity;

  int expectedRateTmp = DEFAULT_FPS;
  for (std::vector<std::map<string, int>>::iterator it = framesConfigVec_.begin();
       it != framesConfigVec_.end(); it++) {
    if (velocity > static_cast<double>((*it)["min"])) {
      expectedRateTmp = (*it)["preferred_fps"];
      break;
    }
  }

  animationVoting_.store(expectedRateTmp);
}

void OhosVsyncVotingMgr::AttachNativeVsync(string handleName,
                                           OH_NativeVSync* handle) {
  if (libHandle_ == nullptr) {
    FML_LOG(ERROR) << "libHandle is null, or ltpo is not enabled";
    return;
  }

  if (handle == nullptr) {
    FML_LOG(ERROR) << "handle is null";
    return;
  }

  {
    std::lock_guard<std::mutex> lock(nativeVsyncMapMutex_);
    nativeVsyncMap_.insert(std::pair(handleName, handle));
  }
  return;
}

void OhosVsyncVotingMgr::DetachNativeVsync(string handleName) {
  std::lock_guard<std::mutex> lock(nativeVsyncMapMutex_);
  nativeVsyncMap_.erase(handleName);
  return;
}

int OhosVsyncVotingMgr::VoteFinalFrameRateByPriority() {
  int finalFrameRate = FPS_NO_VOTING;
  votingType_ = VVMVotingType::VOTING_TYPE_NOTHING;
  do {
    if (isTouchDown_) {
      finalFrameRate = FPS_120;
      votingType_ = VVMVotingType::VOTING_TYPE_TOUCH_DOWN_FPS_120;
      break;
    }

    // When there is no touch event on the screen for 3 seconds,
    // the frame rate changes to 60.
    if (touchVoting_.load() == FPS_NO_VOTING) {
      finalFrameRate = FPS_60;
      votingType_ = VVMVotingType::VOTING_TYPE_TOUCH_UP_FPS_60;
      break;
    }

    int64_t nowTimestamp = fml::TimePoint::Now().ToEpochDelta().ToMilliseconds();
    if (nowTimestamp - touchUpTimestamp < TOUCH_UP_MILLIS_TIME_OUT_FPS_120) {
      finalFrameRate = FPS_120;
      votingType_ = VVMVotingType::VOTING_TYPE_TOUCH_UP_FPS_120;
      break;
    }

    // When PlatformView exists, either do not vote on the frame rate
    // or only vote for a frame rate of 120.
    // The flag isPlatformViewExist_ should be reset by NativeVsync.
    if (isPlatformViewExist_.load()) {
      isPlatformViewExist_.store(false);
      finalFrameRate = FPS_120;
      votingType_ = VVMVotingType::VOTING_TYPE_COMMON_PLATFORMVIEW_FPS_120;
      break;
    }

    int animationVoting = animationVoting_.load();
    if (animationVoting != FPS_NO_VOTING) {
      finalFrameRate = animationVoting;
      votingType_ = VVMVotingType::VOTING_TYPE_ANIMATION;
      break;
    }
  } while (0);

  TRACE_EVENT2("flutter", "VoteFinalFrameRateByPriority",
    "FPS", std::to_string(finalFrameRate).c_str(),
    "type", votingTypeUnorderedMap[votingType_].c_str());
  return finalFrameRate;
}

int OhosVsyncVotingMgr::DelayFrameRateDropForStability(
    int nextFrameRate,
    VVMVotingFrameRateRole type) {
  std::ostringstream oss;
  oss << "DelayFrameRateDropForStability " << localFrameRate_ << "->" << nextFrameRate;
  std::string resultStr = oss.str();
  TRACE_EVENT0("flutter", resultStr.c_str());

  if (nextFrameRate >= localFrameRate_) {
    delayFrameRateDropTimes_ = HIGH_FPS_MAINTAINED_TIMES;
    expectedDropFrameRate_ = FPS_NO_VOTING;
    return nextFrameRate;
  }

  TRACE_EVENT1("flutter", "DelayFrameRateDropForStability",
    "remain", std::to_string(delayFrameRateDropTimes_).c_str());

  // The high frame rate transitions to low frame rate
  // using a slowly decreasing method.
  // HIGH_FPS_MAINTAINED_TIMES represents the number of vsync during
  if (type == VVMVotingFrameRateRole::ROLE_EX_MODULE) {
    delayFrameRateDropTimes_--;
    if (nextFrameRate > expectedDropFrameRate_) {
      expectedDropFrameRate_ = nextFrameRate;
    }
  }

  if (delayFrameRateDropTimes_ <= 0) {
    delayFrameRateDropTimes_ = HIGH_FPS_MAINTAINED_TIMES;
    return expectedDropFrameRate_;
  }

  return localFrameRate_;
}

int OhosVsyncVotingMgr::VotingExpectedRateRange(
    int resultFrameRate,
    OH_NativeVSync_ExpectedRateRange* range) {
  if ((resultFrameRate == localFrameRate_) &&
      (resultFrameRate == FPS_NO_VOTING || resultFrameRate == PlatformViewOHOSNapi::display_refresh_rate)) {
    return RET_FAILED;
  }
  localFrameRate_ = resultFrameRate;

  if (resultFrameRate != FPS_NO_VOTING) {
    range->min = FPS_30;
    range->max = FPS_120;
  } else {
    range->min = 0;
    range->max = 0;
  }
  range->expected = resultFrameRate;

  return RET_SUCCEED;
}

void OhosVsyncVotingMgr::VotingByNativeVsync(OH_NativeVSync* handle) {
  if (libHandle_ == nullptr || switchStatus_ != LTPOSwitchState::LTPO_SWITCH_ON ||
      setExpectedFrameRateRangeFunc_ == nullptr) {
    return;
  }

  if (handle == nullptr) {
    return;
  }

  int resultFrameRate = VoteFinalFrameRateByPriority();
  resultFrameRate = DelayFrameRateDropForStability(resultFrameRate);

  // Reset some states
  curAnimationTranslateVelocity_ = 0.0;

  OH_NativeVSync_ExpectedRateRange range = {0, 0, 0};
  int ret = VotingExpectedRateRange(resultFrameRate, &range);
  if (ret != RET_SUCCEED) {
    // no need to print log.
    return;
  }

  std::ostringstream oss;
  oss << "{" << range.min << "," << range.max << "," << range.expected << "}";
  std::string rangeStr = oss.str();
  FML_DLOG(INFO) << "SetExpectedFrameRateRange : " << rangeStr.c_str();
  TRACE_EVENT1("flutter", "SetExpectedFrameRateRange",
    "range", rangeStr.c_str());

  ret = setExpectedFrameRateRangeFunc_(handle, &range);
  if (ret != 0) {
    FML_LOG(ERROR) << "SetExpectedFrameRateRange failed, ret = " << ret;
  }

  return;
}

void OhosVsyncVotingMgr::VotingBySelf() {
  if (libHandle_ == nullptr || switchStatus_ != LTPOSwitchState::LTPO_SWITCH_ON ||
      setExpectedFrameRateRangeFunc_ == nullptr) {
    return;
  }

  int resultFrameRate = VoteFinalFrameRateByPriority();
  resultFrameRate = DelayFrameRateDropForStability(resultFrameRate, VVMVotingFrameRateRole::ROLE_SELF);

  // Reset some states
  curAnimationTranslateVelocity_ = 0.0;
  if (touchVoting_.load() == 0) {
    // After the voting event triggered by a touch event ends,
    // the voting event for the animation event should be canceled.
    animationVoting_.store(0);
  }

  OH_NativeVSync_ExpectedRateRange range = {0, 0, 0};
  int ret = VotingExpectedRateRange(resultFrameRate, &range);
  if (ret != RET_SUCCEED) {
    // no need to print log.
    return;
  }

  std::ostringstream oss;
  oss << "{" << range.min << "," << range.max << "," << range.expected << "}";
  std::string rangeStr = oss.str();
  FML_LOG(INFO) << "BySelf SetExpectedFrameRateRange : " << rangeStr.c_str();
  TRACE_EVENT1("flutter", "BySelf SetExpectedFrameRateRange", "range",
               rangeStr.c_str());

  // Safe copy of the current handle list
  std::vector<OH_NativeVSync*> handleVec;
  {
    std::lock_guard<std::mutex> lock(nativeVsyncMapMutex_);
    if (nativeVsyncMap_.empty()) {
      return;
    }
    handleVec.reserve(nativeVsyncMap_.size());
    for (auto it = nativeVsyncMap_.begin(); it != nativeVsyncMap_.end(); ++it) {
      handleVec.push_back(it->second);
    }
  }

  for (auto* handleTmp : handleVec) {
    if (handleTmp == nullptr) {
      continue;
    }
    ret = setExpectedFrameRateRangeFunc_(handleTmp, &range);
    if (ret != 0) {
      FML_LOG(ERROR) << "BySelf SetExpectedFrameRateRange failed, ret = " << ret;
    }
  }

  return;
}

void OhosVsyncVotingMgr::ParseTranslate(const Json::Value& arr) {
  if (arr.empty()) {
    FML_LOG(ERROR) << "The array is empty";
    return;
  }

  const char* tags[] = {"serial_number", "min", "max", "preferred_fps"};
  size_t num = sizeof(tags) / sizeof(char*);

  int number = 1;
  size_t size = arr.size();
  for (unsigned int i = 0; i < size; i++) {
    if (!arr[i].isObject()) {
      FML_LOG(ERROR) << "config item is not object at index = " << i;
      continue;
    }

    std::map<string, int> mapTmp;
    bool valid = true;
    for (unsigned int j = 0; j < num; j++) {
      const char* key = tags[j];
      if (!arr[i].isMember(key)) {
        FML_LOG(ERROR) << "config tag missed, key = " << key;
        valid = false;
        break;
      }
      if (!arr[i][key].isInt()) {
        FML_LOG(ERROR) << "config value invalid, key = " << key;
        valid = false;
        break;
      }
      int valueTmp = arr[i][key].asInt();
      if ((j == 0) && (valueTmp != number)) {
        FML_LOG(ERROR) << "config value serial_number is wrong";
      }
      mapTmp.insert(std::pair<string, int>(string(key), valueTmp));
    }
    if (valid) {
      framesConfigVec_.push_back(mapTmp);
      number++;
    }
  }
}

void OhosVsyncVotingMgr::ParseFramesCfg() {
  if (libHandle_ == nullptr) {
    FML_LOG(ERROR) << "libHandle is null";
    switchStatus_ = LTPOSwitchState::LTPO_SWITCH_OFF;
    return;
  }

  if (assetProvider_ == nullptr) {
    FML_LOG(ERROR) << "asset_provider is null";
    switchStatus_ = LTPOSwitchState::LTPO_SWITCH_OFF;
    return;
  }

  if (isCfgFileInit_) {
    FML_LOG(ERROR) << "framesconfig file has been initiallized";
    switchStatus_ = LTPOSwitchState::LTPO_SWITCH_OFF;
    return;
  }

  isCfgFileInit_ = true;

  if (ParseFramesCfgImpl() != RET_SUCCEED) {
    FML_LOG(ERROR) << "Failed to parse file frameconfig";
    switchStatus_ = LTPOSwitchState::LTPO_SWITCH_OFF;
  }

  return;
}

int OhosVsyncVotingMgr::ParseFramesCfgImpl() {
  std::unique_ptr<fml::Mapping> framesCfgMapping =
      assetProvider_->GetAsMapping(std::string(FRAMES_CFG_JSON));
  if (framesCfgMapping == nullptr) {
    FML_LOG(ERROR) << "Failed to GetAsMapping";
    return RET_FAILED;
  }

  const char* data =
      reinterpret_cast<const char*>(framesCfgMapping->GetMapping());
  if (data == nullptr) {
    FML_LOG(ERROR) << "Failed to GetBuffer";
    return RET_FAILED;
  }

  int size = static_cast<int>(framesCfgMapping->GetSize());

  Json::Value root;
  Json::CharReaderBuilder charReaderBuilder;
  std::string errs;
  std::unique_ptr<Json::CharReader> jsonReader(
      charReaderBuilder.newCharReader());
  bool isJson = jsonReader->parse(data, data + size, &root, &errs);
  if (!isJson || !errs.empty()) {
    FML_LOG(ERROR) << "Failed to parse frameconfig.json, err = " << errs;
    return RET_FAILED;
  }

  uint32_t switchValue = 0;
  if (root.isMember(SWITCH_KEY)) {
    if (root[SWITCH_KEY].isNumeric()) {
      switchValue = root[SWITCH_KEY].asUInt();
      // for DFX
      FML_LOG(WARNING) << "vsync_voting_mgr switchValue = " << switchValue;
    } else {
      FML_LOG(ERROR) << "Failed to parse key of SWITCH";
      return RET_FAILED;
    }
  }

  if (switchValue != static_cast<uint32_t>(LTPOSwitchState::LTPO_SWITCH_ON)) {
    FML_LOG(WARNING) << "ltpo is not enabled";
    return RET_FAILED;
  }

  if (root.isMember(TRANSLATE_KEY)) {
    ParseTranslate(root[TRANSLATE_KEY]);
  } else {
    FML_LOG(ERROR) << "Failed to parse key of TRANSLATE";
    return RET_FAILED;
  }

  switchStatus_ = LTPOSwitchState::LTPO_SWITCH_ON;
  return RET_SUCCEED;
}

void OhosVsyncVotingMgr::SetAssetProvider(
    std::unique_ptr<OHOSAssetProvider> hap_asset_provider) {
  if (libHandle_ == nullptr) {
    return;
  }

  if (hap_asset_provider == nullptr) {
    FML_LOG(ERROR) << "hap_asset_provider is null";
    return;
  }

  if (assetProvider_ != nullptr) {
    FML_LOG(WARNING) << "asset_provider already init";
    return;
  }

  assetProvider_ = std::move(hap_asset_provider);
  return;
}

void OhosVsyncVotingMgr::SetPlatformViewExist(bool isExist) {
  if (isPlatformViewExist_.load() != isExist) {
    isPlatformViewExist_.store(isExist);
  }
  return;
}

LTPOSwitchState OhosVsyncVotingMgr::CheckVotingSwitchState() {
  // for DFX
  if (switchStatus_ == LTPOSwitchState::LTPO_SWITCH_ON) {
    FML_LOG(WARNING) << "VotingSwitchState is on.";
  }
  return switchStatus_;
}
}  // namespace flutter
