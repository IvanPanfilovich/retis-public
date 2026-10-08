part of 'notifications_setup_bloc.dart';

@immutable
sealed class NotificationsSetupEvent {}

class RequestNotificationPermission extends NotificationsSetupEvent {
  final TimeOfDay newTime;

  RequestNotificationPermission(this.newTime);
}
