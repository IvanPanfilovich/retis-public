part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class ImportConnections extends SettingsEvent {}

class ExportConnections extends SettingsEvent {}
