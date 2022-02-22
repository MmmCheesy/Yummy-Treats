package com.alexandergeckert.kidsandkreeps;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.SurfaceHolder;

import java.util.Random;

public class GameView extends SurfaceView implements SurfaceHolder.Callback {

    //thread and stuff
    private MainThread thread;

    //scene Bitmaps
    private Bitmap background = BitmapFactory.decodeResource(getResources(),R.drawable.bg1);
    private Bitmap bg;
    private Bitmap kidsAndKreeps = BitmapFactory.decodeResource(getResources(),R.drawable.kidskreeps);
    private Bitmap Volcano1 = BitmapFactory.decodeResource(getResources(),R.drawable.volcano1);
    private Bitmap volcano1;
    private Bitmap Volcano2 = BitmapFactory.decodeResource(getResources(),R.drawable.volcano2);
    private Bitmap Lava = BitmapFactory.decodeResource(getResources(),R.drawable.lava);
    private Bitmap CloudOne = BitmapFactory.decodeResource(getResources(),R.drawable.cloud1);
    private Bitmap cloud1;
    private Bitmap CloudTwo = BitmapFactory.decodeResource(getResources(),R.drawable.cloud2);
    private Bitmap cloud2;
    private Bitmap Tip1 = BitmapFactory.decodeResource(getResources(),R.drawable.tip1);
    private Bitmap tip1;
    private Bitmap LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev1);
    private Bitmap GoSign = BitmapFactory.decodeResource(getResources(),R.drawable.gosign);
    private Bitmap EndScreen = BitmapFactory.decodeResource(getResources(),R.drawable.endscreen);

    //scene booleans
    public static boolean levelStarted = false;
    public static boolean tutAnim = false;
    public static boolean openingDone = false;
    public static boolean volcanoErupt = false;
    public static boolean touching = false;
    public static boolean combo = false;
    public static boolean kidGood = false;
    public static boolean kidBad = false;
    public static boolean monsterGood = false;
    public static boolean monsterBad = false;

    //level variables
    int garbageCount = 8; //make one less than actual amount
    int foodCount = 0; //live count of food that has fallen per level
    public static int garbageSpeed = 8; //amount of seconds it will take for the garbage to fall the height of the screen
    int garbageDelay = 90; //30 is one second
    int level = 1;

    //ice cream and interjections
    public MyCreamSprite cream1, cream2, cream3, cream4, cream5;
    private Bitmap interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection1);
    private Boolean showInterjection = false;

    //scene integers
    int xPosition = 0;
    int yPosition = 0;
    int size = 0;
    int time = 0;
    int rumbley = 0;
    int count = 0;
    public static int sorted = 0;
    public static int xTouch = 0;
    public static int yTouch = 0;
    public static int points = -1;
    int currentScore = 0;
    int highScore = 0;

    //Kids and Monsters Bitmaps
    private Bitmap KidOne = BitmapFactory.decodeResource(getResources(),R.drawable.kid1q1);
    private Bitmap Kid;
    private Bitmap MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q1);
    private Bitmap Monster;
    private Bitmap KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid1q2);
    private Bitmap KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid1q3);
    private Bitmap MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q2);
    private Bitmap MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q3);

    //food and trash sprites
    public TrashSprite trashSprite, foodSprite;

    //Scene constants
    public static int hHeight = Resources.getSystem().getDisplayMetrics().heightPixels;
    public static int wWidth = Resources.getSystem().getDisplayMetrics().widthPixels;
    public static int velocity = hHeight / 180;

    //random needed but junk variables
    boolean erupted = false;
    int volcanoXscale, lavaYscale = 0;
    boolean growing = false;
    boolean growing2 = false;
    boolean goingUp = false;
    public TrashSprite object1, object2, object3, object4;
    boolean objectUpdate1, objectUpdate2, objectUpdate3, objectUpdate4 = false;
    boolean cloudPart1Done = false;
    boolean showText = false;
    boolean bgChange = false;
    private int goX = 0;
    private boolean goGrow = false;
    private boolean showEndScreen = false;
    private boolean showScore = false;
    private int monsterSize = 0;
    private int monsterTime = 0;

    public GameView(Context context) {
        super(context);

        getHolder().addCallback(this);

        thread = new MainThread(getHolder(), this);
        setFocusable(true);
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height){

    }

    @Override
    public void surfaceCreated(SurfaceHolder holder){
        thread.setRunning(true);
        thread.start();

        //reset the game
        //MainActivity.storeDefaults("lev", 1);
        //MainActivity.storeDefaults("high", 0);
        //MainActivity.storeDefaults("current", 0);
        level = MainActivity.returnDefaults("lev", 1);
        currentScore = MainActivity.returnDefaults("current", 0);
        highScore = MainActivity.returnDefaults("high", 0);

        bg = Bitmap.createScaledBitmap(background, wWidth, hHeight, false);
        volcano1 = Bitmap.createScaledBitmap(Volcano1, (int) (hHeight / 2.5), hHeight / 3, false);
        cloud1 = Bitmap.createScaledBitmap(CloudOne, wWidth, hHeight, false);
        cloud2 = Bitmap.createScaledBitmap(CloudTwo, wWidth, hHeight, false);
        tip1 = Bitmap.createScaledBitmap(Tip1, wWidth, hHeight, false);

        Kid = Bitmap.createScaledBitmap(KidOne, (hHeight / 2), (hHeight / 2), false);
        Monster = Bitmap.createScaledBitmap(MonsterOne, (hHeight / 2), (hHeight / 2), false);

        trashSprite = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash1), (hHeight / 5), (hHeight / 5), false), wWidth / 5, (int) (hHeight * -0.6), false);
        foodSprite = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food1), (hHeight / 5), (hHeight / 5), false), (int) (wWidth * 0.7), (int) (hHeight * -0.3), true);

        Bitmap imageOne = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.icecream1), (hHeight / 5), (hHeight / 5), false);
        Bitmap imageTwo = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.icecream2), (hHeight / 5), (hHeight / 5), false);
        cream1 = new MyCreamSprite(imageOne, imageTwo, wWidth / 7, (int) (hHeight / 1.8));
        cream2 = new MyCreamSprite(imageOne, imageTwo, wWidth * 2/7, (int) (hHeight / 1.8));
        cream3 = new MyCreamSprite(imageOne, imageTwo, wWidth * 3/7, (int) (hHeight / 1.8));
        cream4 = new MyCreamSprite(imageOne, imageTwo, wWidth * 4/7, (int) (hHeight / 1.8));
        cream5 = new MyCreamSprite(imageOne, imageTwo, wWidth * 5/7, (int) (hHeight / 1.8));
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder){
        boolean retry = true;
        while (retry) {
            try {
                thread.setRunning(false);
                thread.join();
            }catch (InterruptedException e){
                e.printStackTrace();
            }
            retry = false;
        }
    }

    @Override
    public void draw(Canvas canvas){
        super.draw(canvas);
        if (canvas != null){
            canvas.drawBitmap(bg, 0, 0, null);

            if (!erupted && level == 1) {
                canvas.drawBitmap(volcano1, (int) (wWidth - (hHeight / 2.5)), rumbley, null);
            } else if (erupted && level == 1) {
                Bitmap volcano2 = Bitmap.createScaledBitmap(Volcano2, (int) (hHeight / 2.5) + volcanoXscale, hHeight / 3, false);
                Bitmap lava = Bitmap.createScaledBitmap(Lava, (int) (hHeight / 2.5), (hHeight / 3) + lavaYscale, false);
                canvas.drawBitmap(volcano2, (int) (wWidth - (hHeight / 2.5)) - (volcanoXscale / 2), 0, null);
                canvas.drawBitmap(lava, (int) (wWidth - (hHeight / 2.5)), 0 - (lavaYscale / 2), null);
            }

            canvas.drawBitmap(Kid, (float) (wWidth * 0.6), (float) (hHeight * 0.5), null);
            if (!tutAnim) {
                canvas.drawBitmap(Monster, wWidth / 7, (float) (hHeight * 0.5), null);
            }

            if (objectUpdate1) {
                object1.draw(canvas);
            }
            if (objectUpdate2) {
                object2.draw(canvas);
            }
            if (objectUpdate3) {
                object3.draw(canvas);
            }
            if (objectUpdate4) {
                object4.draw(canvas);
            }

            if (tutAnim) {
                trashSprite.draw(canvas);
                foodSprite.draw(canvas);
                if (level == 1) {
                    canvas.drawBitmap(tip1, 0, 0, null);
                }
                Bitmap goSign = Bitmap.createScaledBitmap(GoSign, wWidth + goX, hHeight + goX, false);
                canvas.drawBitmap(goSign, goX / -2, goX / -2, null);
                Monster = Bitmap.createScaledBitmap(MonsterOne, (hHeight / 2), (hHeight / 2) + monsterSize, false);
                canvas.drawBitmap(Monster, wWidth / 7, (float) (hHeight * 0.5) - monsterSize, null);
            }
            if (!openingDone) {
                if (showEndScreen) {
                    Bitmap endScreen = Bitmap.createScaledBitmap(EndScreen, wWidth, hHeight, false);
                    canvas.drawBitmap(endScreen, 0, 0, null);
                }
                canvas.drawBitmap(cloud1, 0 - xPosition, 0, null);
                canvas.drawBitmap(cloud2, xPosition, 0, null);
                if (!cloudPart1Done) {
                    Bitmap kidskreeps = Bitmap.createScaledBitmap(kidsAndKreeps, (int) (wWidth * 0.9) + size, ((int) (wWidth * 0.9) / 3) + (size / 3), false);
                    canvas.drawBitmap(kidskreeps, (float) (wWidth * 0.05), ((hHeight / 2) - (hHeight / 5)) - yPosition, null);
                }
                if (showText) {
                    Bitmap lev1 = Bitmap.createScaledBitmap(LevOn, size, size / 3, false);
                    canvas.drawBitmap(lev1, (float) (wWidth * 0.02), ((hHeight / 2) - (int) (hHeight / 4.5)) - yPosition, null);
                }
                if (showInterjection) {
                    Bitmap interjection = Bitmap.createScaledBitmap(interjectionImage, (int) (wWidth * 0.9) + size, ((int) (wWidth * 0.9) / 3) + (size / 3), false);
                    canvas.drawBitmap(interjection, (float) (wWidth * 0.02), hHeight / 5, null);
                }
                if (showScore) {
                    Paint paint = new Paint();
                    paint.setColor(getResources().getColor(R.color.orange));
                    paint.setTextSize(hHeight / 13);
                    canvas.drawText("Score: " + currentScore, (float) (wWidth * 0.15), hHeight / 5, paint);
                    canvas.drawText("High Score: " + highScore, (float) (wWidth * 0.6), hHeight / 5, paint);
                }
                cream1.draw(canvas);
                cream2.draw(canvas);
                cream3.draw(canvas);
                cream4.draw(canvas);
                cream5.draw(canvas);
            }
            if (kidGood) {
                Bitmap kidYum = Bitmap.createScaledBitmap(KidYum, (hHeight / 2), (hHeight / 2), false);
                canvas.drawBitmap(kidYum, (float) (wWidth * 0.6), (float) (hHeight * 0.5), null);
            }
            if (kidBad) {
                Bitmap kidYuk = Bitmap.createScaledBitmap(KidYuk, (hHeight / 2), (hHeight / 2), false);
                canvas.drawBitmap(kidYuk, (float) (wWidth * 0.6), (float) (hHeight * 0.5), null);
            }
            if (monsterGood) {
                Bitmap monsterYum = Bitmap.createScaledBitmap(MonsterYum, (hHeight / 2), (hHeight / 2), false);
                canvas.drawBitmap(monsterYum, wWidth / 7, (float) (hHeight * 0.5), null);
            }
            if (monsterBad) {
                Bitmap monsterYuk = Bitmap.createScaledBitmap(MonsterYuk, (hHeight / 2), (hHeight / 2), false);
                canvas.drawBitmap(monsterYuk, wWidth / 7, (float) (hHeight * 0.5), null);
            }
        }
    }

    public void update(){
        if (!openingDone && !levelStarted) {
            animation(level);
        }
        if (tutAnim) {
            tutorialAnimation();
            trashSprite.update();
            foodSprite.update();
        }
        if (volcanoErupt) {
            volcanoEruption();
        }
        if (erupted && levelStarted) {
            foodFall();
        }
        if (objectUpdate1) {
            object1.update();
        }
        if (objectUpdate2) {
            object2.update();
        }
        if (objectUpdate3) {
            object3.update();
        }
        if (objectUpdate4) {
            object4.update();
        }
        if (sorted - 1 == garbageCount) {
            sorted = 0;
            foodCount = 0;
            objectUpdate1 = false;
            objectUpdate2 = false;
            objectUpdate3 = false;
            objectUpdate4 = false;
            levelStarted = false;
            volcanoErupt = false;
            kidGood = false;
            kidBad = false;
            monsterGood = false;
            monsterBad = false;
            erupted = false;
            if (level == 5) {
                MainActivity.storeDefaults("lev", 1);
                level = 1;
            } else {
                MainActivity.storeDefaults("lev", level + 1);
                level = level + 1;
            }
            time = 0;
            animation(level);
        }
        if (foodCount == garbageCount && sorted - 1 != garbageCount) {
            monsterTime++;
            if (monsterTime == garbageDelay * 2) {
                sorted = garbageCount + 1;
                monsterTime = 0;
            }
        }
    }

    public void startLevel(int lvl){
        foodCount = 0;
        count = 0;
        points = 0;
        monsterTime = 0;
        monsterSize = 0;
        showScore = false;
        MainActivity.stopSound();
        cream5.notGot = false;
        cream4.notGot = false;
        cream3.notGot = false;
        cream2.notGot = false;
        cream1.notGot = false;
        if (lvl == 1) {
            tutAnim = false;
            levelStarted = true;
            volcanoErupt = true;
            garbageDelay = 120;
            garbageSpeed = 8;
            garbageCount = 6;
            MainActivity.storeDefaults("current", 0);
        } else if (lvl == 2) {
            tutAnim = false;
            levelStarted = true;
            erupted = true;
            garbageDelay = 120;
            garbageSpeed = 6;
            garbageCount = 10;
        } else if (lvl == 3) {
            tutAnim = false;
            levelStarted = true;
            erupted = true;
            garbageDelay = 60;
            garbageSpeed = 14;
            garbageCount = 15;
        } else if (lvl == 4) {
            tutAnim = false;
            levelStarted = true;
            erupted = true;
            garbageDelay = 120;
            garbageSpeed = 4;
            garbageCount = 12;
        } else if (lvl == 5) {
            tutAnim = false;
            levelStarted = true;
            erupted = true;
            garbageDelay = 50;
            garbageSpeed = 16;
            garbageCount = 20;
        }
        Monster = Bitmap.createScaledBitmap(MonsterOne, (hHeight / 2), (hHeight / 2), false);
    }

    public void foodFall(){
        if (foodCount == 0) {
            time = garbageDelay;
        }
        if (time == garbageDelay) {

            time = 0;

            int objectSpawned = randomInt(1, 6);
            int positionSpawned = randomInt(-(wWidth / 4), wWidth / 4);

            if (foodCount == 0 || foodCount == 4 || foodCount == 8 || foodCount == 12 || foodCount == 16) {
                if (objectSpawned == 1) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food1), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 2) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food2), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 3) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food3), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 4) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash1), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 5) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash2), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 6) {
                    object1 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash3), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                }
                objectUpdate1 = true;
            } else if (foodCount == 1 || foodCount == 5 || foodCount == 9 || foodCount == 13 || foodCount == 17) {
                if (objectSpawned == 1) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash4), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 2) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash5), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 3) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash6), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 4) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food4), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 5) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food5), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 6) {
                    object2 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food6), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                }
                objectUpdate2 = true;
            } else if (foodCount == 2 || foodCount == 6 || foodCount == 10 || foodCount == 14 || foodCount == 18) {
                if (objectSpawned == 1) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food1), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 2) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food2), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 3) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash7), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 4) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash8), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 5) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash9), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 6) {
                    object3 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash10), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                }
                objectUpdate3 = true;
            } else if (foodCount == 3 || foodCount == 7 || foodCount == 11 || foodCount == 15 || foodCount == 19) {
                if (objectSpawned == 1) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash11), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 2) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash12), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 3) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash13), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 4) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash14), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, false);
                } else if (objectSpawned == 5) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food5), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                } else if (objectSpawned == 6) {
                    object4 = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food6), (hHeight / 5), (hHeight / 5), false), (wWidth / 2) + positionSpawned, hHeight / -10, true);
                }
                objectUpdate4 = true;
            }

            if (foodCount != garbageCount) {
                foodCount += 1;
            } else {
                erupted = false;
            }
        } else {
            time++;
        }
    }

    public void showScore() {
        if (time == 30) {
            int total = (2*garbageCount)+1;
            double scored = (double) ((5 * points)/(total));
            int totalScore = (int) scored;
            if (totalScore == 0) {
                cream5.notGot = true;
                cream4.notGot = true;
                cream3.notGot = true;
                cream2.notGot = true;
                cream1.notGot = true;
            } else if (totalScore == 1) {
                cream5.notGot = true;
                cream4.notGot = true;
                cream3.notGot = true;
                cream2.notGot = true;
                interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection1);
            } else if (totalScore == 2) {
                cream5.notGot = true;
                cream4.notGot = true;
                cream3.notGot = true;
                interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection2);
            } else if (totalScore == 3) {
                cream5.notGot = true;
                cream4.notGot = true;
                interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection3);
            } else if (totalScore == 4) {
                cream5.notGot = true;
                interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection4);
            } else if (totalScore == 5) {
                interjectionImage = BitmapFactory.decodeResource(getResources(),R.drawable.interjection5);
            }
            showInterjection = true;
            showScore = true;
            currentScore = MainActivity.returnDefaults("current", 0);
            highScore = MainActivity.returnDefaults("high", 0);
            currentScore = currentScore + (int) (scored);
            highScore = highScore + (int) (scored);
            MainActivity.storeDefaults("high", highScore);
            MainActivity.storeDefaults("current", currentScore);
        }
        if (time >= 30 && time <= 90) {
            size += (int) (wWidth * 0.9)/60;
        }
        if (time == 90) {
            cream1.show = true;
        }
        if (time == 100) {
            cream2.show = true;
        }
        if (time == 110) {
            cream3.show = true;
        }
        if (time == 120) {
            cream4.show = true;
        }
        if (time == 130) {
            cream5.show = true;
        }
        if (time == 180) {
            cream1.show = false;
            cream2.show = false;
            cream3.show = false;
            cream4.show = false;
            cream5.show = false;
        }
        if (time == 240) {
            showInterjection = false;
        }
    }

    public void volcanoEruption() {
        if (rumbley >= hHeight / 30 && !goingUp) {
            goingUp = true;
            count += 1;
        } else if (rumbley <= hHeight / -30 && goingUp) {
            goingUp = false;
        } else if (count == 8) {
            erupted = true;
            if (volcanoXscale >= ((hHeight / 2.5) * 0.1) && growing) {
                growing = false;
            } else if (volcanoXscale <= -((hHeight / 2.5) * 0.1) && !growing) {
                growing = true;
            }
            if (growing) {
                volcanoXscale += 3;
            } else {
                volcanoXscale -= 3;
            }

            if (lavaYscale >= ((hHeight / 2.5) * 0.3) && growing2) {
                growing2 = false;
            } else if (lavaYscale <= ((hHeight / 2.5) * 0.1) && !growing2) {
                growing2 = true;
            }
            if (growing2) {
                lavaYscale += 2;
            } else {
                lavaYscale -= 2;
            }
        }
        if (goingUp && !erupted && count != 2 && count != 5) {
            rumbley -= hHeight / 90;
        } else if (!goingUp && !erupted && count != 2 && count != 5) {
            rumbley += hHeight / 90;
        } else if (count == 2) {
            rumbley = 0;
            if (time == 40) {
                count += 1;
                time = 0;
            } else {
                time ++;
            }
        } else if (count == 5) {
            rumbley = 0;
            if (time == 40) {
                count += 1;
                time = 0;
            } else {
                time ++;
            }
        }
    }

    public void animation(int anim) {
        if (time == 0) {
            cloudPart1Done = false;
            openingDone = false;
            size = (int) -(wWidth * 0.9);
            if (points != -1 || level != 1) {
                if (level == 1) {
                    LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev1);
                    KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid1q2);
                    KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid1q3);
                    MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q2);
                    MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q3);
                } else if (level == 2) {
                    LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev2);
                    KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid2q2);
                    KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid2q3);
                    MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster2q2);
                    MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster2q3);
                } else if (level == 3) {
                    LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev3);
                    KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid3q2);
                    KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid3q3);
                    MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster3q2);
                    MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster3q3);
                } else if (level == 4) {
                    LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev4);
                    KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid4q2);
                    KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid4q3);
                    MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster4q2);
                    MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster4q3);
                } else if (level == 5) {
                    LevOn = BitmapFactory.decodeResource(getResources(),R.drawable.lev5);
                    KidYum = BitmapFactory.decodeResource(getResources(),R.drawable.kid5q2);
                    KidYuk = BitmapFactory.decodeResource(getResources(),R.drawable.kid5q3);
                    MonsterYum = BitmapFactory.decodeResource(getResources(),R.drawable.monster5q2);
                    MonsterYuk = BitmapFactory.decodeResource(getResources(),R.drawable.monster5q3);
                }
            }
        }
        if (anim == 1) {
            time++;
            if (points == -1) {
                if (time == 180) {
                    bgChange = true;
                }
                if (time >= 30 && time <= 90) {
                    size += (int) (wWidth * 0.9) / 60;
                }
                if (time == 80) {
                    MainActivity.playSound(4, 1, false);
                }
                if (time >= 180 && time <= 270) {
                    size += (int) (wWidth * 0.9) / 90;
                    if (time == 240) {
                        cloudPart1Done = true; //remove kidskreeps logo
                    }
                }
                if (time == 270) {
                    MainActivity.playSound(6, 1, false);
                }
                if (time >= 210) {
                    showText = true;
                }
                if (time >= 360) {
                    xPosition += velocity * 3;
                    yPosition += velocity * 3;
                    size += velocity * 4;
                    if (xPosition >= (wWidth / 2) && !tutAnim) {
                        tutAnim = true;
                        MainActivity.playSound(11, 1, true);
                        monsterTime = 0;
                    }
                    if (xPosition >= wWidth) {
                        openingDone = true;
                        showText = false;
                        yPosition = 0;
                        size = 0;
                        time = 0;
                    }
                }
            } else {
                if ((xPosition >= 0 && time <= 90) || (xPosition >= 0 && time >= 360 && time <= 450)) {
                    xPosition -= wWidth / 85;
                }
                if (time == 30) {
                    MainActivity.playSound(5, 1, false);
                }
                if (time == 180) {bgChange = true; showEndScreen = true;}
                if (time >= 30 && time <= 270) {
                    cloudPart1Done = true;
                    showScore();
                    if (time >= 180) {
                        size += (int) (wWidth * 0.9) / 90;
                        xPosition += wWidth / 90;
                    }
                }
                if (time == 240) {
                    MainActivity.playSound(1, 1, false);
                }
                if (time == 285) {
                    MainActivity.playSound(1, 1, false);
                }
                if (time == 330) {
                    MainActivity.playSound(1, 1, false);
                }
                if (time == 450) { showText = true; size = 0; showEndScreen = false; }
                if (time >= 450 && time <= 540) {
                    size += (int) (wWidth * 0.9) / 90;
                }
                if (time == 540) {
                    MainActivity.playSound(6, 1, false);
                }
                if (time >= 600) {
                    xPosition += velocity * 3;
                    yPosition += velocity * 3;
                    size += velocity * 4;
                    if (xPosition >= (wWidth / 2) && !tutAnim) {
                        tutAnim = true;
                        MainActivity.playSound(11, 1, true);
                        monsterTime = 0;
                        showScore = false;
                    }
                    if (xPosition >= wWidth){
                        openingDone = true;
                        showText = false;
                        yPosition = 0;
                        size = 0;
                        time = 0;
                    }
                }
            }
        } else if (anim == 2) {
            if (time < 480) {
                time++;
            }
            if (time == 480) {
                time = 0;
            }
            if (xPosition != 0 && time < 300) {
                if (xPosition > 0) {
                    xPosition -= wWidth / 90;
                }
                if (time == 30) {
                    MainActivity.playSound(5, 1, false);
                }
            }
            if (time == 80 && xPosition == 0) {
                MainActivity.playSound(4, 1, false);
            }
            if (time == 180) {bgChange = true;}
            if (time >= 30 && time <= 90 && points == -1) {
                size += (int) (wWidth * 0.9)/60;
            }
            if (time >= 180 && time <= 270 && points == -1) {
                size += (int) (wWidth * 0.9)/90;
                if (time == 240) {
                    cloudPart1Done = true; //remove kidskreeps logo
                }
            }
            if (time == 270) {
                MainActivity.playSound(7, 1, false);
            }
            if (points != -1 && time >= 30 && time <= 270) {
                cloudPart1Done = true;
                showScore();
                if (time >= 180) {
                    size += (int) (wWidth * 0.9)/90;
                }
            }
            if (time >= 210) {
                showText = true;
            }
            if (time >= 360) {
                xPosition += velocity * 3;
                yPosition += velocity * 3;
                size += velocity * 4;
                if (xPosition >= (wWidth / 2) && !tutAnim) {
                    tutAnim = true;
                    MainActivity.playSound(12, 1, true);
                    monsterTime = 0;
                }
                if (xPosition >= wWidth){
                    openingDone = true;
                    showText = false;
                    yPosition = 0;
                    size = 0;
                    time = 0;
                }
            }
        } else if (anim == 3) {
            if (time < 480) {
                time++;
            }
            if (time == 480) {
                time = 0;
            }
            if (xPosition != 0 && time < 300) {
                if (xPosition > 0) {
                    xPosition -= wWidth / 90;
                }
                if (time == 30) {
                    MainActivity.playSound(5, 1, false);
                }
            }
            if (time == 80 && xPosition == 0) {
                MainActivity.playSound(4, 1, false);
            }
            if (time == 180) {bgChange = true;}
            if (time >= 30 && time <= 90 && points == -1) {
                size += (int) (wWidth * 0.9)/60;
            }
            if (time >= 180 && time <= 270 && points == -1) {
                size += (int) (wWidth * 0.9)/90;
                if (time == 240) {
                    cloudPart1Done = true; //remove kidskreeps logo
                }
            }
            if (time == 270) {
                MainActivity.playSound(8, 1, false);
            }
            if (points != -1 && time >= 30 && time <= 270) {
                cloudPart1Done = true;
                showScore();
                if (time >= 180) {
                    size += (int) (wWidth * 0.9)/90;
                }
            }
            if (time >= 210) {
                showText = true;
            }
            if (time >= 360) {
                xPosition += velocity * 3;
                yPosition += velocity * 3;
                size += velocity * 4;
                if (xPosition >= (wWidth / 2) && !tutAnim) {
                    tutAnim = true;
                    MainActivity.playSound(13, 1, true);
                    monsterTime = 0;
                }
                if (xPosition >= wWidth){
                    openingDone = true;
                    showText = false;
                    yPosition = 0;
                    size = 0;
                    time = 0;
                }
            }
        } else if (anim == 4) {
            if (time < 480) {
                time++;
            }
            if (time == 480) {
                time = 0;
            }
            if (xPosition != 0 && time < 300) {
                if (xPosition > 0) {
                    xPosition -= wWidth / 90;
                }
                if (time == 30) {
                    MainActivity.playSound(5, 1, false);
                }
            }
            if (time == 80 && xPosition == 0) {
                MainActivity.playSound(4, 1, false);
            }
            if (time == 180) {bgChange = true;}
            if (time >= 30 && time <= 90 && points == -1) {
                size += (int) (wWidth * 0.9)/60;
            }
            if (time >= 180 && time <= 270 && points == -1) {
                size += (int) (wWidth * 0.9)/90;
                if (time == 240) {
                    cloudPart1Done = true; //remove kidskreeps logo
                }
            }
            if (time == 270) {
                MainActivity.playSound(9, 1, false);
            }
            if (points != -1 && time >= 30 && time <= 270) {
                cloudPart1Done = true;
                showScore();
                if (time >= 180) {
                    size += (int) (wWidth * 0.9)/90;
                }
            }
            if (time >= 210) {
                showText = true;
            }
            if (time >= 360) {
                xPosition += velocity * 3;
                yPosition += velocity * 3;
                size += velocity * 4;
                if (xPosition >= (wWidth / 2) && !tutAnim) {
                    tutAnim = true;
                    MainActivity.playSound(14, 1, true);
                    monsterTime = 0;
                }
                if (xPosition >= wWidth){
                    openingDone = true;
                    showText = false;
                    yPosition = 0;
                    size = 0;
                    time = 0;
                }
            }
        } else if (anim == 5) {
            if (time < 480) {
                time++;
            }
            if (time == 480) {
                time = 0;
            }
            if (xPosition != 0 && time < 300) {
                if (xPosition > 0) {
                    xPosition -= wWidth / 90;
                }
                if (time == 30) {
                    MainActivity.playSound(5, 1, false);
                }
            }
            if (time == 80 && xPosition == 0) {
                MainActivity.playSound(4, 1, false);
            }
            if (time == 180) {bgChange = true;}
            if (time >= 30 && time <= 90 && points == -1) {
                size += (int) (wWidth * 0.9)/60;
            }
            if (time >= 180 && time <= 270 && points == -1) {
                size += (int) (wWidth * 0.9)/90;
                if (time == 240) {
                    cloudPart1Done = true; //remove kidskreeps logo
                }
            }
            if (points != -1 && time >= 30 && time <= 270) {
                cloudPart1Done = true;
                showScore();
                if (time >= 180) {
                    size += (int) (wWidth * 0.9)/90;
                }
            }
            if (time == 270) {
                MainActivity.playSound(10, 1, false);
            }
            if (time >= 210) {
                showText = true;
            }
            if (time >= 360) {
                xPosition += velocity * 3;
                yPosition += velocity * 3;
                size += velocity * 4;
                if (xPosition >= (wWidth / 2) && !tutAnim) {
                    tutAnim = true;
                    MainActivity.playSound(15, 1, true);
                    monsterTime = 0;
                }
                if (xPosition >= wWidth){
                    openingDone = true;
                    showText = false;
                    yPosition = 0;
                    size = 0;
                    time = 0;
                }
            }
        }
        if (bgChange) {
            bgChange = false;
            trashSprite.yY = (int) (hHeight * -0.6);
            foodSprite.yY = (int) (hHeight * -0.3);
            if (level == 1) {
                bg = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.bg1), wWidth, hHeight, false);
                Kid = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.kid1q1), (hHeight / 2), (hHeight / 2), false);
                Monster = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.monster1q1), (hHeight / 2), (hHeight / 2), false);
                MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster1q1);
            } else if (level == 2) {
                bg = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.bg2), wWidth, hHeight, false);
                Kid = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.kid2q1), (hHeight / 2), (hHeight / 2), false);
                Monster = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.monster2q1), (hHeight / 2), (hHeight / 2), false);
                MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster2q1);
            } else if (level == 3) {
                bg = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.bg3), wWidth, hHeight, false);
                Kid = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.kid3q1), (hHeight / 2), (hHeight / 2), false);
                Monster = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.monster3q1), (hHeight / 2), (hHeight / 2), false);
                MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster3q1);
            } else if (level == 4) {
                bg = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.bg4), wWidth, hHeight, false);
                Kid = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.kid4q1), (hHeight / 2), (hHeight / 2), false);
                Monster = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.monster4q1), (hHeight / 2), (hHeight / 2), false);
                MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster4q1);
            } else {
                bg = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.bg5), wWidth, hHeight, false);
                Kid = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.kid5q1), (hHeight / 2), (hHeight / 2), false);
                Monster = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.monster5q1), (hHeight / 2), (hHeight / 2), false);
                MonsterOne = BitmapFactory.decodeResource(getResources(),R.drawable.monster5q1);
            }
        }
    }
    public void tutorialAnimation(){
        if (foodSprite.yY > (hHeight / 2)) {
            foodSprite = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.food2), (hHeight / 5), (hHeight / 5), false), (int) (wWidth * 0.7), hHeight / -5, true);
        }
        if (trashSprite.yY > (hHeight / 2)) {
            trashSprite = new TrashSprite(Bitmap.createScaledBitmap(BitmapFactory.decodeResource(getResources(),R.drawable.trash2), (hHeight / 5), (hHeight / 5), false), wWidth / 5, hHeight / -5, false);
        }
        if (goX < 0) {
            goGrow = true;
        }
        if (goX > wWidth * 0.2) {
            goGrow = false;
        }
        if (goGrow) {
            goX += velocity * 4;
        } else {
            goX -= velocity * 4;
        }
        if (monsterTime <= 180 && level == 1) {
            monsterTime++;
            if (monsterTime >= 135 && monsterTime < 150) {
                monsterSize += hHeight / 120;
            }
            if (monsterTime >= 150 && monsterTime < 165) {
                monsterSize -= hHeight / 120;
            }
        } else if (level == 1) {
            monsterTime = 0;
        }
        if (monsterTime <= 140 && level != 1) {
            monsterTime++;
            if (monsterTime >= 110 && monsterTime < 125) {
                monsterSize += hHeight / 120;
            }
            if (monsterTime >= 125 && monsterTime < 140) {
                monsterSize -= hHeight / 120;
            }
        } else if (level != 1) {
            monsterTime = -5;
        }
    }

    public static int randomInt(int min, int max) {
        Random r = new Random();
        return r.nextInt((max - min) + 1) + min; //nextInt is normally exclusive of the top value so add 1 to make it inclusive
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int action = event.getActionMasked();

        xTouch = (int)event.getX();
        yTouch = (int)event.getY();

        switch(action){
            case MotionEvent.ACTION_DOWN:
                touching = true;
                break;
            case MotionEvent.ACTION_MOVE:
                xTouch = (int)event.getX();
                yTouch = (int)event.getY();
                break;
            case MotionEvent.ACTION_UP:
                touching = false;
                if (openingDone && !levelStarted) {
                    startLevel(level);
                }
                break;
        }
        return true;
    }
}
