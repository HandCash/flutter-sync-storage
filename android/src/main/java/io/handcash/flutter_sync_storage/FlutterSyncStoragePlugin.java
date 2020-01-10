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
import io.flutter.plugin.common.BinaryMessenger;
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
    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.sharedPreferences = applicationContext.getSharedPreferences(SyncBackupHelper.PREFS, Context.MODE_PRIVATE);
        this.backupManager = new BackupManager(applicationContext);

        methodChannel = new MethodChannel(messenger,
                "flutter_sync_storage");
        methodChannel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It
    // supports the old
    // pre-Flutter-1.12 Android projects.
    public static void registerWith(Registrar registrar) {
        final FlutterSyncStoragePlugin instance = new FlutterSyncStoragePlugin();
        instance.onAttachedToEngine(registrar.context(),registrar.messenger());
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
        this.sharedPreferences = null;
        this.backupManager = null;
        this.methodChannel.setMethodCallHandler(null);
        this.methodChannel = null;
    }
}
