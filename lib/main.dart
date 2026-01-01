import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/home/data/models/user_db_helper.dart';
import 'package:hojaty/core/services/notification_service.dart';
import 'core/di/injector.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize dependencies
  await setupInjector();
  await NotificationService.initializeNotifications();
  await Hive.initFlutter();
  await UserDbHelper.initDatabase();
  // Start fetching location in background, don't wait for it
  UserDbHelper.updateLocation();
  runApp(const HojatyApp());
}
