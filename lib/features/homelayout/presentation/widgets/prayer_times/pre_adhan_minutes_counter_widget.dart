import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';

class PreAdhanMinutesCounterWidget extends StatefulWidget {
  final int minutes;
  final ValueChanged<int> onChanged;

  const PreAdhanMinutesCounterWidget({
    super.key,
    required this.minutes,
    required this.onChanged,
  });

  @override
  State<PreAdhanMinutesCounterWidget> createState() =>
      _PreAdhanMinutesCounterWidgetState();
}

class _PreAdhanMinutesCounterWidgetState
    extends State<PreAdhanMinutesCounterWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.minutes.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      final parsed = int.tryParse(_controller.text);
      final valid = (parsed == null || parsed <= 0) ? 5 : parsed.clamp(1, 120);
      _controller.text = valid.toString();
      if (valid != widget.minutes) {
        widget.onChanged(valid);
      }
    }
  }

  @override
  void didUpdateWidget(covariant PreAdhanMinutesCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minutes != oldWidget.minutes) {
      final currentText = _controller.text;
      final newText = widget.minutes.toString();
      if (currentText != newText && !_focusNode.hasFocus) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _decrement() {
    if (widget.minutes > 1) {
      final newVal = widget.minutes - 1;
      _controller.text = newVal.toString();
      widget.onChanged(newVal);
    }
  }

  void _increment() {
    if (widget.minutes < 120) {
      final newVal = widget.minutes + 1;
      _controller.text = newVal.toString();
      widget.onChanged(newVal);
    }
  }

  void _onTextChanged(String text) {
    if (text.isEmpty) return;
    final parsed = int.tryParse(text);
    if (parsed != null && parsed > 0) {
      final clamped = parsed.clamp(1, 120);
      widget.onChanged(clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final canDecrement = widget.minutes > 1;
    final canIncrement = widget.minutes < 120;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.strings.preAdhanCustomMinutesLabel,
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
        8.ver,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canDecrement ? _decrement : null,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: canDecrement
                          ? (isDark
                              ? AppColors.white.withValues(alpha: 0.08)
                              : AppColors.primaryDark.withValues(alpha: 0.08))
                          : (isDark
                              ? AppColors.white.withValues(alpha: 0.02)
                              : AppColors.black.withValues(alpha: 0.02)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.remove_rounded,
                      size: 20.r,
                      color: canDecrement
                          ? (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryDark)
                          : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicWidth(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 6.h,
                          ),
                          hintText: '5',
                          hintStyle: context.textTheme.titleMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        onChanged: _onTextChanged,
                        onSubmitted: (text) {
                          final parsed = int.tryParse(text);
                          final valid = (parsed == null || parsed <= 0)
                              ? 5
                              : parsed.clamp(1, 120);
                          _controller.text = valid.toString();
                          widget.onChanged(valid);
                        },
                      ),
                    ),
                    6.hor,
                    Text(
                      context.strings.preAdhanMinutesUnit,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canIncrement ? _increment : null,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: canIncrement
                          ? (isDark
                              ? AppColors.white.withValues(alpha: 0.08)
                              : AppColors.primaryDark.withValues(alpha: 0.08))
                          : (isDark
                              ? AppColors.white.withValues(alpha: 0.02)
                              : AppColors.black.withValues(alpha: 0.02)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 20.r,
                      color: canIncrement
                          ? (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.primaryDark)
                          : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

