package com.stradaos.launcher;

import android.graphics.drawable.GradientDrawable;

/** Identidad visual y geometría; sin acceso a GPS, audio ni aplicaciones. */
final class OpelDesign {
    static final String ID = "opel_navi_900_modern";
    static final int BG = 0xFF080808;
    static final int CARD = 0xFF1C1C1C;
    static final int RED = 0xFFE52329;
    static final int MAP_EXTRA = 204;

    /** Paleta compartida por los widgets existentes, sin cambiar sus acciones. */
    static void applyPalette(boolean light) {
        Main.LIGHT = light;
        if (light) {
            Main.BG = 0xFFE9EDF1; Main.CARD = 0xFFFFFFFF; Main.INNER = 0xFFF2F4F6;
            Main.BTN = 0xFFDDE3E9; Main.DOCK = Main.BG; Main.TEXT = 0xFF191C21;
            Main.MUTED = 0xFF5D626B; Main.SOFT = 0xFF434951;
            Main.CIRCLE = 0xFFE3E7ED; Main.ICON = Main.SOFT;
            return;
        }
        Main.BG = BG; Main.CARD = CARD; Main.INNER = 0xFF252525;
        Main.BTN = 0xFF303030; Main.DOCK = BG; Main.TEXT = 0xFFF4F4F4;
        Main.MUTED = 0xFFA5A5A5; Main.SOFT = 0xFFC8CDD2;
        Main.CIRCLE = 0xFF252525; Main.ICON = Main.SOFT;
    }

    static GradientDrawable panel(int color, float scale) {
        GradientDrawable d = new GradientDrawable();
        d.setColor(color);
        d.setCornerRadius(4 * scale);
        d.setStroke(Math.max(1, (int) scale), Main.LIGHT ? 0xFFC8CDD4 : 0xFF414141);
        return d;
    }

    private OpelDesign() { }
}
