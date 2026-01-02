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

  @HiveField(4)
  int? tasbihNumber;

  @HiveField(5)
  bool? isSoundEnabled;

  @HiveField(6)
  bool? isVibrateEnabled;

  @HiveField(7)
  String? lastRoute;

  @HiveField(8)
  bool? showNotifications;

  User({
    this.lastKnownLocation,
    this.cityName,
    this.themeMode,
    this.isEnglish,
    this.tasbihNumber,
    this.isSoundEnabled,
    this.isVibrateEnabled,
    this.lastRoute,
    this.showNotifications,
  });

  // ----------------- UI getters/setters -----------------
  // ... existing getters/setters ...

  bool get uiShowNotifications => showNotifications ?? true;
  set uiShowNotifications(bool? v) {
    showNotifications = v;
    try {
      save();
    } catch (_) {}
  }

  Coordinates get uiLastKnownLocation =>
      lastKnownLocation ??
      const Coordinates(30.108772, 31.319205); // Cairo, Egy

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

  ThemeMode get uiThemeMode => themeMode ?? ThemeMode.system;
  set uiThemeMode(ThemeMode? v) {
    themeMode = v;
    try {
      save();
    } catch (_) {}
  }

  bool get uiIsEnglish => isEnglish ?? false;
  set uiIsEnglish(bool? v) {
    isEnglish = v;
    try {
      save();
    } catch (_) {}
  }

  int get tasbihNumberUI => tasbihNumber ?? 0;
  set tasbihNumberUI(int? v) {
    tasbihNumber = v;
    try {
      save();
    } catch (_) {}
  }

  bool get uiIsSoundEnabled => isSoundEnabled ?? true;
  set uiIsSoundEnabled(bool? v) {
    isSoundEnabled = v;
    try {
      save();
    } catch (_) {}
  }

  bool get uiIsVibrateEnabled => isVibrateEnabled ?? true;
  set uiIsVibrateEnabled(bool? v) {
    isVibrateEnabled = v;
    try {
      save();
    } catch (_) {}
  }

  String? get uiLastRoute => lastRoute;
  set uiLastRoute(String? v) {
    lastRoute = v;
    try {
      save();
    } catch (_) {}
  }

  void increaseTashbih() {
    tasbihNumber = tasbihNumberUI + 1;
    save();
  }

  void decreaseTashbih() {
    tasbihNumber = tasbihNumberUI - 1;
    save();
  }

  void resetTashbihNumber() {
    tasbihNumber = 0;
    save();
  }

  void changeTasbihNumber(bool increment) {
    if (increment) {
      increaseTashbih();
    } else {
      decreaseTashbih();
    }
  }

  User copyWith({
    Coordinates? lastKnownLocation,
    String? cityName,
    ThemeMode? themeMode,
    bool? isEnglish,
    int? tasbihNumber,
    String? lastRoute,
    bool? showNotifications,
  }) {
    return User(
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      cityName: cityName ?? this.cityName,
      themeMode: themeMode ?? this.themeMode,
      isEnglish: isEnglish ?? this.isEnglish,
      tasbihNumber: tasbihNumber ?? this.tasbihNumber,
      lastRoute: lastRoute ?? this.lastRoute,
      showNotifications: showNotifications ?? this.showNotifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastKnownLocation': lastKnownLocation,
      'cityName': cityName,
      'themeMode': themeMode?.index,
      'isEnglish': isEnglish,
      'tasbihNumber': tasbihNumber,
      'isSoundEnabled': isSoundEnabled,
      'isVibrateEnabled': isVibrateEnabled,
      'lastRoute': lastRoute,
      'showNotifications': showNotifications,
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
      lastRoute: m['lastRoute'] as String?,
      showNotifications: m['showNotifications'] as bool?,
    );
  }
}
