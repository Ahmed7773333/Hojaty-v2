import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_state.dart';
import 'package:material_ui/material_ui.dart';

class HifzStudioHeader extends StatelessWidget {
  final String title;
  final ViewMode viewMode;
  final VoidCallback onBack;
  final ValueChanged<ViewMode> onViewModeChanged;
  final VoidCallback onOpenSettings;

  const HifzStudioHeader({
    super.key,
    required this.title,
    required this.viewMode,
    required this.onBack,
    required this.onViewModeChanged,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 6.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryText),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: primaryText,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SegmentedButton<ViewMode>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              selectedBackgroundColor:
                  isDark ? AppColors.accentGold : AppColors.primaryDark,
              selectedForegroundColor:
                  isDark ? AppColors.primaryDarkHeader : AppColors.white,
            ),
            segments: [
              ButtonSegment<ViewMode>(
                value: ViewMode.focusCard,
                label: Text(
                  context.strings.hifzModeCards,
                  style: context.textTheme.labelSmall,
                ),
              ),
              ButtonSegment<ViewMode>(
                value: ViewMode.mushafOverlay,
                label: Text(
                  context.strings.hifzModeMushaf,
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
            selected: {viewMode},
            onSelectionChanged: (selection) {
              if (selection.isNotEmpty) {
                onViewModeChanged(selection.first);
              }
            },
          ),
          4.hor,
          IconButton(
            onPressed: onOpenSettings,
            icon: Icon(Icons.tune_rounded, color: primaryText),
          ),
        ],
      ),
    );
  }
}

