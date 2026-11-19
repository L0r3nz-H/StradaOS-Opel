package com.stradaos.launcher;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.view.View;

/** Landscape preview of the actual two-panel Opel dashboard and its four shortcuts. */
// Constructed only by the gallery with its shared vehicle bitmap, never XML-inflated.
@android.annotation.SuppressLint("ViewConstructor")
final class OpelThumb extends View {
    private final Bitmap vehicle;
    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG | Paint.FILTER_BITMAP_FLAG);
    private final RectF rect = new RectF();
    boolean selected;

    OpelThumb(Context context, Bitmap vehicle) {
        super(context);
        this.vehicle = vehicle;
        setContentDescription("Opel Style");
    }

    @Override protected void onMeasure(int widthSpec, int heightSpec) {
        int width = MeasureSpec.getSize(widthSpec);
        setMeasuredDimension(width, Math.round(width * 600f / 1024f));
    }

    private void rounded(Canvas canvas, float left, float top, float right, float bottom, float radius, int color) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(color);
        rect.set(left, top, right, bottom);
        canvas.drawRoundRect(rect, radius, radius, paint);
    }

    @Override protected void onDraw(Canvas canvas) {
        if (getWidth() <= 0 || getHeight() <= 0) return;
        canvas.save();
        canvas.scale(getWidth() / 1024f, getHeight() / 600f);
        boolean light = Main.LIGHT;
        int background = light ? 0xFFE9EDF1 : 0xFF17191D;
        int card = light ? 0xFFFFFFFF : 0xFF282B30;
        int text = light ? 0xFF191C21 : 0xFFF4F4F4;
        int muted = light ? 0xFF5D626B : 0xFFB4B8C0;
        int button = light ? 0xFFDDE3E9 : 0xFF32363B;
        rounded(canvas, 0, 0, 1024, 600, 20, background);
        rounded(canvas, 16, 16, 1008, 80, 14, OpelDesign.RED);
        paint.setColor(0xFFFFFFFF);
        paint.setTextSize(25);
        paint.setTextAlign(Paint.Align.LEFT);
        canvas.drawText("OPEL", 32, 58, paint);
        paint.setTextAlign(Paint.Align.CENTER);
        canvas.drawText("12:34", 512, 58, paint);
        rounded(canvas, 16, 96, 504, 436, 20, card);
        rounded(canvas, 520, 96, 1008, 436, 20, card);
        paint.setColor(text);
        paint.setTextSize(30);
        canvas.drawText("Astra J", 260, 162, paint);
        if (vehicle != null && !vehicle.isRecycled()) {
            float scale = Math.min(410f / vehicle.getWidth(), 235f / vehicle.getHeight());
            float width = vehicle.getWidth() * scale, height = vehicle.getHeight() * scale;
            rect.set(260 - width / 2, 290 - height / 2, 260 + width / 2, 290 + height / 2);
            canvas.drawBitmap(vehicle, null, rect, paint);
        }
        rounded(canvas, 552, 142, 652, 156, 7, muted);
        rounded(canvas, 552, 193, 944, 217, 10, text);
        rounded(canvas, 552, 242, 856, 256, 7, muted);
        for (int i = 0; i < 3; i++) {
            paint.setColor(i == 1 ? OpelDesign.RED : button);
            canvas.drawCircle(580 + i * 184, 376, i == 1 ? 40 : 36, paint);
        }
        for (int i = 0; i < 4; i++) {
            float x = 16 + i * 252;
            rounded(canvas, x, 452, x + 236, 584, 18, button);
            paint.setColor(OpelDesign.RED);
            canvas.drawCircle(x + 118, 497, 15, paint);
            rounded(canvas, x + 53, 538, x + 183, 550, 6, text);
        }
        if (selected) {
            paint.setStyle(Paint.Style.STROKE);
            paint.setStrokeWidth(8);
            paint.setColor(OpelDesign.RED);
            rect.set(4, 4, 1020, 596);
            canvas.drawRoundRect(rect, 18, 18, paint);
        }
        canvas.restore();
    }
}
