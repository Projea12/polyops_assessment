import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/services/i_notification_service.dart';
@pragma('vm:entry-point')
void onBackgroundNotification(NotificationResponse response) {}

@LazySingleton(as: INotificationService)
class NotificationService implements INotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'task_reminders';
  static const _channelName = 'Task Reminders';

  // Guards every public method — resolved only after channel + permissions are ready.
  final _ready = Completer<void>();

  @PostConstruct()
  void init() {
    _initialize()
        .then((_) => _ready.complete())
        .catchError(_ready.completeError);
  }

  Future<void> _initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (_) {},
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotification,
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    // Channel must exist before any notification is scheduled on Android 8+.
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Reminders for upcoming task due dates',
      importance: Importance.high,
    ));
    await android?.requestNotificationsPermission();
    // Alarms & Reminders special permission required on Android 12+ for exact alarms.
    await android?.requestExactAlarmsPermission();
  }

  @override
  Future<void> scheduleTaskDueNotification(
    String taskId,
    String title,
    DateTime dueDate,
  ) async {
    await _ready.future; // wait for channel + permissions before scheduling
    if (dueDate.isBefore(DateTime.now())) return;
    try {
      await _plugin.zonedSchedule(
        _notificationId(taskId),
        'Task Due: $title',
        DateFormat('EEE, MMM d · h:mm a').format(dueDate),
        tz.TZDateTime.from(dueDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'Reminders for upcoming task due dates',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e, st) {
      debugPrint('[NotificationService.schedule] $e\n$st');
    }
  }

  @override
  Future<void> cancelTaskNotification(String taskId) async {
    await _ready.future;
    try {
      await _plugin.cancel(_notificationId(taskId));
    } catch (_) {}
  }

  int _notificationId(String taskId) => taskId.hashCode.abs() % 2147483647;
}
