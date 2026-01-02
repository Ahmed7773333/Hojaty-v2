import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateThemeEvent extends SettingsEvent {
  final ThemeMode themeMode;
  const UpdateThemeEvent(this.themeMode);
  @override
  List<Object> get props => [themeMode];
}

class UpdateLanguageEvent extends SettingsEvent {
  final bool isEnglish;
  const UpdateLanguageEvent(this.isEnglish);
  @override
  List<Object> get props => [isEnglish];
}

class UpdateNotificationSettingsEvent extends SettingsEvent {
  final bool? showNotifications;
  final bool? isSoundEnabled;
  final bool? isVibrateEnabled;

  const UpdateNotificationSettingsEvent({
    this.showNotifications,
    this.isSoundEnabled,
    this.isVibrateEnabled,
  });

  @override
  List<Object?> get props => [
    showNotifications,
    isSoundEnabled,
    isVibrateEnabled,
  ];
}

class RefreshLocationEvent extends SettingsEvent {}
