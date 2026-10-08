part of 'notifications_setup_bloc.dart';

@immutable
sealed class NotificationsSetupState {}

class NotificationsSetupInitial extends NotificationsSetupState {}

class NotificationsPermissionLoading extends NotificationsSetupState {}

class NotificationsPermissionGranted extends NotificationsSetupState {
}

class NotificationsPermissionDenied extends NotificationsSetupState {}
