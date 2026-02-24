import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Map<String, String> storeSettings;
  final Map<String, String> profileSettings;
  final bool isShiftEnabled;

  const SettingsLoaded({
    required this.storeSettings,
    required this.profileSettings,
    this.isShiftEnabled = true,
  });

  @override
  List<Object> get props => [storeSettings, profileSettings, isShiftEnabled];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
