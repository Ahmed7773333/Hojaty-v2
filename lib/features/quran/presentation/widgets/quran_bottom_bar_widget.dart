import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_container.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_bar_item_widget.dart';

class QuranBottomBarWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onHomeTap;
  final VoidCallback onListenTap;
  final VoidCallback onQiraatTap;
  final VoidCallback onCheckpointsTap;
  final int currentPage;

  const QuranBottomBarWidget({
    super.key,
    required this.isVisible,
    required this.onHomeTap,
    required this.onListenTap,
    required this.onQiraatTap,
    required this.onCheckpointsTap,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      bottom: isVisible ? 0 : -140,
      left: 0,
      right: 0,
      child: LiquidGlassContainer(
        variant: LiquidGlassSurfaceVariant.surface,
        borderEdges: LiquidGlassBorderEdges.topOnly,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8.h,
          top: 10.h,
          left: 24.w,
          right: 24.w,
        ),
        fallbackDecoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.95)
              : AppColors.lightSurface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                  : AppColors.lightBorderUnselected,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuranBarItemWidget(
              label: context.strings.navHome,
              icon: Icons.home_rounded,
              onTap: onHomeTap,
            ),
            QuranBarItemWidget(
              label: context.strings.quranCheckpoints,
              icon: Icons.bookmark_rounded,
              onTap: onCheckpointsTap,
            ),
            QuranBarItemWidget(
              label: context.strings.listenToSurah,
              icon: Icons.radio,
              onTap: onListenTap,
            ),
          ],
        ),
      ),
    );
  }
}
