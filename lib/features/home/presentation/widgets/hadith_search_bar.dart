import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';

class HadithSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const HadithSearchBar({super.key, required this.onChanged, this.onClear});

  @override
  State<HadithSearchBar> createState() => _HadithSearchBarState();
}

class _HadithSearchBarState extends State<HadithSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
    widget.onChanged(value);
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _hasText = false;
    });
    widget.onChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onTextChanged,
        textDirection: TextDirection.rtl,
        style: context.textTheme.bodyLarge?.copyWith(
          fontFamily: 'Noto Kufi Arabic',
        ),
        decoration: InputDecoration(
          hintText: context.strings.hadith_search_hint,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            fontFamily: 'Noto Kufi Arabic',
          ),
          prefixIcon: Icon(Icons.search_rounded, color: context.colors.primary),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: context.colors.onSurfaceVariant,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
