import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/home/data/models/user_db_helper.dart';
import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize dependencies
  await setupInjector();
  await Hive.initFlutter();
  await UserDbHelper.init();
  runApp(const HojatyApp());
}

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
      ),
    );
  }
}
