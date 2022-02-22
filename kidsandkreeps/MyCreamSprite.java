package com.alexandergeckert.kidsandkreeps;

import android.graphics.Bitmap;
import android.graphics.Canvas;

class MyCreamSprite {

    private Bitmap image1;
    private Bitmap image2;
    private int yY;
    private int xX;
    boolean notGot = false;
    boolean show = false;

    MyCreamSprite(Bitmap bmp1, Bitmap bmp2, int x, int y) {
        image1 = bmp1;
        image2 = bmp2;
        yY = y;
        xX = x;
    }

    void draw(Canvas canvas) {
        if (show) {
            if (!notGot) {
                canvas.drawBitmap(image1, xX, yY, null);
            } else {
                canvas.drawBitmap(image2, xX, yY, null);
            }
        }

    }
}
