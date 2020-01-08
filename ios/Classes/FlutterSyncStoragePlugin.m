#import "FlutterSyncStoragePlugin.h"
#if __has_include(<flutter_sync_storage/flutter_sync_storage-Swift.h>)
#import <flutter_sync_storage/flutter_sync_storage-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_sync_storage-Swift.h"
#endif

@implementation FlutterSyncStoragePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSyncStoragePlugin registerWithRegistrar:registrar];
}
@end
