import 'package:equatable/equatable.dart';

enum OnboardingIconType {
  prayerTimes,
  quranAthkar,
  anaOsaly,
  hijriCalendar,
}

class OnboardingItemModel extends Equatable {
  final int index;
  final OnboardingIconType iconType;
  final String Function(dynamic strings) subtitleResolver;
  final String Function(dynamic strings) titleResolver;
  final String Function(dynamic strings) descriptionResolver;

  const OnboardingItemModel({
    required this.index,
    required this.iconType,
    required this.subtitleResolver,
    required this.titleResolver,
    required this.descriptionResolver,
  });

  @override
  List<Object?> get props => [index, iconType];
}
