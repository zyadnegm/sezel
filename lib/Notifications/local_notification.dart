import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // معرف القناة
      'channel_id', // اسم القناة
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('sezel_sound_doubled'), // اسم ملف الصوت بدون امتداد

      // playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
