import 'package:equatable/equatable.dart';

class LanguageOptionModel extends Equatable {
  final String languageCode;
  final String titleKey;
  final String subtitleKey;

  const LanguageOptionModel({
    required this.languageCode,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  List<Object?> get props => [languageCode, titleKey, subtitleKey];
}
