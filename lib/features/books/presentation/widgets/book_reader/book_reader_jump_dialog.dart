import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class BookReaderJumpDialog extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onJump;

  const BookReaderJumpDialog({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onJump,
  });

  @override
  State<BookReaderJumpDialog> createState() => _BookReaderJumpDialogState();
}

class _BookReaderJumpDialogState extends State<BookReaderJumpDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPage.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final page = int.tryParse(_controller.text.trim());
    if (page != null && page >= 1 && page <= widget.totalPages) {
      Navigator.of(context).pop();
      widget.onJump(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        context.strings.jumpToPage,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '1 - ${widget.totalPages}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          8.ver,
          Text(
            'أدخل رقم الصفحة بين 1 و ${widget.totalPages}',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: _submit,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
