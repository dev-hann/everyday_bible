package com.example.everydaybible;

import android.text.PrecomputedText;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "EveryDayBible";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            String[] methodList = call.method.split("/");
                            switch (methodList[0]) {
                                case "notification":
                                    new MediaActivity(this,methodList[1], result);
                                    break;
                            }
                        }
                );
    }

}
