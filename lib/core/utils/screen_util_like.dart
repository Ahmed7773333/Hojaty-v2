// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/widgets.dart';

import '../../main.dart'; // Changed from my_app.dart

class ScreenUtil {
  ScreenUtil._();

  // defaults (like typical designs)
  static double designWidth = 375.0;
  static double designHeight = 812.0;

  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _scaleWidth = 1;
  static double _scaleHeight = 1;
  static double _scaleText = 1;
  static bool _inited = false;

  /// Initialize once (call early, e.g. in top-level widget build)
  static void init({
    BuildContext? context,
    double designW = 375,
    double designH = 812,
  }) {
    // Changed from MyApp
    final ctx = context ?? HojatyApp.navigatorKey.currentContext; 
    if (ctx == null) {
      // If no context available, do nothing now — will auto-init later on demand
      designWidth = designW;
      designHeight = designH;
      _inited = false;
      return;
    }

    final mq = MediaQuery.sizeOf(ctx);
    designWidth = designW;
    designHeight = designH;
    _screenWidth = mq.width;
    _screenHeight = mq.height;
    _scaleWidth = _screenWidth / designWidth;
    _scaleHeight = _screenHeight / designHeight;
    // text scaling uses the smaller scale (keeps fonts proportional)
    _scaleText = math.min(_scaleWidth, _scaleHeight);
    _inited = true;
  }

  // ensure initialized; try to init from navigatorKey if not done.
  static void _ensureInit() {
    if (_inited) return;
    // Changed from MyApp
    final ctx = HojatyApp.navigatorKey.currentContext;
    if (ctx != null) {
      init(context: ctx, designW: designWidth, designH: designHeight);
    } else {
      // fallback to reasonable defaults using window if possible
      final window = WidgetsBinding.instance.window;
      final physical = window.physicalSize;
      if (physical.isEmpty) return;
      _screenWidth = physical.width / window.devicePixelRatio;
      _screenHeight = physical.height / window.devicePixelRatio;
      _scaleWidth = _screenWidth / designWidth;
      _scaleHeight = _screenHeight / designHeight;
      _scaleText = math.min(_scaleWidth, _scaleHeight);
      _inited = true;
    }
  }

  // getters used by extension
  static double get screenWidth {
    _ensureInit();
    return _screenWidth;
  }

  static double get screenHeight {
    _ensureInit();
    return _screenHeight;
  }

  static double get scaleWidth {
    _ensureInit();
    return _scaleWidth;
  }

  static double get scaleHeight {
    _ensureInit();
    return _scaleHeight;
  }

  static double get scaleText {
    _ensureInit();
    return _scaleText;
  }
}

/// Extension matching ScreenUtil-like behavior.
///
/// Usage examples:
///  - 16.w  -> scales 16 by screenWidth / designWidth
///  - 50.h  -> scales 50 by screenHeight / designHeight
///  - 1.sw  -> returns screen width
///  - 1.sh  -> returns screen height
///  - 14.sp -> scaled font size
extension Sizee on num {
  /// Actual screen width multiplier:
  /// 1.sw == device screen width
  double get sw {
    return this * ScreenUtil.screenWidth;
  }

  /// Actual screen height multiplier:
  /// 1.sh == device screen height
  double get sh {
    return this * ScreenUtil.screenHeight;
  }

  /// Width scaled relative to design width:
  /// e.g. 20.w => 20 * (screenWidth / designWidth)
  double get w {
    return (toDouble()) * ScreenUtil.scaleWidth;
  }

  /// Height scaled relative to design height:
  /// e.g. 50.h => 50 * (screenHeight / designHeight)
  double get h {
    return (toDouble()) * ScreenUtil.scaleHeight;
  }

  /// Radius scaled by text scale (or smaller of width/height scale)
  double get r {
    return (toDouble()) * ScreenUtil.scaleText;
  }

  Widget get ver {
    return SizedBox(height: toDouble().h);
  }

  Widget get hor {
    return SizedBox(width: toDouble().w);
  }
}
