import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/features/home/data/models/user_db_helper.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../widgets/sebha_counter_widget.dart';
import '../widgets/sebha_settings_widget.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage> {
  // Access singleton or static helper.
  // UserDbHelper.getById() returns User!
  // We should listen to changes if we want real-time updates from other places?
  // The original code used `setState` to update `count` which synced with Hive manually.
  // I'll keep the logic but use the new User methods.

  // Note: user object reference might change if box updates?
  // Hive objects update in place usually if extended HiveObject.
  final user = UserDbHelper.getById();
  int _localCount = 0;

  @override
  void initState() {
    super.initState();
    _localCount = user!.tasbihNumberUI;
  }

  void _increment() {
    if (user == null) return;
    user!.changeTasbihNumber(true);

    // Update local state to trigger rebuilds
    setState(() {
      _localCount = user!.tasbihNumberUI;
    });

    _playEffects();
  }

  void _playEffects() {
    // Sound
    if (user!.uiIsSoundEnabled == true) {
      SystemSound.play(SystemSoundType.click);
    }
    // Vibrate
    if (user!.uiIsVibrateEnabled == true) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _confirmReset() async {
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(context.strings.resetDialogTitle),
          content: Text(context.strings.resetDialogContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: Text(context.strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: Text(context.strings.confirm),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      user!.resetTashbihNumber();
      setState(() {
        _localCount = 0;
      });
      _playEffects();
    }
  }

  void _toggleSound() {
    setState(() {
      user!.uiIsSoundEnabled = !(user!.uiIsSoundEnabled);
    });
  }

  void _toggleVibrate() {
    setState(() {
      user!.uiIsVibrateEnabled = !(user!.uiIsVibrateEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    // If user is null (e.g. Hive init failed), maybe show loader or empty?
    // Original code assumed user might be null but mostly worked.
    // We'll proceed.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.sebhaTitle,
          style: AppTextStyles.notoKufiArabicHeading20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Settings
            SebhaSettingsWidget(
              isSoundEnabled: user!.uiIsSoundEnabled,
              isVibrateEnabled: user!.uiIsVibrateEnabled,
              onReset: _confirmReset,
              onToggleSound: _toggleSound,
              onToggleVibrate: _toggleVibrate,
            ),

            // Beads Canvas
            // Expanded to fill space? Original used fixed height 600.h.
            // Let's use Expanded or flexible to avoid generic overflow on small screens,
            // but keep the fixed design if that's preferred.
            // The widget handles tap.
            Expanded(
              child: ListView(
                // Use list view to allow scrolling on small screens if 600h is too big
                children: [
                  SebhaCounterWidget(count: _localCount, onTap: _increment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
