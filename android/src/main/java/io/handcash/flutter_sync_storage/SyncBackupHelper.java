package io.handcash.flutter_sync_storage;

import android.app.backup.BackupAgentHelper;
import android.app.backup.SharedPreferencesBackupHelper;

class SyncBackupHelper extends BackupAgentHelper {

    // The name of the SharedPreferences file
    static final String PREFS = "io.handcash.flutter_sync_storage.android_backup";

    // A key to uniquely identify the set of backup data
    static final String PREFS_BACKUP_KEY = "backup";

    // Allocate a helper and add it to the backup agent
    @Override
    public void onCreate() {
        SharedPreferencesBackupHelper helper =
                new SharedPreferencesBackupHelper(this, PREFS);
        addHelper(PREFS_BACKUP_KEY, helper);
    }
}