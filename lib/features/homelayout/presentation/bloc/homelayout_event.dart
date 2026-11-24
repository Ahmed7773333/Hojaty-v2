import 'package:equatable/equatable.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayers_helper.dart';

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

class SendTestPreAdhanNotificationEvent extends HomelayoutEvent {
  const SendTestPreAdhanNotificationEvent();
}

class TogglePreAdhanReminderEvent extends HomelayoutEvent {
  final bool isEnabled;
  const TogglePreAdhanReminderEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ChangePreAdhanReminderMinutesEvent extends HomelayoutEvent {
  final int minutes;
  final PrayerType? prayerType;

  const ChangePreAdhanReminderMinutesEvent(this.minutes, {this.prayerType});

  @override
  List<Object?> get props => [minutes, prayerType];
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

class SelectPrayerAdhanSoundEvent extends HomelayoutEvent {
  final PrayerType? prayerType;
  final String soundId;

  const SelectPrayerAdhanSoundEvent({
    this.prayerType,
    required this.soundId,
  });

  @override
  List<Object?> get props => [prayerType, soundId];
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

class CheckLocationUpdateEvent extends HomelayoutEvent {
  final bool force;

  const CheckLocationUpdateEvent({this.force = false});

  @override
  List<Object?> get props => [force];
}

class SelectPrayerCityEvent extends HomelayoutEvent {
  final String cityName;
  final GeoCoordinates coordinates;

  const SelectPrayerCityEvent({
    required this.cityName,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [cityName, coordinates];
}

class ToggleSalawatReminderEvent extends HomelayoutEvent {
  final bool enabled;

  const ToggleSalawatReminderEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class RefreshActiveAdhkarEvent extends HomelayoutEvent {
  const RefreshActiveAdhkarEvent();
}

class ChangeAsrMadhabEvent extends HomelayoutEvent {
  final AsrMadhab madhab;

  const ChangeAsrMadhabEvent(this.madhab);

  @override
  List<Object?> get props => [madhab];
}

class ChangePrayerTimeOffsetEvent extends HomelayoutEvent {
  final PrayerType prayerType;
  final int offsetMinutes;

  const ChangePrayerTimeOffsetEvent({
    required this.prayerType,
    required this.offsetMinutes,
  });

  @override
  List<Object?> get props => [prayerType, offsetMinutes];
}

class ResetPrayerTimeOffsetsEvent extends HomelayoutEvent {
  const ResetPrayerTimeOffsetsEvent();
}
