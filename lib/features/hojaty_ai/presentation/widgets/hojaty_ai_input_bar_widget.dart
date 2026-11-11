import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'hojaty_ai_voice_button_widget.dart';

class HojatyAiInputBarWidget extends StatefulWidget {
  final bool isStreaming;
  final ValueChanged<String> onSend;

  const HojatyAiInputBarWidget({
    super.key,
    required this.isStreaming,
    required this.onSend,
  });

  @override
  State<HojatyAiInputBarWidget> createState() => _HojatyAiInputBarWidgetState();
}

class _HojatyAiInputBarWidgetState extends State<HojatyAiInputBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isListeningVoice = false;

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isStreaming) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isListeningVoice) ...[
              Padding(
                padding: EdgeInsets.only(bottom: 8.h, left: 8.w, right: 8.w),
                child: Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    8.hor,
                    Text(
                      context.strings.hojatyAiMicListening,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                HojatyAiVoiceButtonWidget(
                  isEnabled: !widget.isStreaming,
                  onTextRecognized: (text) {
                    setState(() {
                      _controller.text = text;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _controller.text.length),
                      );
                    });
                  },
                  onListeningStateChanged: (isListening) {
                    setState(() {
                      _isListeningVoice = isListening;
                    });
                  },
                ),
                8.hor,
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected,
                        width: 1.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: _controller,
                      enabled: !widget.isStreaming,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                      minLines: 1,
                      maxLines: 4,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: context.strings.hojatyAiInputHint,
                        hintStyle: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                          fontSize: 13.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ),
                10.hor,
                Material(
                  color: widget.isStreaming
                      ? (isDark ? AppColors.darkCardUnselected : AppColors.lightBorderUnselected)
                      : AppColors.primaryDark,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: widget.isStreaming ? null : _handleSend,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 44.r,
                      height: 44.r,
                      alignment: Alignment.center,
                      child: widget.isStreaming
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark
                                    ? AppColors.accentGoldLight
                                    : AppColors.primaryDark,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: AppColors.white,
                              size: 20.r,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

