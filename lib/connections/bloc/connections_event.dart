part of 'connections_bloc.dart';

@immutable
sealed class ConnectionsEvent {}

class LoadConnections extends ConnectionsEvent {}

class SaveConnection extends ConnectionsEvent {
  final Connection connection;
  SaveConnection(this.connection);
}

class UpdateConnection extends ConnectionsEvent {
  final Connection connection;
  UpdateConnection(this.connection);
}

class DeleteConnection extends ConnectionsEvent {
  final int id;
  DeleteConnection(this.id);
}

class RefreshConnections extends ConnectionsEvent {}

class GetConnectionById extends ConnectionsEvent {
  final int id;
  GetConnectionById(this.id);
}

class ScheduleNotification extends ConnectionsEvent {
  final Connection connection;
  ScheduleNotification(this.connection);
}
