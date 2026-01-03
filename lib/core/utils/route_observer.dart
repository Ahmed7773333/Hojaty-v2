import 'package:flutter/material.dart';
import '../../features/home/data/models/user_db_helper.dart';

class RoutePersistenceObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _saveRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _saveRoute(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _saveRoute(newRoute);
    }
  }

  void _saveRoute(Route<dynamic> route) {
    debugPrint(
      'RoutePersistenceObserver: Saving route: ${route.settings.name}',
    );
    // Only save named routes that are not dialogs/bottom sheets
    if (route.settings.name == null) return;

    final routeName = route.settings.name!;
    final args = route.settings.arguments;

    debugPrint('RoutePersistenceObserver: Saving route: $routeName');

    try {
      final user = UserDbHelper.getById();
      if (user == null) {
        debugPrint('RoutePersistenceObserver: User is null, cannot save route');
        return;
      }

      // Set fields directly (not using setters that call save())
      user.lastRoute = routeName;

      // Handle arguments
      if (args != null) {
        if (args is Map<String, dynamic>) {
          Map<String, dynamic> serializedArgs = {};
          args.forEach((key, value) {
            if (value != null) {
              if (value is String || value is num || value is bool) {
                serializedArgs[key] = value;
              } else {
                serializedArgs[key] = _serializeValue(value);
              }
            }
          });
          user.lastRouteArguments = serializedArgs;
        } else {
          // Single object argument
          user.lastRouteArguments = {'_single_arg_': _serializeValue(args)};
        }
      } else {
        user.lastRouteArguments = null;
      }

      // Single save call at the end
      user.save();
      debugPrint('RoutePersistenceObserver: Route saved successfully');
    } catch (e) {
      debugPrint('RoutePersistenceObserver: Error saving route: $e');
    }
  }

  dynamic _serializeValue(dynamic value) {
    // Basic types
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    // Lists
    if (value is List) {
      return value.map((e) => _serializeValue(e)).toList();
    }

    // Maps
    if (value is Map) {
      Map<String, dynamic> newMap = {};
      value.forEach((k, v) {
        newMap[k.toString()] = _serializeValue(v);
      });
      return newMap;
    }

    // Domain Objects with toJson()
    // We can't check `hasMethod('toJson')` easily in Dart without mirrors.
    // So checking types using `is`.
    // Importing models would be circular or messy if we are not careful,
    // but this file is in core/utils, models are in features.
    // It's better to implement specific checks.

    // But `RoutePersistenceObserver` doesn't know about all models?
    // We can use `dynamic` call if we trust it, or importing.
    try {
      // Dynamic call to toJson()
      return (value as dynamic).toJson();
    } catch (e) {
      // Fallback or error
      debugPrint('Serialization failed for ${value.runtimeType}: $e');
      return null;
    }
  }
}
