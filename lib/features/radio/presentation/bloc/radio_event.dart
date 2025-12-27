import 'package:equatable/equatable.dart';

abstract class RadioEvent extends Equatable {
  const RadioEvent();

  @override
  List<Object> get props => [];
}

class LoadRadioEvent extends RadioEvent {
  final String language;
  const LoadRadioEvent({this.language = 'ar'});

  @override
  List<Object> get props => [language];
}

class SearchRecitersEvent extends RadioEvent {
  final String query;
  const SearchRecitersEvent(this.query);

  @override
  List<Object> get props => [query];
}
