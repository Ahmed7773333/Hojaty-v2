import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

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
        // BlocProvider(
        //   create: (_) => injector<AuthBloc>()..add(CheckAuthStatusEvent()),
        // ),
        // Add other global BLoCs here
      ],
      child: MaterialApp(
        navigatorKey: HojatyApp.navigatorKey, // Assign the key
        title: 'Hojaty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Or control this with a BLoC
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
      ),
    );
  }
}
