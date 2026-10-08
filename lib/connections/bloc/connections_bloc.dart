import 'package:retis/notifications/notifications_service/notifications_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:retis/connections/models/connection.dart';
import 'package:retis/database/database_repository.dart';

part 'connections_event.dart';
part 'connections_state.dart';

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final DatabaseRepository databaseRepository;
  final NotificationService notificationService;

  ConnectionsBloc(
      {required this.databaseRepository, required this.notificationService})
      : super(ConnectionsInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<SaveConnection>(_onSaveConnection);
    on<UpdateConnection>(_onUpdateConnection);
    on<DeleteConnection>(_onDeleteConnection);
    on<RefreshConnections>(_onRefreshConnections);
    on<GetConnectionById>(_onGetConnectionById);
    on<ScheduleNotification>(_onScheduleNotification);
  }
  Future<void> _onLoadConnections(
      LoadConnections event, Emitter<ConnectionsState> emit) async {
    emit(ConnectionsLoading());
    try {
      final connections = await databaseRepository.queryAllConnections();
      emit(ConnectionsLoadSuccess(connections));
      notificationService.updateNotifications(connections);
    } catch (error) {
      emit(ConnectionsLoadFailure(error.toString()));
    }
  }

  Future<void> _onSaveConnection(
      SaveConnection event, Emitter<ConnectionsState> emit) async {
    await databaseRepository.insertConnection(event.connection);
    // add(ScheduleNotification(event.connection));
    add(RefreshConnections());
  }

  Future<void> _onUpdateConnection(
      UpdateConnection event, Emitter<ConnectionsState> emit) async {
    await databaseRepository.updateConnection(event.connection);
    add(RefreshConnections());
  }

  Future<void> _onDeleteConnection(
      DeleteConnection event, Emitter<ConnectionsState> emit) async {
    notificationService.cancelNotification(event.id);
    await databaseRepository.deleteConnection(event.id);
    add(RefreshConnections());
  }

  Future<void> _onRefreshConnections(
      RefreshConnections event, Emitter<ConnectionsState> emit) async {
    add(LoadConnections());
  }

  Future<void> _onGetConnectionById(
      GetConnectionById event, Emitter<ConnectionsState> emit) async {
    emit(SingleConnectionLoading());
    try {
      final connection = await databaseRepository.queryConnectionById(event.id);
      emit(SingleConnectionLoadSuccess(connection!));
    } catch (error) {
      emit(SingleConnectionLoadFailure(error.toString()));
    }
  }

  Future<void> _onScheduleNotification(
      ScheduleNotification event, Emitter<ConnectionsState> emit) async {
    await notificationService.updateNotifications([event.connection]);
  }
}
