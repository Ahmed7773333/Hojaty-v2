import 'package:flutter_localizations/flutter_localizations.dart'
    as legacy;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/config/theme/app_theme.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:hojaty/features/quran/presentation/bloc/quran_event.dart';
import 'package:hojaty/l10n/app_localizations.dart';

class HojatyApp extends StatelessWidget {
  // Static navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const HojatyApp({super.key});

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

          return ValueListenableBuilder<AppThemeMode>(
            valueListenable: AppTheme.themeModeNotifier,
            builder: (context, currentMode, _) {
              return SafeArea(
                top: false,
                child: MaterialApp(
                  navigatorKey: HojatyApp.navigatorKey, // Assign the key
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: currentMode == AppThemeMode.amoled
                      ? AppTheme.amoledTheme
                      : AppTheme.darkTheme,
                  themeMode: currentMode == AppThemeMode.light
                      ? ThemeMode.light
                      : ThemeMode.dark,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    ...GlobalMaterialLocalizations.delegates,
                    // ignore: deprecated_member_use
                    legacy.GlobalMaterialLocalizations.delegate,
                    // ignore: deprecated_member_use
                    legacy.GlobalCupertinoLocalizations.delegate,
                  ],
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
