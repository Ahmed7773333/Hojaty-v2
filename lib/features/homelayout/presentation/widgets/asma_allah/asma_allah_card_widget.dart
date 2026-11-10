import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/asma_allah_model.dart';

class AsmaAllahCardWidget extends StatefulWidget {
  final AsmaAllahModel item;

  const AsmaAllahCardWidget({
    super.key,
    required this.item,
  });

  @override
  State<AsmaAllahCardWidget> createState() => _AsmaAllahCardWidgetState();
}

class _AsmaAllahCardWidgetState extends State<AsmaAllahCardWidget> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final name = widget.item.getName(isAr);
    final meaning = widget.item.getMeaning(isAr);
    final explanation = widget.item.getExplanation(isAr);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCardUnselected
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _isExpanded
                  ? AppColors.accentGold.withValues(alpha: 0.5)
                  : (isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${widget.item.number}',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  12.hor,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: isAr ? 19.sp : 16.sp,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            if (!isAr) ...[
                              8.hor,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accentGold.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  widget.item.arabic,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: AppColors.accentGold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (meaning.isNotEmpty) ...[
                          4.ver,
                          Text(
                            meaning,
                            maxLines: _isExpanded ? 4 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 12.sp,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  8.hor,
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    size: 22.sp,
                  ),
                ],
              ),
              if (_isExpanded && explanation.isNotEmpty) ...[
                12.ver,
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark
                      ? AppColors.darkBorderUnselected
                      : AppColors.lightBorderUnselected,
                ),
                10.ver,
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14.sp,
                      color: AppColors.accentGold,
                    ),
                    6.hor,
                    Text(
                      context.strings.explanationLabel,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
                6.ver,
                Text(
                  explanation,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

