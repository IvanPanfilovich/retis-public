import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retis/notifications/notifications_service/notifications_service.dart';

part 'notifications_setup_event.dart';
part 'notifications_setup_state.dart';

class NotificationsSetupBloc
    extends Bloc<NotificationsSetupEvent, NotificationsSetupState> {
  final NotificationService notificationService;
  NotificationsSetupBloc({required this.notificationService})
      : super(NotificationsSetupInitial()) {
    on<RequestNotificationPermission>((event, emit) async {
      emit(NotificationsPermissionLoading());

      bool notificationsPermissionGranted =
          await notificationService.requestPermissions();

      if (notificationsPermissionGranted) {
        emit(NotificationsPermissionGranted());
      } else {
        emit(NotificationsPermissionDenied());
      }
    });
  }
}
