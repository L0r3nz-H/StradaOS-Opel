package com.stradaos.launcher;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/** «Abrir StradaOS al encender»: para pantallas que siempre arrancan en su menú de fábrica (funciona en Android 4 a 9). */
public class BootReceiver extends BroadcastReceiver {
    static boolean isBootAction(String action) {
        return Intent.ACTION_BOOT_COMPLETED.equals(action)
                || "android.intent.action.QUICKBOOT_POWERON".equals(action)
                || "com.htc.intent.action.QUICKBOOT_POWERON".equals(action);
    }

    @Override public void onReceive(Context c, Intent i) {
        if (i == null || !isBootAction(i.getAction())) return;
        if (!c.getSharedPreferences("launcher", 0).getBoolean("boot_open", false)) return;
        try {
            c.startActivity(new Intent(c, Main.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_REORDER_TO_FRONT));
        } catch (Throwable ignored) { }
    }
}
