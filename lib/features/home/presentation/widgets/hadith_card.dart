import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/hadith.dart';
import '../../../../config/theme/app_text_styles.dart';

class HadithCard extends StatefulWidget {
  final Hadith hadith;

  const HadithCard({super.key, required this.hadith});

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with hadith number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${context.strings.hadith_number} ${widget.hadith.number}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.format_quote_rounded,
                  color: context.colors.primary.withValues(alpha: 0.5),
                  size: 28,
                ),
              ],
            ),
          ),

          // Hadith text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.hadith.hadith,
              style: AppTextStyles.hafsSmartStyle.copyWith(
                color: context.colors.onSurface,
                height: 2.0,
              ),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
          ),

          // Expand/Collapse description button
          if (widget.hadith.description.isNotEmpty) ...[
            Divider(
              height: 1,
              color: context.colors.outlineVariant.withValues(alpha: 0.3),
            ),
            InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(_isExpanded ? 0 : 20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: context.colors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isExpanded
                          ? context.strings.hide_description
                          : context.strings.show_description,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.colors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Description (expanded)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Text(
                  widget.hadith.description,
                  style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                    color: context.colors.onSurfaceVariant,
                    height: 1.8,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
