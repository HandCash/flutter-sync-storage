import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSyncStorage {
  static const MethodChannel _channel =
      const MethodChannel('flutter_sync_storage');

  Future<String> read(String key) async {
    final String value = await _channel.invokeMethod("read", key);
    return value; 
  }

  Future<bool> write(String key, String value) async {
    Map<String, String> args = Map<String, String>();
    args.putIfAbsent("key", () => key);
    args.putIfAbsent("value", () => value);
    final bool result = await _channel.invokeMethod("write", args);
    return result;
  }
}
