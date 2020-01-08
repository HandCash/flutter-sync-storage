import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sync_storage/flutter_sync_storage.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_sync_storage');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case "read":
          if (methodCall.arguments == "some") {
            return 'ok';
          } else {
            return null;
          }
          break;
        case "write":
          Map<dynamic, dynamic> args = methodCall.arguments;
          if (args.containsKey("key") && args.containsKey("value")) {
            bool correct = (args["key"] == "words" &&
                args["value"] == "1 2 3 4 5 6 7 8 9 10 11 12");
            return correct;
          } else {
            return null;
          }
          break;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group("read", () {
    test('read successfully', () async {
      expect(await FlutterSyncStorage().read("some"), "ok");
    });

    test('read error', () async {
      expect(await FlutterSyncStorage().read("key"), null);
    });
  });

  group("write", () {
    test("write successfully", () async {
      expect(
          await FlutterSyncStorage()
              .write("words", "1 2 3 4 5 6 7 8 9 10 11 12"),
          true);
    });

    test("write error", () async {
      expect(await FlutterSyncStorage().write("words", null), false);
    });
  });
}
