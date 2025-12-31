import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class QiblaCompassWidget extends StatefulWidget {
  const QiblaCompassWidget({super.key});

  @override
  State<QiblaCompassWidget> createState() => _QiblaCompassWidgetState();
}

class _QiblaCompassWidgetState extends State<QiblaCompassWidget> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;
  double? _qiblaDirection; // Bearing from North to Qibla
  String _error = '';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _calculateQibla();
      setState(() {
        _hasPermissions = true;
      });
    } else {
      setState(() {
        _error = 'Location permission required to calculate Qibla direction.';
      });
    }
  }

  Future<void> _calculateQibla() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;

      // Kaaba coordinates
      const double kaabaLat = 21.422487;
      const double kaabaLng = 39.826206;

      final double phiK = kaabaLat * math.pi / 180.0;
      final double lambdaK = kaabaLng * math.pi / 180.0;
      final double phi = lat * math.pi / 180.0;
      final double lambda = lng * math.pi / 180.0;

      final double psi =
          180.0 /
          math.pi *
          math.atan2(
            math.sin(lambdaK - lambda),
            math.cos(phi) * math.tan(phiK) -
                math.sin(phi) * math.cos(lambdaK - lambda),
          );

      setState(() {
        _qiblaDirection = psi;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermissions) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text("Grant Location Permission"),
            ),
          ],
        ),
      );
    }

    if (_qiblaDirection == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        double? direction = snapshot.data?.heading;

        // If device doesn't support compass
        if (direction == null) {
          return const Center(
            child: Text("Device does not support compass sensors"),
          );
        }

        // Adjust for Qibla
        // We want the needle to point to Qibla.
        // If "North" is 0 degrees (device heading), and Qibla is at X degrees.
        // We rotate the needle by (X - Heading).
        // OR we rotate the compass dial by (-Heading) so North is up, and draw Qibla marker at X.
        // Let's assume we have a Qibla Needle image that we rotate.
        // The needle should point to Qibla relative to device "up".
        // Rotation = QiblaBearing - DeviceHeading.

        final double qiblaBearing = _qiblaDirection!;
        final double adjusment = qiblaBearing - direction;

        // Normalize to 0-360
        // final normalizedAdjustment = (adjusment + 360) % 360;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Qibla Direction: ${qiblaBearing.toStringAsFixed(1)}°",
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Static Compass Dial Background (Optional, or generic compass rose)
                  // If we don't have a compass rose asset, we can use a container or Icon
                  // But usually apps rotate the Dial so North matches real North.
                  // Let's rotate the compass dial so North points to real North.
                  Transform.rotate(
                    angle: (direction * (math.pi / 180) * -1),
                    child: Image.asset(
                      Assets
                          .qibla, // Using the Qibla icon as a placeholder Dial or Rose? Make sure it's appropriate.
                      // Actually user gave qibla.png which might be the needle or the mosque icon.
                      // Let's assume we use a generic compass background if available or create a shape.
                      // Since we don't have a specific "compass dial" asset, let's use a decorative Container
                      // OR just rotate the Qibla pointer.
                      // BETTER UX: Rotate the "arrow" to point to Qibla.
                      width: 300,
                      height: 300,
                    ),
                  ),

                  // Need a better visualization.
                  // Standard Qibla Compass:
                  // 1. Compass Rose (Rotates with Device Heading to show North).
                  // 2. Qibla Needle (Fixed relative to Rose at Qibla Bearing).
                  // OR
                  // 1. Device is fixed. Needle rotates to point to Kaaba.

                  // Let's implement: Compass Rose (qibla.png?) rotates to point North?
                  // No, we want to point TO the Kaaba.
                  // Current best practice:
                  // Show an arrow that points to Qibla.
                  // Arrow Rotation = (QiblaBearing - DeviceHeading).
                  // If phone points at Qibla, Arrow is at 0 (Up).
                  Transform.rotate(
                    angle: (adjusment * (math.pi / 180)),
                    child: Icon(
                      Icons.navigation,
                      size: 100,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Align the arrow to the top to face Qibla",
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
