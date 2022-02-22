package com.alexandergeckert.kidsandkreeps;

import android.graphics.Bitmap;
import android.graphics.Canvas;

class TrashSprite {

    private Bitmap image;
    int yY;
    private int xX;
    private boolean food;
    private boolean eaten = false;
    private boolean touched;

    TrashSprite (Bitmap bmp, int x, int y, boolean foods) {
        image = bmp;
        yY = y;
        xX = x;
        food = foods;
    }

    void draw(Canvas canvas) {
        if (!eaten) {
            canvas.drawBitmap(image, xX, yY, null);
        }
    }

    void update() {
        if (GameView.tutAnim) {
            yY += GameView.velocity;
        }
        if (GameView.touching && !GameView.tutAnim) {
            if ((GameView.xTouch >= xX && GameView.xTouch <= (xX + (GameView.hHeight / 5))) && (GameView.yTouch >= yY && GameView.yTouch <= (yY + (GameView.hHeight / 5)))) {
                touched = true;
            }
        }
        if (touched) {
            xX = GameView.xTouch - (GameView.hHeight / 10);
            yY = GameView.yTouch - (GameView.hHeight / 10);
        }
        if (!GameView.touching && !GameView.tutAnim) {
            yY += ((GameView.hHeight * 1.2) / GameView.garbageSpeed) / 30;
            touched = false;
        }
        if (GameView.touching && !((GameView.xTouch >= xX && GameView.xTouch <= (xX + (GameView.hHeight / 5))) && (GameView.yTouch >= yY && GameView.yTouch <= (yY + (GameView.hHeight / 5))))) {
            yY += ((GameView.hHeight * 1.2) / GameView.garbageSpeed) / 30;
        }
        if (GameView.levelStarted && !eaten) {
            physics();
        }
    }

    private void physics() {
        //Test if touching a monster
        if (yY >= (GameView.hHeight * 0.5) && xX <= ((GameView.wWidth / 5) + (GameView.hHeight / 2))) {
            if (food) {
                score(false);
                GameView.monsterBad = true;
                GameView.monsterGood = false;
                MainActivity.playSound(16, 1, false);
            } else {
                score(true);
                GameView.monsterGood = true;
                GameView.monsterBad = false;
                MainActivity.playSound(17, 1, false);
            }
            eaten = true;
            GameView.sorted++;
            GameView.kidGood = false;
            GameView.kidBad = false;
        }
        //Test if touching a kid
        if (yY >= (GameView.hHeight * 0.5) && xX >= GameView.wWidth * 0.6) {
            if (food) {
                score(true);
                GameView.kidGood = true;
                GameView.kidBad = false;
                MainActivity.playSound(3, 1, false);
            } else {
                score(false);
                GameView.kidBad = true;
                GameView.kidGood = false;
                MainActivity.playSound(2, 1, false);
            }
            eaten = true;
            GameView.sorted++;
            GameView.monsterGood = false;
            GameView.monsterBad = false;
        }
        //Test if touching ground
        if (yY >= (GameView.hHeight - (GameView.hHeight / 10))) {
            eaten = true;
            score(false);
            GameView.sorted++;
        }
    }

    private void score(boolean good) {
        if (good) {
            GameView.points ++;
            if (GameView.combo) {
                GameView.points ++;
            } else {
                GameView.combo = true;
            }
        } else {
            GameView.combo = false;
        }
    }
}
