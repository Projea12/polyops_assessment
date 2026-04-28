import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/services/i_notification_service.dart';

@LazySingleton(as: INotificationService)
class NotificationService implements INotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'task_reminders';
  static const _channelName = 'Task Reminders';

  @PostConstruct()
  void init() => _initialize();

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
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Reminders for upcoming task due dates',
      importance: Importance.high,
    ));
    await android?.requestNotificationsPermission();
  }

  @override
  Future<void> scheduleTaskDueNotification(
    String taskId,
    String title,
    DateTime dueDate,
  ) async {
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
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {}
  }

  @override
  Future<void> cancelTaskNotification(String taskId) async {
    try {
      await _plugin.cancel(_notificationId(taskId));
    } catch (_) {}
  }

  int _notificationId(String taskId) => taskId.hashCode.abs() % 2147483647;
}
