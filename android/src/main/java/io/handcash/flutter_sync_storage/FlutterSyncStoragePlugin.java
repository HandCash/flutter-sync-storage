package io.handcash.flutter_sync_storage;

import android.app.backup.BackupManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


/**
 * FlutterSyncStoragePlugin
 */
public class FlutterSyncStoragePlugin implements FlutterPlugin, MethodCallHandler {

    private SharedPreferences sharedPreferences;
    private BackupManager backupManager;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),
                "flutter_sync_storage");
        channel.setMethodCallHandler(new FlutterSyncStoragePlugin(flutterPluginBinding.getApplicationContext()));
    }

    // This static function is optional and equivalent to onAttachedToEngine. It
    // supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new
    // Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith
    // to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith
    // will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both
    // be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_sync_storage");
        channel.setMethodCallHandler(new FlutterSyncStoragePlugin(registrar.context()));
    }

    public FlutterSyncStoragePlugin(Context context) {
        sharedPreferences = context.getSharedPreferences(SyncBackupHelper.PREFS, Context.MODE_PRIVATE);
        backupManager = new BackupManager(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("read")) {
            read(call, result);
        } else if (call.method.equals("write")) {
            write(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void write(MethodCall call, Result result) {
        SharedPreferences.Editor editor = sharedPreferences.edit();

        if (call.arguments == null || !call.hasArgument("key") || !call.hasArgument("value")) {
            result.error("2", "Invalid arguments, must be a 2 element Map<String, String> containing key and value", null);
            return;
        }

        editor.putString(String.valueOf(call.argument("key")), String.valueOf(call.argument("value")));
        editor.commit();

        backupManager.dataChanged();
        result.success(true);
    }

    private void read(MethodCall call, Result result) {
        String key = String.valueOf(call.arguments);
        result.success(sharedPreferences.getString(key, ""));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
