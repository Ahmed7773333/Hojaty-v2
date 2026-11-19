import 'package:audio_session/audio_session.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_audio_art_helper.dart';
import 'package:hojaty/hojaty_app.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final audioSession = await AudioSession.instance;
    await audioSession.configure(const AudioSessionConfiguration.music());
  } catch (_) {}
  await Future.wait([
    AppAudioArtHelper.init(),
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.wolfdev.hojaty.audio',
      androidNotificationChannelName: 'تلاوة القرآن الكريم',
      androidNotificationChannelDescription: 'التحكم في تشغيل الصوت في الخلفية',
      androidNotificationIcon: 'drawable/res_app_icon',
      notificationColor: const Color(0xFF1E3A34),
      androidStopForegroundOnPause: false,
      artDownscaleWidth: 300,
      artDownscaleHeight: 300,
    ),
    UserHiveHelper.init(),
  ]);
  await UserHiveHelper.initNotifications();
  await setupInjector();
  runApp(const HojatyApp());
}
