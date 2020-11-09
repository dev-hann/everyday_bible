package com.example.everydaybible;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.plugin.common.MethodChannel;

import static androidx.core.content.ContextCompat.getSystemService;


public class MediaActivity {
    public MediaActivity(Context context, String method, MethodChannel.Result result) {
        switch (method) {
            case "mediaStyle":
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    mediaStyleNotification(context, result);
                }
                break;
        }

    }
    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library

    }

    private void mediaStyleNotification(Context context, MethodChannel.Result result) {
        androidx.media.app.NotificationCompat.MediaStyle mediaStyle = new androidx.media.app.NotificationCompat.MediaStyle();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "name";
            String description = "des";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel("hello", name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(context,NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
        Notification notification = new NotificationCompat.Builder(context, "hello")
                // Show controls on lock screen even when user hides sensitive content.
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setSmallIcon(R.drawable.flutter_devs)
                // Add media control buttons that invoke intents in your media service
                .addAction(R.drawable.flutter_devs, "Previous", null) // #0
                .addAction(R.drawable.flutter_devs, "Pause", null )  // #1
                .addAction(R.drawable.flutter_devs, "Next", null)     // #2
                // Apply the media style template
                .setStyle(mediaStyle)
                .setContentTitle("Wonderful music")
                .setContentText("My Awesome Band")
                .build();
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
        notificationManagerCompat.notify(0, notification);
        result.success("1");

    }

}
