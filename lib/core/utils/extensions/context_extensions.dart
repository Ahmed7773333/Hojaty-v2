import 'package:flutter/material.dart';
// import 'package:timegates/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  // AppLocalizations get strings => AppLocalizations.of(this)!;
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
}

/// 🌍 A complete BuildContext extension to handle all navigation types
/// like GoRouter but using Flutter's native Navigator system.
extension RoutingExtension on BuildContext {
  /// 🔹 Push a route by name with optional arguments
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? extra}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: extra);
  }

  /// 🔹 Replace the current route with a new one
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? extra,
  }) {
    return Navigator.of(
      this,
    ).pushReplacementNamed<T, TO>(routeName, result: result, arguments: extra);
  }

  /// 🔹 Push a route and remove all previous routes until [predicate]
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    bool Function(Route<dynamic>)? predicate,
    Object? extra,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (Route<dynamic> route) => false,
      arguments: extra,
    );
  }

  Future<void> popNamedUntil<T extends Object?>(
    String routeName, {
    Object? extra,
  }) async {
    // Pop until route with name == routeName
    Navigator.of(this).popUntil((ModalRoute.withName(routeName)));

    // Then optionally pop one more with a result
    // return Navigator.of(this).maybePop<T>(extra as T?);
  }

  /// 🔹 Push a new MaterialPageRoute directly (widget navigation)
  Future<T?> push<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// 🔹 Replace current screen with a new widget
  Future<T?> replace<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// 🔹 Push a page with fade transition
  Future<T?> pushFade<T extends Object?>(Widget page, {int duration = 300}) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder(
        pageBuilder: (_, i, ii) => page,
        transitionsBuilder: (_, animation, i, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: duration),
      ),
    );
  }

  /// 🔹 Push a page with slide transition (customizable direction)
  Future<T?> pushSlide<T extends Object?>(
    Widget page, {
    int duration = 300,
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder(
        pageBuilder: (_, i, ii) => page,
        transitionsBuilder: (_, animation, i, child) {
          final tween = Tween(
            begin: begin,
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: duration),
      ),
    );
  }

  /// 🔹 Push and clear the entire navigation stack
  Future<T?> go<T extends Object?>(String routeName, {Object? extra}) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil<T>(routeName, (route) => false, arguments: extra);
  }

  /// 🔹 Pop the current screen
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  void simplePop<T extends Object?>([T? result]) {
    // Try to pop bottom sheet, dialog, or normal page.
    if (Navigator.canPop(this)) {
      Navigator.of(this, rootNavigator: true).maybePop(result);
    }
  }

  /// 🔹 Pop until a certain route name
  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }

  /// 🔹 Try to pop if possible
  void maybePop<T extends Object?>([T? result]) {
    Navigator.of(this).maybePop(result);
  }

  /// 🔹 Pop all until first route
  void popToFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  /// 🔹 Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  /// 🔹 Get the current route name (if available)
  String? get currentRouteName => ModalRoute.of(this)?.settings.name;

  /// 🔹 Push dialog route (alert or custom)
  Future<T?> showDialogRoute<T>({
    required Widget builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (contexxt) => builder,
    );
  }

  /// 🔹 Push bottom sheet route
  Future<T?> showBottomSheetRoute<T>({
    required Widget builder,
    bool isScrollControlled = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      builder: (contexxt) => builder,
    );
  }
}
