import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSyncStorage {
  static const MethodChannel _channel =
      const MethodChannel('flutter_sync_storage');

  Future<String> read(String key) async {
    String value = "";
    switch (Platform.operatingSystem) {
      case "ios":
        value = await FlutterSecureStorage().read(key: key);
        break;

      case "android":
      default:
        value = await _channel.invokeMethod("read", key);
        break;
    }

    return value;
  }

  Future<bool> write(String key, String value) async {
    bool result = false;

    switch (Platform.operatingSystem) {
      case "ios":
        await FlutterSecureStorage().write(key: key, value: value);
        result = true;
        break;

      case "android":
      default:
        Map<String, String> args = Map<String, String>();
        args.putIfAbsent("key", () => key);
        args.putIfAbsent("value", () => value);
        result = await _channel.invokeMethod("write", args);
        break;
    }

    return result;
  }
}
