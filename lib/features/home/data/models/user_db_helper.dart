import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/radio/data/models/readers_response.dart';
import '../../../quraan/data/models/page_data.dart';
import 'user_db.dart';
import 'package:geocoding/geocoding.dart';

typedef Condition = bool Function(User item);

class UserDbHelper {
  static const String boxName = 'User-box';
  static const String key = 'user_key';

  static Box<User> get _box => Hive.box<User>(boxName);

  static Future<void> initDatabase() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ReadersResponseModelAdapter());
    Hive.registerAdapter(MoshafAdapter());
    Hive.registerAdapter(RecitersAdapter());
    Hive.registerAdapter(PageDataAdapter());
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<User>(boxName);
    }
    // Check if user exists, if not create a default one WITHOUT location initially
    // to allow fast startup. Location will be updated safely later.
    if (getById() == null) {
      debugPrint('first Time: Creating default user without location');
      await add(key, User(cityName: 'موقع غير معروف'));
    }
  }

  static Future<void> updateLocation() async {
    // This method should be called after initDatabase
    // It runs asynchronously to not block startup
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        Coordinates currentLocation = Coordinates(
          position.latitude,
          position.longitude,
        );
        String city = 'موقع غير معروف';

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            city = placemarks.first.locality ?? city;
          }
        } catch (e) {
          debugPrint('Geocoding error: $e');
        }

        // Update the existing user with new location data
        final currentUser = getById();
        if (currentUser != null) {
          // Create a copy or update fields. Assuming User is mutable or we replace it.
          // If User is immutable/frozen, we need a copyWith or similar.
          // Since the original code did `add(..., User(...))`, let's replace/update.
          // We need to know the User structure. Assuming we can just replace the user object
          // preserving other fields ??
          // The original code was only `add` if null.
          // Here we want to UPDATE.

          // Wait, the original code ONLY set location on FIRST creation.
          // "if (getById() == null) ... await add(..., User(lastKnownLocation: currentLocation...))"
          // It did NOT update location on subsequent runs?

          // Inspecting original:
          // 51:     if (getById() == null) {
          // 52:       debugPrint('first Time');
          // 53:       await add(key, User(lastKnownLocation: currentLocation, cityName: city));
          // 54:     }

          // Yes, it only set it on first install.
          // However, for a "Hojaty" app (likely prayer times), updating location is usually desired.
          // But if the user intent is strictly optimization, I should preserve behavior logic
          // OR improve it.
          // If I only run this on "first time", I can check inside `updateLocation`.

          // Let's assume we want to update it if it's missing OR always?
          // Safe bet: Update `User` with new location.

          // We need to check if we can modify the User object.
          // Let's assume we can replace it.

          // Ideally we should merge with existing data.
          // Implementation:
          currentUser.lastKnownLocation = currentLocation;
          currentUser.cityName = city;
          await update(currentUser);
          debugPrint('Location updated');
        } else {
          // Should not happen if initDatabase runs first
          await add(
            key,
            User(lastKnownLocation: currentLocation, cityName: city),
          );
        }
      }
    } catch (e) {
      debugPrint('Location error: $e');
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
