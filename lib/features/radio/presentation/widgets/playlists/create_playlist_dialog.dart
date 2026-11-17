import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class CreatePlaylistDialog extends StatefulWidget {
  final ValueChanged<String> onCreate;

  const CreatePlaylistDialog({super.key, required this.onCreate});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onCreate(name);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        context.strings.newPlaylistTitle,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: context.textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: context.strings.playlistNameHint,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            context.strings.cancel,
            style: context.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ),
        CustomElevatedButton(
          text: context.strings.create,
          width: 100.w,
          height: 40.h,
          onPressed: _submit,
        ),
      ],
    );
  }
}
