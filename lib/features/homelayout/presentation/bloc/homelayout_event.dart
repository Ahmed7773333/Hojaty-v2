import 'package:equatable/equatable.dart';
import '../../data/models/prayer_time_model.dart';

abstract class HomelayoutEvent extends Equatable {
  const HomelayoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomelayoutEvent extends HomelayoutEvent {
  const LoadHomelayoutEvent();
}

class LoadOccasionsDataEvent extends HomelayoutEvent {
  final String? language;

  const LoadOccasionsDataEvent({this.language});

  @override
  List<Object?> get props => [language];
}

class SyncOccasionsDataEvent extends HomelayoutEvent {
  const SyncOccasionsDataEvent();
}

class NavigateHijriMonthEvent extends HomelayoutEvent {
  final int delta; // +1 or -1

  const NavigateHijriMonthEvent(this.delta);

  @override
  List<Object?> get props => [delta];
}

class NavigateGregorianMonthEvent extends HomelayoutEvent {
  final int delta; // +1 or -1

  const NavigateGregorianMonthEvent(this.delta);

  @override
  List<Object?> get props => [delta];
}

class ResetHijriMonthToCurrentEvent extends HomelayoutEvent {
  const ResetHijriMonthToCurrentEvent();
}

class ResetGregorianMonthToCurrentEvent extends HomelayoutEvent {
  const ResetGregorianMonthToCurrentEvent();
}

class NavigatePrayerDayEvent extends HomelayoutEvent {
  final int delta; // +1 or -1

  const NavigatePrayerDayEvent(this.delta);

  @override
  List<Object?> get props => [delta];
}

class ResetPrayerDayToTodayEvent extends HomelayoutEvent {
  const ResetPrayerDayToTodayEvent();
}

class RefreshPrayerTimesEvent extends HomelayoutEvent {
  const RefreshPrayerTimesEvent();
}

class ChangeBottomNavTabEvent extends HomelayoutEvent {
  final int tabIndex;

  const ChangeBottomNavTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class TogglePrayerNotificationEvent extends HomelayoutEvent {
  final PrayerType prayerType;

  const TogglePrayerNotificationEvent(this.prayerType);

  @override
  List<Object?> get props => [prayerType];
}

class ToggleAllPrayersNotificationEvent extends HomelayoutEvent {
  final bool isEnabled;

  const ToggleAllPrayersNotificationEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ChangeAdhanTypeEvent extends HomelayoutEvent {
  final bool isFullAdhan;

  const ChangeAdhanTypeEvent(this.isFullAdhan);

  @override
  List<Object?> get props => [isFullAdhan];
}

class ToggleAnaOsalyEvent extends HomelayoutEvent {
  final bool isEnabled;

  const ToggleAnaOsalyEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ChangeAnaOsalyLanguageEvent extends HomelayoutEvent {
  final String language;

  const ChangeAnaOsalyLanguageEvent(this.language);

  @override
  List<Object?> get props => [language];
}

class DeleteNotificationEvent extends HomelayoutEvent {
  final String notificationId;

  const DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsReadEvent extends HomelayoutEvent {
  const MarkAllNotificationsReadEvent();
}

class UpdatePrayerWindowTimeEvent extends HomelayoutEvent {
  final PrayerType prayerType;
  final String? startWindow;
  final String? endWindow;

  const UpdatePrayerWindowTimeEvent({
    required this.prayerType,
    this.startWindow,
    this.endWindow,
  });

  @override
  List<Object?> get props => [prayerType, startWindow, endWindow];
}

class SendTestNotificationEvent extends HomelayoutEvent {
  const SendTestNotificationEvent();
}

class TogglePrayerAlertsEvent extends HomelayoutEvent {
  final bool isEnabled;
  const TogglePrayerAlertsEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ToggleOccasionsNotificationsEvent extends HomelayoutEvent {
  final bool isEnabled;
  const ToggleOccasionsNotificationsEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ToggleGeneralNotificationsEvent extends HomelayoutEvent {
  final bool isEnabled;
  const ToggleGeneralNotificationsEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ToggleAthkarNotificationsEvent extends HomelayoutEvent {
  final bool isEnabled;
  const ToggleAthkarNotificationsEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class SelectAdhanSoundEvent extends HomelayoutEvent {
  final String soundId;

  const SelectAdhanSoundEvent(this.soundId);

  @override
  List<Object?> get props => [soundId];
}

class UpdatePrayerCityNameEvent extends HomelayoutEvent {
  final String cityName;

  const UpdatePrayerCityNameEvent(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

class ChangeAnaOsalyCustomMessageEvent extends HomelayoutEvent {
  final String message;
  final String? language;

  const ChangeAnaOsalyCustomMessageEvent(this.message, {this.language});

  @override
  List<Object?> get props => [message, language];
}
