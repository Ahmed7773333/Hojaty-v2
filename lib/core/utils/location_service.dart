import 'package:geolocator/geolocator.dart';
import '../../features/homelayout/data/models/prayers_helper.dart';
import '../local/user_hive_helper.dart';

/// Service managing GPS and cached geographic coordinates for prayer times.
class LocationService {
  const LocationService._();

  /// Maximum age of cached location before a background GPS refresh (12 hours).
  static const Duration maxCacheAge = Duration(hours: 12);

  /// Minimum distance (in meters) to consider a movement significant (20 km).
  static const double significantDistanceMeters = 20000.0;

  /// Checks if background refresh should be attempted based on cache age.
  static bool shouldRefreshLocation() {
    final timestamp = UserHiveHelper.getCachedLocationTimestamp();
    if (timestamp == null) return true;
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(lastUpdate) >= maxCacheAge;
  }

  /// Attempts to fetch the current device location following the smart cache-first strategy.
  ///
  /// Returns `null` if location services are disabled, permissions denied, or timeout occurs.
  /// When [force] is true, ignores cache age check (e.g. user manually tapped refresh/current location).
  static Future<GeoCoordinates?> getCurrentLocation({bool force = false}) async {
    try {
      // 1. Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      // 2. Check and request permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      // 3. Fast-path: Check last known position first (0-10ms from OS cache)
      final lastKnown = await Geolocator.getLastKnownPosition();

      // If cache is fresh and force is false, return cached coordinates directly
      if (!force && !shouldRefreshLocation() && lastKnown != null) {
        return GeoCoordinates(lastKnown.latitude, lastKnown.longitude);
      }

      // 4. Fresh GPS fix with medium accuracy & 5-second timeout (low battery, low latency)
      Position? position = lastKnown;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (_) {
        position ??= lastKnown;
      }

      if (position == null) return null;

      final newCoords = GeoCoordinates(position.latitude, position.longitude);

      // 5. Compare with existing cached coordinates
      final cachedLat = UserHiveHelper.getCachedLatitude();
      final cachedLng = UserHiveHelper.getCachedLongitude();

      if (cachedLat != null && cachedLng != null) {
        final distance = Geolocator.distanceBetween(
          cachedLat,
          cachedLng,
          position.latitude,
          position.longitude,
        );

        // If moved less than 20 km and not forced, only refresh the timestamp
        if (distance < significantDistanceMeters && !force) {
          UserHiveHelper.setCachedLocationTimestamp(
            DateTime.now().millisecondsSinceEpoch,
          );
          return GeoCoordinates(cachedLat, cachedLng);
        }
      }

      // 6. Significant movement, first time, or forced: persist coordinates
      UserHiveHelper.setCachedCoordinates(position.latitude, position.longitude);
      return newCoords;
    } catch (_) {
      return null;
    }
  }
}

