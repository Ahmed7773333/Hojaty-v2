import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_times_route_args.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_widget_showcase_bubble.dart';

class HomeAzanSettingsButton extends StatefulWidget {
  const HomeAzanSettingsButton({super.key});

  @override
  State<HomeAzanSettingsButton> createState() => _HomeAzanSettingsButtonState();
}

class _HomeAzanSettingsButtonState extends State<HomeAzanSettingsButton> {
  OverlayEntry? _showcaseEntry;

  @override
  void initState() {
    super.initState();
    if (!UserHiveHelper.hasSeenAzanSettingsShowcase()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future<void>.delayed(const Duration(milliseconds: 900), () {
          if (mounted && !UserHiveHelper.hasSeenAzanSettingsShowcase()) {
            _showShowcase();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _removeShowcase();
    super.dispose();
  }

  void _showShowcase() {
    if (_showcaseEntry != null || !mounted) return;
    final overlay = Overlay.maybeOf(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (overlay == null || renderBox == null || !renderBox.hasSize) return;

    final buttonOffset = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = 20.w;
    final bubbleWidth = (250.w).clamp(220.0, screenWidth - horizontalMargin * 2);

    final idealLeft =
        buttonOffset.dx + (buttonSize.width / 2) - (bubbleWidth / 2);
    final clampedLeft = idealLeft.clamp(
      horizontalMargin,
      screenWidth - bubbleWidth - horizontalMargin,
    );
    final top = buttonOffset.dy + buttonSize.height + 10.h;

    _showcaseEntry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _dismissShowcase,
              child: ColoredBox(
                color: AppColors.black.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            top: top,
            left: clampedLeft,
            width: bubbleWidth,
            child: HomeWidgetShowcaseBubble(
              onDismiss: _dismissShowcase,
              title: context.strings.azanSettingsShowcaseTitle,
              body: context.strings.azanSettingsShowcaseBody,
              icon: Icons.tune_rounded,
            ),
          ),
        ],
      ),
    );

    overlay.insert(_showcaseEntry!);
    UserHiveHelper.setHasSeenAzanSettingsShowcase(true);
  }

  void _dismissShowcase() {
    UserHiveHelper.setHasSeenAzanSettingsShowcase(true);
    _removeShowcase();
  }

  void _removeShowcase() {
    _showcaseEntry?.remove();
    _showcaseEntry = null;
  }

  void _onTap() {
    _dismissShowcase();
    context.pushNamed(
      AppRoutes.prayerTimes,
      extra: const PrayerTimesRouteArgs(initialTabIndex: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          child: Icon(
            Icons.tune_rounded,
            size: 18.r,
            color: AppColors.accentGold,
          ),
        ),
      ),
    );
  }
}

