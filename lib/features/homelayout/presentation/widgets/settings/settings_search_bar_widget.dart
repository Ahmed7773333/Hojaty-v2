import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/domain/entities/setting_search_item.dart';
import 'package:hojaty/features/homelayout/domain/usecases/search_settings_usecase.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_search_result_tile_widget.dart';

class SettingsSearchBarWidget extends StatefulWidget {
  final bool adhanTabOnly;
  final ValueChanged<SettingSearchItem> onResultSelected;

  const SettingsSearchBarWidget({
    super.key,
    this.adhanTabOnly = false,
    required this.onResultSelected,
  });

  @override
  State<SettingsSearchBarWidget> createState() =>
      _SettingsSearchBarWidgetState();
}

class _SettingsSearchBarWidgetState extends State<SettingsSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SearchSettingsUseCase _searchUseCase = const SearchSettingsUseCase();

  List<SettingSearchItem> _results = const [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _results = _searchUseCase(
        query,
        adhanTabOnly: widget.adhanTabOnly,
      );
    });
  }

  void _clear() {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _results = const [];
    });
  }

  void _selectItem(SettingSearchItem item) {
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _results = const [];
    });
    widget.onResultSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hasQuery = _controller.text.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color:
                isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: hasQuery
                  ? AppColors.accentGold.withValues(alpha: 0.7)
                  : (isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20.r,
                color: hasQuery
                    ? AppColors.accentGold
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
              10.hor,
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onQueryChanged,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: context.strings.settingsSearchHint,
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12.5.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (hasQuery)
                GestureDetector(
                  onTap: _clear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (hasQuery) ...[
          8.ver,
          Container(
            constraints: BoxConstraints(maxHeight: 260.h),
            decoration: BoxDecoration(
              color:
                  isDark ? AppColors.darkCardUnselected : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _results.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 18.r,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        10.hor,
                        Expanded(
                          child: Text(
                            context.strings.settingsSearchNoResults,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 12.5.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    itemCount: _results.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.darkBorderUnselected.withValues(
                              alpha: 0.45,
                            )
                          : AppColors.lightBorderUnselected.withValues(
                              alpha: 0.55,
                            ),
                    ),
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      return SettingsSearchResultTileWidget(
                        item: item,
                        onTap: () => _selectItem(item),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}
