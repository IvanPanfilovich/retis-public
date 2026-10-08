part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class ExportConnectionsSuccessful extends SettingsState {}

final class ExportConnectionsError extends SettingsState {}

final class ImportConnectionsSuccessful extends SettingsState {}

final class ImportConnectionsError extends SettingsState {}
