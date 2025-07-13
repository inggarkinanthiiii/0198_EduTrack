import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notif = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('ic_notif'); 
    const settings = InitializationSettings(android: android);
    await _notif.initialize(settings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleDeadlineNotif({
    required int id,
    required String title,
    required DateTime deadline,
  }) async {
    final scheduledTime = deadline.subtract(const Duration(days: 1));

    await _notif.zonedSchedule(
      id,
      'Deadline Tugas Besok!',
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'tugas_channel',
          'Tugas Channel',
          channelDescription: 'Notifikasi untuk deadline tugas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, 
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showTestNotification() async {
    await _notif.show(
      0,
      'Tes Notifikasi',
      'Ini adalah notifikasi percobaan 🎉',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'tugas_channel',
          'Tugas Channel',
          channelDescription: 'Notifikasi untuk deadline tugas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
