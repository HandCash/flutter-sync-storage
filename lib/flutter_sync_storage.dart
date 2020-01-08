import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSyncStorage {
  static const MethodChannel _channel =
      const MethodChannel('flutter_sync_storage');

  Future<String> read(String key) async {
    String value = "";
    if (Platform.isIOS) {
      value = await FlutterSecureStorage().read(key: key);
    } else {
      value = await _channel.invokeMethod("read", key);
    }

    return value;
  }

  Future<bool> write(String key, String value) async {
    bool result = false;
    if (Platform.isIOS) {
      await FlutterSecureStorage().write(key: key, value: value);
      result = true;
    } else {
      Map<String, String> args = Map<String, String>();
      args.putIfAbsent("key", () => key);
      args.putIfAbsent("value", () => value);
      result = await _channel.invokeMethod("write", args);
    }

    return result;
  }
}
