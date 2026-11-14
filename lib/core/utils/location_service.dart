import 'package:geolocator/geolocator.dart';
import '../../features/homelayout/data/models/prayers_helper.dart';
import '../local/user_hive_helper.dart';

/// Service managing GPS and cached geographic coordinates for prayer times.
class LocationService {
  const LocationService._();

  /// Minimum distance (in meters) to consider a movement significant (20 km).
  static const double significantDistanceMeters = 20000.0;

  /// Attempts to fetch the current device location following a reliable, battery-efficient strategy.
  ///
  /// Returns `null` if location services are disabled, permissions denied, timeout occurs,
  /// or if movement is less than [significantDistanceMeters] when [force] is false.
  /// When [force] is true, ignores distance threshold and always saves and returns new coordinates.
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

      // 3. Obtain position: try high accuracy first (for precise GPS / Emulator),
      // then fallback to low accuracy (if user granted approximate/coarse location only),
      // then fallback to last known position.
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (_) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 4),
            ),
          );
        } catch (_) {
          position = await Geolocator.getLastKnownPosition();
        }
      }

      if (position == null) return null;

      final newCoords = GeoCoordinates(position.latitude, position.longitude);

      // 4. Compare with existing cached coordinates
      final cachedLat = UserHiveHelper.getCachedLatitude();
      final cachedLng = UserHiveHelper.getCachedLongitude();

      if (cachedLat != null && cachedLng != null && !force) {
        final distance = Geolocator.distanceBetween(
          cachedLat,
          cachedLng,
          position.latitude,
          position.longitude,
        );

        // If moved less than 20 km and not forced, user is still in the same city.
        // Return null to signal no state change is needed.
        if (distance < significantDistanceMeters) {
          UserHiveHelper.setCachedLocationTimestamp(
            DateTime.now().millisecondsSinceEpoch,
          );
          return null;
        }
      }

      // 5. Significant movement, first time launch, or forced refresh: persist coordinates
      UserHiveHelper.setCachedCoordinates(position.latitude, position.longitude);
      return newCoords;
    } catch (_) {
      return null;
    }
  }
}
