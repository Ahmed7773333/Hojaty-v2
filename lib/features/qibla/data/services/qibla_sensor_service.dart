import 'dart:async';
import 'package:flutter/services.dart';
import '../models/qibla_compass_data.dart';

abstract class QiblaSensorService {
  Stream<CompassRawData> get compassStream;
  void dispose();
}

class QiblaSensorServiceImpl implements QiblaSensorService {
  static const EventChannel _compassChannel =
      EventChannel('com.wolfdev.hojaty/compass');

  StreamController<CompassRawData>? _controller;
  StreamSubscription<dynamic>? _subscription;

  @override
  Stream<CompassRawData> get compassStream {
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<CompassRawData>.broadcast(
        onListen: _startListening,
        onCancel: _stopListening,
      );
    }
    return _controller!.stream;
  }

  void _startListening() {
    try {
      _subscription = _compassChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          if (event is Map) {
            final heading = (event['heading'] as num?)?.toDouble() ?? 0.0;
            final pitch = (event['pitch'] as num?)?.toDouble() ?? 0.0;
            final roll = (event['roll'] as num?)?.toDouble() ?? 0.0;
            final accuracy = (event['accuracy'] as num?)?.toInt() ?? 3;

            _controller?.add(
              CompassRawData(
                heading: heading,
                pitch: pitch,
                roll: roll,
                accuracy: accuracy,
                hasSensor: true,
              ),
            );
          }
        },
        onError: (Object error) {
          // Hardware sensor unavailable (desktop, emulator, or hardware lack)
          _controller?.add(CompassRawData.fallback());
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Platform channel not implemented on current desktop / OS
      _controller?.add(CompassRawData.fallback());
    }
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _stopListening();
    _controller?.close();
    _controller = null;
  }
}

