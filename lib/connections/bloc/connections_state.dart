part of 'connections_bloc.dart';

@immutable
sealed class ConnectionsState {}

class ConnectionsInitial extends ConnectionsState {}

class ConnectionsLoading extends ConnectionsState {}

class ConnectionsLoadSuccess extends ConnectionsState {
  final List<Connection> connections;
  ConnectionsLoadSuccess(this.connections);
}

class ConnectionsLoadFailure extends ConnectionsState {
  final String error;
  ConnectionsLoadFailure(this.error);
}

class SingleConnectionLoading extends ConnectionsState {}

class SingleConnectionLoadSuccess extends ConnectionsState {
  final Connection connection;
  SingleConnectionLoadSuccess(this.connection);
}

class SingleConnectionLoadFailure extends ConnectionsState {
  final String error;
  SingleConnectionLoadFailure(this.error);
}
