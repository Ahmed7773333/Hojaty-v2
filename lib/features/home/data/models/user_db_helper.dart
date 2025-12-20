import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'user_db.dart';
import 'package:geocoding/geocoding.dart';

typedef Condition = bool Function(User item);

class UserDbHelper {
  static const String boxName = 'User-box';
  static const String key = 'user_key';

  static Box<User> get _box => Hive.box<User>(boxName);

  static Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    Coordinates? currentLocation;
    String city = 'موقع غير معروف';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        currentLocation = Coordinates(position.latitude, position.longitude);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          city = placemarks.first.locality ?? city;
        }
      } catch (e) {
        debugPrint('Geocoding or Location error: $e');
      }
    }

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<User>(boxName);
    }
    if (getById() == null) {
      await add(key, User(lastKnownLocation: currentLocation, cityName: city));
    }
  }

  // ---------- CRUD ----------
  static Future<void> add(dynamic id, User item) => _box.put(id, item);

  static Future<void> update(User item) => _box.put(key, item);

  static List<User> getAll() => _box.values.toList();

  static User? getById() => _box.get(key);

  static Future<void> delete(dynamic id) => _box.delete(id);

  static Future<void> deleteAll(List<dynamic> ids) => _box.deleteAll(ids);

  static Future<int> clear() => _box.clear();

  static Future<void> deleteFromDisk() => _box.deleteFromDisk();

  // ---------- Helpers ----------

  /// Returns every item that matches [test].
  List<User> where(Condition test) => _box.values.where(test).toList();

  /// Deletes every item whose value satisfies [test].
  static Future<int> deleteWhere(Condition test) async {
    final keysToDelete = _box.keys
        .where((k) => test(_box.get(k) as User))
        .toList();
    await _box.deleteAll(keysToDelete);
    return keysToDelete.length;
  }

  /// Returns the first matching item or null.
  static User? firstWhereOrNull(Condition test) {
    try {
      return _box.values.firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// Returns the last matching item or null.
  static User? lastWhereOrNull(Condition test) {
    try {
      return _box.values.lastWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// Returns true if at least one element satisfies [test].
  static bool any(Condition test) => _box.values.any(test);

  /// Count elements that satisfy [test] (or all if [test] is null).
  static int count([Condition? test]) =>
      test == null ? _box.length : _box.values.where(test).length;

  /// Returns a Map<key, value> of items that match [test].
  static Map<dynamic, User> mapWhere(Condition test) {
    final result = <dynamic, User>{};
    for (final k in _box.keys) {
      final v = _box.get(k);
      if (v != null && test(v)) result[k] = v;
    }
    return result;
  }
}
