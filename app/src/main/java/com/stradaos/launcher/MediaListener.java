package com.stradaos.launcher;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

/** Necesario para leer las sesiones multimedia en Android 5+ (el usuario lo activa en "Acceso a notificaciones"). */
@android.annotation.TargetApi(18)
public class MediaListener extends NotificationListenerService {
    static boolean connected;
    @Override public void onListenerConnected() { connected = true; if (android.os.Build.VERSION.SDK_INT >= 21) MediaWatcher.kick(this); }
    @Override public void onListenerDisconnected() { connected = false; }
    @Override public void onNotificationPosted(StatusBarNotification sbn) { }
    @Override public void onNotificationRemoved(StatusBarNotification sbn) { }
}
