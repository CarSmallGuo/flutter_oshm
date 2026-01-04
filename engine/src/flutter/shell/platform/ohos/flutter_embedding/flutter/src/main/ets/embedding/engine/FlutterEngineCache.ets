/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE_KHZG file.
*
* Based on FlutterEngineCache.java originally written by
* Copyright (C) 2013 The Flutter Authors.
*
*/

import FlutterEngine from "./FlutterEngine"

/**
 * Cache for storing FlutterEngine instances.
 * This singleton class provides a centralized way to store and retrieve engines by ID.
 */
export default class FlutterEngineCache {
  private static instance: FlutterEngineCache;
  private cachedEngines: Map<String, FlutterEngine> = new Map();

  /**
   * Gets the singleton instance of FlutterEngineCache.
   * @returns The FlutterEngineCache instance
   */
  static getInstance(): FlutterEngineCache {
    if (FlutterEngineCache.instance == null) {
      FlutterEngineCache.instance = new FlutterEngineCache();
    }
    return FlutterEngineCache.instance;
  }

  /**
   * Checks if an engine with the given ID exists in the cache.
   * @param engineId - The ID of the engine to check
   * @returns true if the engine exists, false otherwise
   */
  contains(engineId: String): boolean {
    return this.cachedEngines.has(engineId);
  }

  /**
   * Gets an engine from the cache by ID.
   * @param engineId - The ID of the engine to retrieve
   * @returns The FlutterEngine instance, or null if not found
   */
  get(engineId: String): FlutterEngine | null {
    return this.cachedEngines.get(engineId) || null;
  }

  /**
   * Puts an engine into the cache or removes it if null is provided.
   * @param engineId - The ID of the engine
   * @param engine - The FlutterEngine instance to cache, or null to remove
   */
  put(engineId: String, engine: FlutterEngine | null): void {
    if (engine != null) {
      this.cachedEngines.set(engineId, engine);
    } else {
      this.cachedEngines.delete(engineId);
    }
  }

  /**
   * Removes an engine from the cache by ID.
   * @param engineId - The ID of the engine to remove
   */
  remove(engineId: String): void {
    this.put(engineId, null);
  }

  /**
   * Clears all engines from the cache.
   */
  clear(): void {
    this.cachedEngines.clear();
  }
}