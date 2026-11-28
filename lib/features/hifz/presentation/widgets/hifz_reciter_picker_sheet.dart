import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:material_ui/material_ui.dart';

class HifzReciterPickerSheet extends StatelessWidget {
  final String selectedReciterId;
  final ValueChanged<Reciter> onSelect;

  const HifzReciterPickerSheet({
    super.key,
    required this.selectedReciterId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final reciter in ReciterRegistry.all)
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                leading: Icon(
                  reciter.id == selectedReciterId
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: reciter.id == selectedReciterId
                      ? AppColors.accentGold
                      : (isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted),
                ),
                title: Text(
                  reciter.localizedName(isArabic),
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  onSelect(reciter);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

