package com.stradaos.launcher;

import org.junit.Test;
import static org.junit.Assert.*;

public class BootReceiverTest {
    @Test public void acceptsOnlyDeclaredBootActions() {
        assertTrue(BootReceiver.isBootAction("android.intent.action.BOOT_COMPLETED"));
        assertTrue(BootReceiver.isBootAction("android.intent.action.QUICKBOOT_POWERON"));
        assertTrue(BootReceiver.isBootAction("com.htc.intent.action.QUICKBOOT_POWERON"));
        assertFalse(BootReceiver.isBootAction(null));
        assertFalse(BootReceiver.isBootAction(""));
        assertFalse(BootReceiver.isBootAction("android.intent.action.MAIN"));
        assertFalse(BootReceiver.isBootAction("arbitrary.sender.SPOOFED_BOOT"));
    }
}
