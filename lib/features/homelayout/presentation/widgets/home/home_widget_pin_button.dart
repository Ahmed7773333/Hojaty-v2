import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/domain/repositories/prayer_widget_repository.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_widget_guide_sheet.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_widget_showcase_bubble.dart';

class HomeWidgetPinButton extends StatefulWidget {
  const HomeWidgetPinButton({super.key});

  @override
  State<HomeWidgetPinButton> createState() => _HomeWidgetPinButtonState();
}

class _HomeWidgetPinButtonState extends State<HomeWidgetPinButton> {
  OverlayEntry? _showcaseEntry;

  @override
  void initState() {
    super.initState();
    if (!UserHiveHelper.hasSeenHomeWidgetShowcase()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future<void>.delayed(const Duration(milliseconds: 600), () {
          if (mounted && !UserHiveHelper.hasSeenHomeWidgetShowcase()) {
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
    final bubbleWidth = 250.w.clamp(220.0, screenWidth - horizontalMargin * 2);

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
            child: HomeWidgetShowcaseBubble(onDismiss: _dismissShowcase),
          ),
        ],
      ),
    );

    overlay.insert(_showcaseEntry!);
    UserHiveHelper.setHasSeenHomeWidgetShowcase(true);
  }

  void _dismissShowcase() {
    UserHiveHelper.setHasSeenHomeWidgetShowcase(true);
    _removeShowcase();
  }

  void _removeShowcase() {
    _showcaseEntry?.remove();
    _showcaseEntry = null;
  }

  Future<void> _onTap() async {
    _dismissShowcase();
    final pinned = await injector<PrayerWidgetRepository>().requestPinWidget();
    if (!mounted) return;
    if (!pinned) {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const HomeWidgetGuideSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.strings.homeWidgetGuideTitle,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.14),
            ),
          ),
          child: Icon(
            Icons.widgets_outlined,
            size: 16.r,
            color: AppColors.accentGoldLight,
          ),
        ),
      ),
    );
  }
}

