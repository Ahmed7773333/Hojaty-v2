import 'dart:math' as math;
import 'package:equatable/equatable.dart';

/// Pure mathematical calculation utilities for Qibla bearing and distances.
class QiblaMath {
  QiblaMath._();

  /// Holy Kaaba coordinates in Makkah al-Mukarramah
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  static double _degToRad(double deg) => deg * (math.pi / 180.0);
  static double _radToDeg(double rad) => rad * (180.0 / math.pi);

  /// Calculates the forward azimuth / bearing in degrees (0..360) from [lat, lon] to Kaaba.
  static double calculateBearing({required double lat, required double lon}) {
    final lat1 = _degToRad(lat);
    final lon1 = _degToRad(lon);
    final lat2 = _degToRad(kaabaLatitude);
    final lon2 = _degToRad(kaabaLongitude);

    final dLon = lon2 - lon1;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearingRad = math.atan2(y, x);
    final bearingDeg = _radToDeg(bearingRad);
    return (bearingDeg + 360.0) % 360.0;
  }

  /// Calculates geodesic distance in km to Kaaba using the Haversine formula.
  static double calculateDistanceKm({required double lat, required double lon}) {
    const earthRadiusKm = 6371.0;
    final lat1 = _degToRad(lat);
    final lon1 = _degToRad(lon);
    final lat2 = _degToRad(kaabaLatitude);
    final lon2 = _degToRad(kaabaLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Calculates the shortest angular difference in range [-180, 180].
  /// Positive value means target is to the right (clockwise).
  /// Negative value means target is to the left (counter-clockwise).
  static double getAngularDifference({
    required double currentHeading,
    required double targetBearing,
  }) {
    var diff = (targetBearing - currentHeading) % 360.0;
    if (diff > 180.0) diff -= 360.0;
    if (diff < -180.0) diff += 360.0;
    return diff;
  }

  /// Interpolates angles taking the shortest circular route across the 0/360 boundary.
  static double smoothAngle({
    required double current,
    required double target,
    double factor = 0.25,
  }) {
    final diff = getAngularDifference(
      currentHeading: current,
      targetBearing: target,
    );
    final next = (current + diff * factor) % 360.0;
    return next < 0 ? next + 360.0 : next;
  }

  /// Resolves coordinates for known city strings with fallback to Cairo.
  static ({double lat, double lon, String name}) resolveCoordinates(String? rawCityName) {
    if (rawCityName == null || rawCityName.isEmpty) {
      return (lat: 30.0444, lon: 31.2357, name: 'القاهرة، مصر');
    }

    final lower = rawCityName.toLowerCase();
    if (lower.contains('alexandria') || lower.contains('إسكندرية') || lower.contains('اسكندرية')) {
      return (lat: 31.2001, lon: 29.9187, name: 'الإسكندرية، مصر');
    }
    if (lower.contains('giza') || lower.contains('جيزة')) {
      return (lat: 30.0131, lon: 31.2089, name: 'الجيزة، مصر');
    }
    if (lower.contains('makkah') || lower.contains('مكة')) {
      return (lat: 21.4225, lon: 39.8262, name: 'مكة المكرمة، السعودية');
    }
    if (lower.contains('madinah') || lower.contains('مدينة')) {
      return (lat: 24.5247, lon: 39.5692, name: 'المدينة المنورة، السعودية');
    }
    if (lower.contains('riyadh') || lower.contains('رياض')) {
      return (lat: 24.7136, lon: 46.6753, name: 'الرياض، السعودية');
    }
    if (lower.contains('dubai') || lower.contains('دبي')) {
      return (lat: 25.2048, lon: 55.2708, name: 'دبي، الإمارات');
    }
    if (lower.contains('amman') || lower.contains('عمان')) {
      return (lat: 31.9454, lon: 35.9284, name: 'عمان، الأردن');
    }
    if (lower.contains('doha') || lower.contains('دوحة')) {
      return (lat: 25.2854, lon: 51.5310, name: 'الدوحة، قطر');
    }
    if (lower.contains('mansoura') || lower.contains('منصورة')) {
      return (lat: 31.0409, lon: 31.3785, name: 'المنصورة، مصر');
    }
    if (lower.contains('tanta') || lower.contains('طنطا')) {
      return (lat: 30.7865, lon: 31.0004, name: 'طنطا، مصر');
    }
    if (lower.contains('aswan') || lower.contains('أسوان') || lower.contains('اسوان')) {
      return (lat: 24.0889, lon: 32.8998, name: 'أسوان، مصر');
    }
    if (lower.contains('luxor') || lower.contains('أقصر') || lower.contains('اقصر')) {
      return (lat: 25.6872, lon: 32.6396, name: 'الأقصر، مصر');
    }
    if (lower.contains('port said') || lower.contains('بورسعيد')) {
      return (lat: 31.2653, lon: 32.3019, name: 'بورسعيد، مصر');
    }
    if (lower.contains('suez') || lower.contains('سويس')) {
      return (lat: 29.9668, lon: 32.5498, name: 'السويس، مصر');
    }

    return (lat: 30.0444, lon: 31.2357, name: rawCityName);
  }
}

/// Raw sensor measurement emitted by native platform channels.
class CompassRawData extends Equatable {
  final double heading;
  final double pitch;
  final double roll;
  final int accuracy;
  final bool hasSensor;

  const CompassRawData({
    required this.heading,
    required this.pitch,
    required this.roll,
    required this.accuracy,
    required this.hasSensor,
  });

  factory CompassRawData.fallback() {
    return const CompassRawData(
      heading: 0.0,
      pitch: 0.0,
      roll: 0.0,
      accuracy: 3,
      hasSensor: false,
    );
  }

  @override
  List<Object?> get props => [heading, pitch, roll, accuracy, hasSensor];
}

