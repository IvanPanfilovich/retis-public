import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:retis/connections/models/connection.dart';
import 'package:retis/database/database_repository.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final DatabaseRepository databaseRepository;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService({required this.databaseRepository});

  Future<bool> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/app_icon'),
      iOS: DarwinInitializationSettings()
    );
    final initialized = await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      final notificationChannels = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.getNotificationChannels();

      if (notificationChannels == null || notificationChannels.isEmpty || !notificationChannels.any((channel) => channel.id == 'reminders_channel')) {
        await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'reminders_channel', 
              'Connection reminders',
              description:'Notification channel to remind you to contact your connections'),
            );
      }
    }
    return initialized ?? false;
  }

  Future<bool> checkPermission() async {
    if (Platform.isIOS) {
      final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();
      return result?.isEnabled ?? false;
    } else if (Platform.isAndroid) {
      final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
      return result ?? false;
    }

    return false;
  }

  Future<bool> requestPermissions() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/app_icon'),
      iOS: DarwinInitializationSettings()
    );

    if(Platform.isIOS) {
      final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      if(result == true) {
        await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      }
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
      if(result == true) {
        await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      }
      return result ?? false;
    }
    return false;
  }

  Future<void> updateNotifications(List<Connection> connections) async {
    for (var connection in connections) {
      if (DateTime.now().isAfter(connection.lastContactedDate)) {
        await flutterLocalNotificationsPlugin.cancel(connection.id);

        final scheduledDate = await calculateNextNotificationDate(connection);
        await scheduleNotification(connection, scheduledDate);
      }
    }
  }

  Future<void> scheduleNotification(
      Connection connection, DateTime scheduledDate) async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(currentTimeZone.replaceAll("Kiev", "Kyiv")));

    const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Connection reminders',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        connection.id,
        connection.name,
        connection.commentary,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<DateTime> calculateNextNotificationDate(Connection connection) async {
    var nextRescheduleDate = connection.lastContactedDate
        .add(Duration(days: connection.intervalInDays));
    var nextNotificationDate = connection.lastContactedDate
        .add(Duration(days: Random().nextInt(connection.intervalInDays)));

    if (nextNotificationDate.isBefore(DateTime.now())) {
      nextNotificationDate = DateTime.now()
          .add(Duration(days: Random().nextInt(connection.intervalInDays)));
    }

    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('notificationsTimeHour');
    final minute = prefs.getInt('notificationsTimeMinute');
    nextNotificationDate = DateTime(
        nextNotificationDate.year,
        nextNotificationDate.month,
        nextNotificationDate.day,
        hour ?? 20,
        minute ?? 0);

    if (nextNotificationDate.isBefore(DateTime.now())) {
      nextNotificationDate = nextNotificationDate.add(const Duration(days: 1));
    }

    if (nextRescheduleDate.isBefore(DateTime.now())) {
      nextRescheduleDate =
          DateTime.now().add(Duration(days: connection.intervalInDays));
    }
    await databaseRepository.updateConnection(
        connection.copyWith(lastContactedDate: nextRescheduleDate));
    connection = connection.copyWith(lastContactedDate: nextRescheduleDate);
    return nextNotificationDate;
  }

  void notificationsRescheduleTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final connectionsJson = prefs.getString('connections');
    if (connectionsJson != null) {
      final List<dynamic> connectionsList = jsonDecode(connectionsJson);
      final connections =
          connectionsList.map((json) => Connection.fromMap(json)).toList();
      await updateNotifications(connections);
    }

    BackgroundFetch.finish(taskId);
  }
}
