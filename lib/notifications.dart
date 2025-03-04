import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/models/todo.dart';

part 'notifications.g.dart';

// Android notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'todo_app_channel',
  'Todo Notifications',
  description: 'Notifications for your todo tasks',
  importance: Importance.high,
);

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(requestAlertPermission: true);

final InitializationSettings initializationSettings =
    const InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsDarwin,
);

@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService(this._notificationsPlugin);

  Future<void> initialize() async {
    // Request permissions for Android 13+
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // Initialize notifications
    await _notificationsPlugin.initialize(initializationSettings);

    // Create notification channel for Android
    await androidImplementation?.createNotificationChannel(channel);
  }

  // Check if we have notification permissions
  Future<bool> requestPermissions() async {
    // For Android
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted =
        await androidImplementation?.requestNotificationsPermission();

    // For iOS
    final iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return granted ?? iosGranted ?? false;
  }

  Future<void> showTaskNotification(Todo todo) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'todo_app_channel',
      'Todo Notifications',
      channelDescription: 'Notifications for your todo tasks',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      badgeNumber: null,
      threadIdentifier: 'todo-thread',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      todo.hashCode, // Use hashCode as a unique ID
      todo.title,
      'Your task was created',
      platformDetails,
      payload: '${todo.createdAt}',
    );
  }

  Future<void> scheduleTaskReminder(Todo todo) async {
    // Implementation for scheduling reminders
    // This would use flutterLocalNotificationsPlugin.zonedSchedule
    // to set up reminders at specific times
  }
}
