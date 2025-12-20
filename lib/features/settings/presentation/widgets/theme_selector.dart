import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.outlineVariant.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: _ThemeOption(
                label: context.strings.system,
                icon: Icons.brightness_auto,
                isSelected: currentTheme == ThemeMode.system,
                onTap: () => onThemeChanged(ThemeMode.system),
              ),
            ),
            Expanded(
              child: _ThemeOption(
                label: context.strings.light,
                icon: Icons.light_mode,
                isSelected: currentTheme == ThemeMode.light,
                onTap: () => onThemeChanged(ThemeMode.light),
              ),
            ),
            Expanded(
              child: _ThemeOption(
                label: context.strings.dark,
                icon: Icons.dark_mode,
                isSelected: currentTheme == ThemeMode.dark,
                onTap: () => onThemeChanged(ThemeMode.dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colors.primary
        : context.colors.onSurface;
    final bgColor = isSelected
        ? context.colors.primaryContainer
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
