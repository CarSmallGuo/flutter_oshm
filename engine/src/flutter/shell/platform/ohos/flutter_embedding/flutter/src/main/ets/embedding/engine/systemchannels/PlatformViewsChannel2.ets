/*
* Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE_KHZG file.
*/

import DartExecutor from '../dart/DartExecutor';
import MethodChannel, { MethodCallHandler, MethodResult } from '../../../plugin/common/MethodChannel';
import MethodCall from '../../../plugin/common/MethodCall';
import StandardMethodCodec from '../../../plugin/common/StandardMethodCodec';
import Log from '../../../util/Log';
import { ByteBuffer } from '../../../util/ByteBuffer';
import Any from '../../../plugin/common/Any';

const TAG = "PlatformViewsChannel2";

export class PlatformViewCreationRequest {
  public viewId: number;
  public viewType: string;
  public logicalWidth: number;
  public logicalHeight: number;
  public direction: number;
  public params: ByteBuffer | null;

  constructor(viewId: number, viewType: string, logicalWidth: number, logicalHeight: number, direction: number, params: ByteBuffer | null) {
    this.viewId = viewId;
    this.viewType = viewType;
    this.logicalWidth = logicalWidth;
    this.logicalHeight = logicalHeight;
    this.direction = direction;
    this.params = params;
  }
}

export class PlatformViewTouch {
  public viewId: number;
  public downTime: number;
  public eventTime: number;
  public action: number;
  public pointerCount: number;
  public rawPointerPropertiesList: Object;
  public rawPointerCoords: Object;
  public metaState: number;
  public buttonState: number;
  public xPrecision: number;
  public yPrecision: number;
  public deviceId: number;
  public edgeFlags: number;
  public source: number;
  public flags: number;
  public motionEventId: number;

  constructor(
    viewId: number,
    downTime: number,
    eventTime: number,
    action: number,
    pointerCount: number,
    rawPointerPropertiesList: Object,
    rawPointerCoords: Object,
    metaState: number,
    buttonState: number,
    xPrecision: number,
    yPrecision: number,
    deviceId: number,
    edgeFlags: number,
    source: number,
    flags: number,
    motionEventId: number
  ) {
    this.viewId = viewId;
    this.downTime = downTime;
    this.eventTime = eventTime;
    this.action = action;
    this.pointerCount = pointerCount;
    this.rawPointerPropertiesList = rawPointerPropertiesList;
    this.rawPointerCoords = rawPointerCoords;
    this.metaState = metaState;
    this.buttonState = buttonState;
    this.xPrecision = xPrecision;
    this.yPrecision = yPrecision;
    this.deviceId = deviceId;
    this.edgeFlags = edgeFlags;
    this.source = source;
    this.flags = flags;
    this.motionEventId = motionEventId;
  }
}

export interface PlatformViewsHandler {
  createPlatformView(request: PlatformViewCreationRequest): void;
  dispose(viewId: number): void;
  onTouch(touch: PlatformViewTouch): void;
  setDirection(viewId: number, direction: number): void;
  clearFocus(viewId: number): void;
  isSurfaceControlEnabled(): boolean;
}

class PlatformViewsMethodCallHandler implements MethodCallHandler {
  private channel: PlatformViewsChannel2;

  constructor(channel: PlatformViewsChannel2) {
    this.channel = channel;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    this.channel.onMethodCall(call, result);
  }
}

export default class PlatformViewsChannel2 {
  private channel: MethodChannel;
  private handler: PlatformViewsHandler | null = null;
  private methodCallHandler: PlatformViewsMethodCallHandler;

  constructor(dartExecutor: DartExecutor) {
    this.channel = new MethodChannel(dartExecutor, "flutter/platform_views_2", StandardMethodCodec.INSTANCE);
    this.methodCallHandler = new PlatformViewsMethodCallHandler(this);
    this.channel.setMethodCallHandler(this.methodCallHandler);
  }

  public onMethodCall(call: MethodCall, result: MethodResult): void {
    if (this.handler == null) {
      return;
    }
    Log.d(TAG, "Received '" + call.method + "' message.");
    switch (call.method) {
      case "create":
        this.create(call, result);
        break;
      case "dispose":
        this.dispose(call, result);
        break;
      case "touch":
        this.touch(call, result);
        break;
      case "setDirection":
        this.setDirection(call, result);
        break;
      case "clearFocus":
        this.clearFocus(call, result);
        break;
      case "isSurfaceControlEnabled":
        this.isSurfaceControlEnabled(call, result);
        break;
      default:
        result.notImplemented();
    }
  }

  public invokeViewFocused(viewId: number): void {
    if (this.channel == null) {
      return;
    }
    this.channel.invokeMethod("viewFocused", viewId);
  }

  public setPlatformViewsHandler(handler: PlatformViewsHandler | null): void {
    this.handler = handler;
  }

  private create(call: MethodCall, result: MethodResult): void {
    const createArgs = call.args as Map<string, Object>;
    const paramsBytes = createArgs.get("params");
    const additionalParams: ByteBuffer | null = paramsBytes ? ByteBuffer.from(paramsBytes as ArrayBuffer) : null;
    
    try {
      const request = new PlatformViewCreationRequest(
        createArgs.get("id") as number,
        createArgs.get("viewType") as string,
        0, // logicalWidth - defaulting to 0 as per Java implementation if not present? Java impl passes 0.
        0, // logicalHeight
        createArgs.get("direction") as number,
        additionalParams
      );
      this.handler!.createPlatformView(request);
      result.success(null);
    } catch (error) {
      result.error("error", String(error), null);
    }
  }

  private dispose(call: MethodCall, result: MethodResult): void {
    const disposeArgs = call.args as Map<string, Object>;
    const viewId = disposeArgs.get("id") as number;
    try {
      this.handler!.dispose(viewId);
      result.success(null);
    } catch (error) {
      result.error("error", String(error), null);
    }
  }

  private touch(call: MethodCall, result: MethodResult): void {
    const args = call.args as Array<Object>;
    const touch = new PlatformViewTouch(
      args[0] as number,
      args[1] as number,
      args[2] as number,
      args[3] as number,
      args[4] as number,
      args[5] as Object,
      args[6] as Object,
      args[7] as number,
      args[8] as number,
      args[9] as number,
      args[10] as number,
      args[11] as number,
      args[12] as number,
      args[13] as number,
      args[14] as number,
      args[15] as number
    );

    try {
      this.handler!.onTouch(touch);
      result.success(null);
    } catch (error) {
      result.error("error", String(error), null);
    }
  }

  private setDirection(call: MethodCall, result: MethodResult): void {
    const setDirectionArgs = call.args as Map<string, Object>;
    const newDirectionViewId = setDirectionArgs.get("id") as number;
    const direction = setDirectionArgs.get("direction") as number;

    try {
      this.handler!.setDirection(newDirectionViewId, direction);
      result.success(null);
    } catch (error) {
      result.error("error", String(error), null);
    }
  }

  private clearFocus(call: MethodCall, result: MethodResult): void {
    const viewId = call.args as number;
    try {
      this.handler!.clearFocus(viewId);
      result.success(null);
    } catch (error) {
      result.error("error", String(error), null);
    }
  }

  private isSurfaceControlEnabled(call: MethodCall, result: MethodResult): void {
    try {
      result.success(this.handler!.isSurfaceControlEnabled());
    } catch (error) {
       result.error("error", String(error), null);
    }
  }
}
