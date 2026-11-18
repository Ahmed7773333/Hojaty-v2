import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/font_type_model.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/font_type_radio_row_widget.dart';

class FontTypeSelectionCardWidget extends StatelessWidget {
  final List<FontTypeModel> fontTypes;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const FontTypeSelectionCardWidget({
    super.key,
    required this.fontTypes,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.fontTypeSectionTitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        10.ver,
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
            ),
          ),
          child: Column(
            children: List.generate(fontTypes.length, (index) {
              final fontType = fontTypes[index];
              return Column(
                children: [
                  FontTypeRadioRowWidget(
                    fontType: fontType,
                    isSelected: selectedId == fontType.id,
                    onTap: () => onSelect(fontType.id),
                  ),
                  if (index < fontTypes.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderUnselected.withValues(
                              alpha: 0.5,
                            )
                          : AppColors.lightBorderUnselected.withValues(
                              alpha: 0.6,
                            ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
