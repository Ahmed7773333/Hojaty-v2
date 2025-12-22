import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class LanguageSelector extends StatelessWidget {
  final bool isEnglish;
  final ValueChanged<bool> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.isEnglish,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _LanguageOption(
            label: context.strings.english,
            isSelected: isEnglish,
            onTap: () => onLanguageChanged(true),
          ),
          Divider(
            height: 1,
            color: context.colors.outlineVariant.withValues(alpha: 0.3),
          ),
          _LanguageOption(
            label: context.strings.arabic,
            isSelected: !isEnglish,
            onTap: () => onLanguageChanged(false),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: context.colors.primary)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
