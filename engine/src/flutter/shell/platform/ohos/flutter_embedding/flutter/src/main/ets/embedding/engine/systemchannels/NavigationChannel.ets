/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE_KHZG file.
*
* Based on NavigationChannel.java originally written by
* Copyright (C) 2013 The Flutter Authors.
*
*/

import hiTraceMeter from '@ohos.hiTraceMeter';

import JSONMethodCodec from '../../../plugin/common/JSONMethodCodec';
import MethodCall from '../../../plugin/common/MethodCall';
import MethodChannel, { MethodCallHandler, MethodResult } from '../../../plugin/common/MethodChannel';
import Log from '../../../util/Log';
import DartExecutor from '../dart/DartExecutor';
import Any from '../../../plugin/common/Any';

export default class NavigationChannel {
  private static TAG = "NavigationChannel";
  private channel: MethodChannel;

  constructor(dartExecutor: DartExecutor) {
    this.channel = new MethodChannel(dartExecutor, "flutter/navigation", JSONMethodCodec.INSTANCE);
    // Provide a default handler that returns an empty response to any messages
    // on this channel.
    this.channel.setMethodCallHandler(new NavigationCallback());
  }

  setInitialRoute(initialRoute: string): void {
    Log.i(NavigationChannel.TAG, "Sending message to set initial route to '" + initialRoute + "'");
    this.channel.invokeMethod("setInitialRoute", initialRoute);
  }

  pushRoute(route: string): void {
    Log.i(NavigationChannel.TAG, "Sending message to push route '" + route + "'");
    this.channel.invokeMethod("pushRoute", route);
  }

  pushRouteInformation(route: string): void {
    Log.i(NavigationChannel.TAG, "Sending message to push route information '" + route + "'");
    this.channel.invokeMethod("pushRouteInformation", new Map().set("location", route));
  }

  popRoute(): void {
    Log.i(NavigationChannel.TAG, "Sending message to pop route.");
    this.channel.invokeMethod("popRoute", null);
  }

  setMethodCallHandler(handler: MethodCallHandler) {
    this.channel.setMethodCallHandler(handler);
  }
}

class NavigationCallback implements MethodCallHandler {
  private static TAG = "NavigationChannel";
  private navigationMgr: NavigationManager = new NavigationManager();

  onMethodCall(call: MethodCall, result: MethodResult) {
    let method: string = call.method;
    let args: Any = call.args;
    Log.i(NavigationCallback.TAG, "method = " + method);
    switch (method) {
      case "reportNavigatorPush": {
        /// Report the push action executed by the navigator.
        ///
        /// @Param start : Start to record trace.
        /// true - start to record trace; false - finish to record trace.
        ///
        /// @Param preSettingsName : The name of the previously displayed route.
        ///
        /// @Param curSettingsName : The name of the currently displayed route.
        let start: boolean = args.get("start");
        let preSettingsName: string = args.get("preSettingsName");
        let curSettingsName: string = args.get("curSettingsName");
        if (start === undefined || preSettingsName === undefined || curSettingsName === undefined) {
          Log.e(NavigationCallback.TAG, "reportNavigatorPush, incorrect parameter");
          break;
        }
        this.navigationMgr.reportNavigatorPush(start, preSettingsName, curSettingsName);
        break;
      }
      case "reportNavigatorPop": {
        /// Report the pop action executed by the navigator.
        ///
        /// @Param start : Start to record trace.
        /// true - start to record trace; false - finish to record trace.
        let start: boolean = args.get("start");
        if (start === undefined) {
          Log.e(NavigationCallback.TAG, "reportNavigatorPop, incorrect parameter");
          break;
        }
        this.navigationMgr.reportNavigatorPop(start);
        break;
      }
      default: {
        result.success(null);
        break;
      }
    }
  }
}

class NavigationManager {
  private settingsNameArray: Array<string> = ["null"];

  reportNavigatorPush(start: boolean, preSettingsName: string, curSettingsName: string) {
    if (start) {
      if (this.settingsNameArray.length == 1) {
        this.settingsNameArray.push(preSettingsName);
        this.settingsNameArray.push(curSettingsName);
      } else {
        this.settingsNameArray.push(curSettingsName);
      }
      hiTraceMeter.startTrace("flutter::NAVIGATOR_PUSH", 0);
    } else {
      hiTraceMeter.finishTrace("flutter::NAVIGATOR_PUSH", 0);
    }
  }

  reportNavigatorPop(start: boolean) {
    if (start) {
      hiTraceMeter.startTrace("flutter::NAVIGATOR_POP", 0);
    } else {
      hiTraceMeter.finishTrace("flutter::NAVIGATOR_POP", 0);
      this.settingsNameArray.pop();
    }
  }
}
