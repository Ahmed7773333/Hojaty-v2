import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0, adapterName: 'UserAdapter')
class User extends HiveObject {
  // fields (auto-generated)
  @HiveField(0)
  Coordinates? lastKnownLocation;

  @HiveField(1)
  String? cityName;

  @HiveField(2)
  ThemeMode? themeMode;

  @HiveField(3)
  bool? isEnglish;

  User({
    this.lastKnownLocation,
    this.cityName,
    this.themeMode,
    this.isEnglish,
  });

  // ----------------- UI getters/setters -----------------
  Coordinates get uiLastKnownLocation => lastKnownLocation ?? const Coordinates(30.108772, 31.319205); // Cairo, Egy

  set uiLastKnownLocation(Coordinates? v) {
    lastKnownLocation = v;
    try {
      save();
    } catch (_) {}
  }

  String get uiCityName => cityName ?? '';
  set uiCityName(String? v) {
    cityName = v;
    try {
      save();
    } catch (_) {}
  }

  ThemeMode? get uiThemeMode => themeMode ?? ThemeMode.system;
  set uiThemeMode(ThemeMode? v) {
    themeMode = v;
    try {
      save();
    } catch (_) {}
  }

  bool? get uiIsEnglish => isEnglish ?? false;
  set uiIsEnglish(bool? v) {
    isEnglish = v;
    try {
      save();
    } catch (_) {}
  }

  User copyWith({
    Coordinates? lastKnownLocation,
    String? cityName,
    ThemeMode? themeMode,
    bool? isEnglish,
  }) {
    return User(
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      cityName: cityName ?? this.cityName,
      themeMode: themeMode ?? this.themeMode,
      isEnglish: isEnglish ?? this.isEnglish,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastKnownLocation': lastKnownLocation,
      'cityName': cityName,
      'themeMode': themeMode?.index,
      'isEnglish': isEnglish ,
    };
  }

  static User fromJson(Map<String, dynamic> m) {
    return User(
      lastKnownLocation: m['lastKnownLocation'] as Coordinates?,
      cityName: m['cityName'] as String?,
      themeMode: ((m['themeMode'] is int)
          ? ThemeMode.values[m['themeMode'] as int]
          : null),
      isEnglish: m['isEnglish'] as bool?,
    );
  }
}
