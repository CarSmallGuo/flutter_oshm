/*
* Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE_KHZG file.
*/

import PlatformViewsChannel2, {
  PlatformViewsHandler,
  PlatformViewCreationRequest,
  PlatformViewTouch
} from '../../embedding/engine/systemchannels/PlatformViewsChannel2';
import PlatformView, { Params } from './PlatformView';
import PlatformViewRegistryImpl from './PlatformViewRegistryImpl';
import { FlutterView } from '../../view/FlutterView';
import { FlutterMutatorView } from '../../embedding/engine/mutatorsstack/FlutterMutatorView';
import { FlutterMutatorsStack } from '../../embedding/engine/mutatorsstack/FlutterMutatorsStack';
import Log from '../../util/Log';
import Any from '../common/Any';
import DartExecutor from '../../embedding/engine/dart/DartExecutor';
import TextInputPlugin from '../editing/TextInputPlugin';
import { ByteBuffer } from '../../util/ByteBuffer';

const TAG = "PlatformViewsController2";

export default class PlatformViewsController2 implements PlatformViewsHandler {
  private registry: PlatformViewRegistryImpl;
  private context: Context | null = null;
  private flutterView: FlutterView | null = null;
  private platformViewsChannel: PlatformViewsChannel2 | null = null;
  private platformViews: Map<number, PlatformView>;
  private platformViewParent: Map<number, FlutterMutatorView>;
  private textInputPlugin: TextInputPlugin | null = null;

  constructor(registry: PlatformViewRegistryImpl) {
    this.registry = registry;
    this.platformViews = new Map();
    this.platformViewParent = new Map();
  }

  public attach(context: Context, dartExecutor: DartExecutor): void {
    this.context = context;
    this.platformViewsChannel = new PlatformViewsChannel2(dartExecutor);
    this.platformViewsChannel.setPlatformViewsHandler(this);
  }

  public detach(): void {
    this.platformViewsChannel?.setPlatformViewsHandler(null);
    this.platformViewsChannel = null;
    this.context = null;
  }

  public attachToView(flutterView: FlutterView): void {
    this.flutterView = flutterView;
  }

  public detachFromView(): void {
    this.flutterView = null;
  }

  public attachTextInputPlugin(textInputPlugin: TextInputPlugin): void {
    this.textInputPlugin = textInputPlugin;
  }

  public detachTextInputPlugin(): void {
    this.textInputPlugin = null;
  }

  public onDetachedFromJNI(): void {
    this.disposeAllViews();
  }

  public onPreEngineRestart(): void {
    this.disposeAllViews();
  }

  public getPlatformView(viewId: number): PlatformView | undefined {
    return this.platformViews.get(viewId);
  }

  // PlatformViewsHandler implementation

  public createPlatformView(request: PlatformViewCreationRequest): void {
     Log.i(TAG, "createPlatformView: " + request.viewId);
     this.ensureValidRequest(request);
     
     const viewFactory = this.registry.getFactory(request.viewType);
     if (!viewFactory) {
       Log.e(TAG, "Trying to create a platform view of unregistered type: " + request.viewType);
       return;
     }

     let createParams: Any = null;
     if (request.params) {
        createParams = viewFactory.getCreateArgsCodec().decodeMessage(request.params.buffer);
     }

     if (!this.context) {
       Log.e(TAG, "Context is null");
       return;
     }

     const platformView = viewFactory.create(this.context, request.viewId, createParams);
     this.platformViews.set(request.viewId, platformView);
     
     const parentView = new FlutterMutatorView();
     parentView.setOnDescendantFocusChangeListener(() => {
        this.platformViewsChannel?.invokeViewFocused(request.viewId);
     }, () => {
        if (this.textInputPlugin) {
            this.textInputPlugin.clearTextInputClient();
        }
     });

     this.platformViewParent.set(request.viewId, parentView);
  }

  public dispose(viewId: number): void {
    const platformView = this.platformViews.get(viewId);
    if (!platformView) {
      Log.e(TAG, "Disposing unknown platform view with id: " + viewId);
      return;
    }

    this.platformViews.delete(viewId);
    try {
      platformView.dispose();
    } catch (exception) {
      Log.e(TAG, "Disposing platform view threw an exception " + exception);
    }

    const parentView = this.platformViewParent.get(viewId);
    if (parentView) {
      this.platformViewParent.delete(viewId);
    }
  }

  public onTouch(touch: PlatformViewTouch): void {
    // TODO: Implement touch event dispatching to the platform view
    // This requires synthesizing a touch event and dispatching it to the
    // component or node corresponding to the viewId.
    // Android uses MotionEventTracker and AndroidTouchProcessor.
    Log.w(TAG, "onTouch not implemented");
  }

  public setDirection(viewId: number, direction: number): void {
    const platformView = this.platformViews.get(viewId);
    if (!platformView) {
      Log.e(TAG, "Setting direction for unknown platform view with id: " + viewId);
      return;
    }
    // TODO: Implement setting layout direction on the platform view
    // embeddedView.setLayoutDirection(direction);
  }

  public clearFocus(viewId: number): void {
    const platformView = this.platformViews.get(viewId);
    if (!platformView) {
      Log.e(TAG, "Clearing focus for unknown platform view with id: " + viewId);
      return;
    }
    // TODO: Implement clearing focus on the platform view
    // view.clearFocus();
  }

  public isSurfaceControlEnabled(): boolean {
    return false;
  }

  // Helper methods

  private ensureValidRequest(request: PlatformViewCreationRequest): void {
     // Basic validation
  }

  private disposeAllViews(): void {
    const keys = Array.from(this.platformViews.keys());
    for (const viewId of keys) {
      this.dispose(viewId);
    }
  }
  
  public onDisplayPlatformView(
    viewId: number,
    x: number,
    y: number,
    width: number,
    height: number,
    viewWidth: number,
    viewHeight: number,
    mutatorsStack: FlutterMutatorsStack
  ): void {
      const parentView = this.platformViewParent.get(viewId);
      if (parentView) {
        parentView.readyToDisplay(mutatorsStack, x, y, width, height);
      }
  }
}
