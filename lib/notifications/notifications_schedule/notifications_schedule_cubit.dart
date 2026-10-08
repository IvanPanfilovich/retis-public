import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScheduleCubit extends Cubit<TimeOfDay> {
  final NotificationService notificationService;
  NotificationsScheduleCubit({required this.notificationService})
      : super(const TimeOfDay(hour: 20, minute: 0)) {
    _initTime();
  }

  Future<void> _initTime() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('notificationsTimeHour') != null &&
        prefs.getInt('notificationsTimeMinute') != null) {
      final hour = prefs.getInt('notificationsTimeHour') ?? 20;
      final minute = prefs.getInt('notificationsTimeMinute') ?? 0;
      emit(TimeOfDay(hour: hour, minute: minute));
    } else {
      await prefs.setInt('notificationsTimeHour', 20);
      await prefs.setInt('notificationsTimeMinute', 0);
      emit(const TimeOfDay(hour: 20, minute: 0));
    }
  }

  Future<void> updateTime(TimeOfDay newTime) async {
    emit(newTime);
  }

  Future<void> saveTime(TimeOfDay newTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationsTimeHour', newTime.hour);
    await prefs.setInt('notificationsTimeMinute', newTime.minute);

    emit(newTime);
  }
}
