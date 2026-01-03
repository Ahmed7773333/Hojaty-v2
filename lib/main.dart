import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/home/data/models/user_db_helper.dart';
import 'package:hojaty/core/services/notification_service.dart';
import 'package:alarm/alarm.dart';
import 'core/di/injector.dart';
import 'my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with splash screen immediately - shows UI instantly
  runApp(const AppLoader());
}

/// Wrapper widget that shows a splash screen while initializing
class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Initialize Hive first (required for UserDbHelper and app to work)
      await Hive.initFlutter();

      // Initialize user database (registers adapters and opens box)
      await UserDbHelper.initDatabase();

      // Initialize alarm service for prayer notifications
      await Alarm.init();

      // Initialize dependency injection (including audio service)
      // This is the heaviest operation - runs in background
      await setupInjector();

      // Mark as initialized
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Schedule non-critical operations for after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Initialize notifications (non-blocking)
        NotificationService.initializeNotifications();
        // Start location update in background (non-blocking)
        UserDbHelper.updateLocation();
      });
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error initializing app',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                      _initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A237E), // Deep indigo
                  Color(0xFF0D47A1), // Dark blue
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon or logo
                  Icon(Icons.menu_book_rounded, size: 80, color: Colors.white),
                  SizedBox(height: 24),
                  Text(
                    'حُجتي',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const HojatyApp();
  }
}
