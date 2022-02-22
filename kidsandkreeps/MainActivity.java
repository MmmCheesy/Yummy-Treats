package com.alexandergeckert.kidsandkreeps;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

public class MainActivity extends Activity {

    public static SharedPreferences preferences;
    public static MediaPlayer mp1, mp2, mp3, mp4, mp5, mp6, mp7, mp8, mp9, mp10, mp11, mp12, mp13, mp14, mp15, mp16, mp17, mp18, mp19, mp20, mp22, mp23, mp24, mp25, mp26, mp27, mp28, mp29, mp30, mp31, mp32, mp33, mp34, mp35, mp36, mp37, mp38, mp39, mp40;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(new GameView(this));
        preferences = this.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
        mp1 = MediaPlayer.create(this, R.raw.end1);
        mp2 = MediaPlayer.create(this, R.raw.end2);
        mp3 = MediaPlayer.create(this, R.raw.end3);
        mp4 = MediaPlayer.create(this, R.raw.end4);
        mp5 = MediaPlayer.create(this, R.raw.end5);
        mp6 = MediaPlayer.create(this, R.raw.end6);
        mp7 = MediaPlayer.create(this, R.raw.end7);
        mp8 = MediaPlayer.create(this, R.raw.end8);
        mp9 = MediaPlayer.create(this, R.raw.end9);
        mp10 = MediaPlayer.create(this, R.raw.kidbad1);
        mp11 = MediaPlayer.create(this, R.raw.kidbad2);
        mp12 = MediaPlayer.create(this, R.raw.kidbad3);
        mp13 = MediaPlayer.create(this, R.raw.kidbad4);
        mp14 = MediaPlayer.create(this, R.raw.kidbad5);
        mp15 = MediaPlayer.create(this, R.raw.kidgood1);
        mp16 = MediaPlayer.create(this, R.raw.kidgood2);
        mp17 = MediaPlayer.create(this, R.raw.kidgood3);
        mp18 = MediaPlayer.create(this, R.raw.kidgood4);
        mp19 = MediaPlayer.create(this, R.raw.kidgood5);
        mp20 = MediaPlayer.create(this, R.raw.kidsandkreeps);
        mp22 = MediaPlayer.create(this, R.raw.level1);
        mp23 = MediaPlayer.create(this, R.raw.monstersong);
        mp24 = MediaPlayer.create(this, R.raw.level2);
        mp25 = MediaPlayer.create(this, R.raw.monstersong);
        mp26 = MediaPlayer.create(this, R.raw.level3);
        mp27 = MediaPlayer.create(this, R.raw.monstersong);
        mp28 = MediaPlayer.create(this, R.raw.level4);
        mp29 = MediaPlayer.create(this, R.raw.monstersong);
        mp30 = MediaPlayer.create(this, R.raw.level5);
        mp31 = MediaPlayer.create(this, R.raw.monstersong);
        mp32 = MediaPlayer.create(this, R.raw.monsterbad1);
        mp33 = MediaPlayer.create(this, R.raw.monsterbad2);
        mp34 = MediaPlayer.create(this, R.raw.monsterbad3);
        mp35 = MediaPlayer.create(this, R.raw.monsterbad4);
        mp36 = MediaPlayer.create(this, R.raw.monstergood1);
        mp37 = MediaPlayer.create(this, R.raw.monstergood2);
        mp38 = MediaPlayer.create(this, R.raw.monstergood3);
        mp39 = MediaPlayer.create(this, R.raw.monstergood4);
        mp40 = MediaPlayer.create(this, R.raw.monstergood5);
    }

    public static void storeDefaults(String str, int value) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putInt(str, value);
        editor.apply();
    }

    public static int returnDefaults(String str, int defaultValue) {
        return preferences.getInt(str, defaultValue);
    }

    public static void playSound(int sound, float volume, boolean looping) {
        if (sound == 1) {
            int ran = GameView.randomInt(1, 9);
            if (ran == 1) {
                mp1.setVolume(volume, volume);
                mp1.setLooping(looping);
                mp1.start();
            } else if (ran == 2) {
                mp2.setVolume(volume, volume);
                mp2.setLooping(looping);
                mp2.start();
            } else if (ran == 3) {
                mp3.setVolume(volume, volume);
                mp3.setLooping(looping);
                mp3.start();
            } else if (ran == 4) {
                mp4.setVolume(volume, volume);
                mp4.setLooping(looping);
                mp4.start();
            } else if (ran == 5) {
                mp5.setVolume(volume, volume);
                mp5.setLooping(looping);
                mp5.start();
            } else if (ran == 6) {
                mp6.setVolume(volume, volume);
                mp6.setLooping(looping);
                mp6.start();
            } else if (ran == 7) {
                mp7.setVolume(volume, volume);
                mp7.setLooping(looping);
                mp7.start();
            } else if (ran == 8) {
                mp8.setVolume(volume, volume);
                mp8.setLooping(looping);
                mp8.start();
            } else if (ran == 9) {
                mp9.setVolume(volume, volume);
                mp9.setLooping(looping);
                mp9.start();
            }
        } else if (sound == 2) {
            int ran = GameView.randomInt(1, 5);
            if (ran == 1) {
                mp10.setVolume(volume, volume);
                mp10.setLooping(looping);
                mp10.start();
            } else if (ran == 2) {
                mp11.setVolume(volume, volume);
                mp11.setLooping(looping);
                mp11.start();
            } else if (ran == 3) {
                mp12.setVolume(volume, volume);
                mp12.setLooping(looping);
                mp12.start();
            } else if (ran == 4) {
                mp13.setVolume(volume, volume);
                mp13.setLooping(looping);
                mp13.start();
            } else if (ran == 5) {
                mp14.setVolume(volume, volume);
                mp14.setLooping(looping);
                mp14.start();
            }
        } else if (sound == 3) {
            int ran = GameView.randomInt(1, 5);
            if (ran == 1) {
                mp15.setVolume(volume, volume);
                mp15.setLooping(looping);
                mp15.start();
            } else if (ran == 2) {
                mp16.setVolume(volume, volume);
                mp16.setLooping(looping);
                mp16.start();
            } else if (ran == 3) {
                mp17.setVolume(volume, volume);
                mp17.setLooping(looping);
                mp17.start();
            } else if (ran == 4) {
                mp18.setVolume(volume, volume);
                mp18.setLooping(looping);
                mp18.start();
            } else if (ran == 5) {
                mp19.setVolume(volume, volume);
                mp19.setLooping(looping);
                mp19.start();
            }
        } else if (sound == 4) {
            mp20.setVolume(volume, volume);
            mp20.setLooping(looping);
            mp20.start();
        } else if (sound == 5) {
            mp5.setVolume(volume, volume);
            mp5.setLooping(looping);
            mp5.start();
        } else if (sound == 6) {
            mp22.setVolume(volume, volume);
            mp22.setLooping(looping);
            mp22.start();
        } else if (sound == 7) {
            mp24.setVolume(volume, volume);
            mp24.setLooping(looping);
            mp24.start();
        } else if (sound == 8) {
            mp26.setVolume(volume, volume);
            mp26.setLooping(looping);
            mp26.start();
        } else if (sound == 9) {
            mp28.setVolume(volume, volume);
            mp28.setLooping(looping);
            mp28.start();
        } else if (sound == 10) {
            mp30.setVolume(volume, volume);
            mp30.setLooping(looping);
            mp30.start();
        } else if (sound == 11) {
            mp23.setVolume(volume, volume);
            mp23.setLooping(looping);
            mp23.start();
        } else if (sound == 12) {
            mp25.setVolume(volume, volume);
            mp25.setLooping(looping);
            mp25.start();
        } else if (sound == 13) {
            mp27.setVolume(volume, volume);
            mp27.setLooping(looping);
            mp27.start();
        } else if (sound == 14) {
            mp29.setVolume(volume, volume);
            mp29.setLooping(looping);
            mp29.start();
        } else if (sound == 15) {
            mp31.setVolume(volume, volume);
            mp31.setLooping(looping);
            mp31.start();
        } else if (sound == 16) {
            int ran = GameView.randomInt(1, 4);
            if (ran == 1) {
                mp32.setVolume(volume, volume);
                mp32.setLooping(looping);
                mp32.start();
            } else if (ran == 2) {
                mp33.setVolume(volume, volume);
                mp33.setLooping(looping);
                mp33.start();
            } else if (ran == 3) {
                mp34.setVolume(volume, volume);
                mp34.setLooping(looping);
                mp34.start();
            } else if (ran == 4) {
                mp35.setVolume(volume, volume);
                mp35.setLooping(looping);
                mp35.start();
            }
        } else if (sound == 17) {
            int ran = GameView.randomInt(1, 5);
            if (ran == 1) {
                mp36.setVolume(volume, volume);
                mp36.setLooping(looping);
                mp36.start();
            } else if (ran == 2) {
                mp37.setVolume(volume, volume);
                mp37.setLooping(looping);
                mp37.start();
            } else if (ran == 3) {
                mp38.setVolume(volume, volume);
                mp38.setLooping(looping);
                mp38.start();
            } else if (ran == 4) {
                mp39.setVolume(volume, volume);
                mp39.setLooping(looping);
                mp39.start();
            } else if (ran == 5) {
                mp40.setVolume(volume, volume);
                mp40.setLooping(looping);
                mp40.start();
            }
        }
    }

    public static void stopSound() {
        mp23.setVolume(0,0);
        mp25.setVolume(0,0);
        mp27.setVolume(0,0);
        mp29.setVolume(0,0);
        mp31.setVolume(0,0);
    }
}
