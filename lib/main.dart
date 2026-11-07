import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/di/injector.dart';
import 'core/local/user_hive_helper.dart';
import 'core/utils/screen_util_like.dart';
import 'features/homelayout/presentation/bloc/homelayout_event.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.wolfdev.hojaty.audio',
    androidNotificationChannelName: 'تلاوة القرآن الكريم',
    androidNotificationChannelDescription: 'التحكم في تشغيل الصوت في الخلفية',
    androidNotificationIcon: 'drawable/res_app_icon',
    notificationColor: const Color(0xFF1E3A34),
    androidNotificationOngoing: false,
    androidStopForegroundOnPause: false,
    fastForwardInterval: const Duration(seconds: 10),
    rewindInterval: const Duration(seconds: 10),
  );
  // Bloc.observer = AppBlocObserver();
  await UserHiveHelper.init(); // Initialize Hive and default user
  await UserHiveHelper.initNotifications(); // Initialize Awesome Notifications
  // Initialize dependencies
  await setupInjector();
  runApp(const AnaOsalyApp()); 
}

class AnaOsalyApp extends StatelessWidget {
  // Static navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const AnaOsalyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => injector<OnboardingBloc>()),
        BlocProvider(
          create: (_) =>
              injector<HomelayoutBloc>()..add(const LoadHomelayoutEvent()),
        ),
        BlocProvider(
          create: (_) => injector<QuranBloc>()..add(const LoadQuranDataEvent()),
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: UserHiveHelper.getBoxListenable(),
        builder: (context, box, child) {
          final user = UserHiveHelper.getUser();
          final locale = user?.language ?? 'ar';

          return ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeModeNotifier,
            builder: (context, currentThemeMode, _) {
              return SafeArea(
                top: false,
                child: MaterialApp(
                  navigatorKey: AnaOsalyApp.navigatorKey, // Assign the key
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: currentThemeMode,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  initialRoute: AppRoutes.splash,
                  locale: Locale(locale),
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  builder: (context, child) {
                    if (child != null) {
                      ScreenUtil.init(context: context);
                    }
                    return child!;
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
