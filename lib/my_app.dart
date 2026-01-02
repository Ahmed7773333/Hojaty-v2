import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/home/data/models/user_db.dart';
import 'features/home/data/models/user_db_helper.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hojaty/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injector.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';

class HojatyApp extends StatelessWidget {
  // Static navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const HojatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<SettingsBloc>()..add(LoadSettingsEvent()),
      child: ValueListenableBuilder(
        valueListenable: Hive.box<User>(UserDbHelper.boxName).listenable(),
        builder: (context, box, child) {
          // We assume only one user (key 'user_key') or just pick the first one.
          // Or using your singleton logic:
          final user = UserDbHelper.getById();
          final themeMode = user?.uiThemeMode ?? ThemeMode.system;
          // Logic for locale: if isEnglish == true -> 'en', else 'ar'.
          // Default to 'ar' if null or whatever you prefer.
          // Checking `uiIsEnglish` getter default is false.
          final isEnglish = user?.uiIsEnglish ?? false;
          final locale = isEnglish ? const Locale('en') : const Locale('ar');

          return MaterialApp(
            navigatorKey: HojatyApp.navigatorKey, // Assign the key
            title: 'Hojaty',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: locale,
            onGenerateRoute: AppRouter.onGenerateRoute,
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
