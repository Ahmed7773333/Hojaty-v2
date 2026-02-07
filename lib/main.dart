import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/home/data/models/user_db_helper.dart';
import 'package:hojaty/core/services/notification_service.dart';
// import 'package:alarm/alarm.dart';
// await Alarm.init();
import 'config/theme/app_color.dart';
import 'core/di/injector.dart';
import 'core/services/json_data_service.dart';
import 'features/home/data/repositories/book_repository.dart';
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

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  String? _error;
  double? _downloadProgress;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    _initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    try {
      // Initialize Hive first (required for UserDbHelper and app to work)
      await Hive.initFlutter();

      // Initialize user database (registers adapters and opens box)
      await UserDbHelper.initDatabase();

      // Initialize alarm service for prayer notifications
      // await Alarm.init();

      // Initialize dependency injection (including audio service)
      // This is the heaviest operation - runs in background
      await setupInjector();

      // Ensure essential books (Adhkar & Duaa) are downloaded
      if (mounted) {
        setState(() {
          // We can't easily show specific progress percentage for these without more complex logic
          // or modifying AssetDelivery, but we can update the UI text below via a state check or separate var.
          // For now, _downloadProgress could be reused or just let it spin.
        });
      }
      await injector<BookRepository>().ensureEssentialBooksDownloaded();

      // Initialize JsonDataService and sync if needed
      final jsonService = injector<JsonDataService>();
      await jsonService.init();

      if (!jsonService.isDataReady()) {
        await for (final progress in jsonService.syncData()) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
            });
          }
        }
      }

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
        theme: ThemeData(
          fontFamily: 'Noto Kufi Arabic',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.goldAccent),
        ),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تعذر بدء التطبيق',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _error = null;
                        _downloadProgress = null;
                      });
                      _animationController.reset();
                      _animationController.forward();
                      _initialize();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.goldLight, // Deep indigo
                  AppColor.tealPrimary, // More vibrant primary
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern (optional, kept simple for now)
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App icon with shadow
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'حُجتي',
                            style: TextStyle(
                              fontFamily:
                                  'Elgharib', // Use the fancy font if available, or fallback
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'رفيقك في كل عبادة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'Noto Kufi Arabic',
                            ),
                          ),
                          const SizedBox(height: 64),

                          // Loading indicator
                          SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                LinearProgressIndicator(
                                  value: _downloadProgress,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _downloadProgress != null
                                      ? 'جاري تجهيز المحتوى... ${(_downloadProgress! * 100).toInt()}%'
                                      : 'جاري التحميل...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Noto Kufi Arabic',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const HojatyApp();
  }
}
