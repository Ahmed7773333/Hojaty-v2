import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';

class HojatyAiVoiceButtonWidget extends StatefulWidget {
  final bool isEnabled;
  final ValueChanged<String> onTextRecognized;
  final ValueChanged<bool> onListeningStateChanged;

  const HojatyAiVoiceButtonWidget({
    super.key,
    required this.isEnabled,
    required this.onTextRecognized,
    required this.onListeningStateChanged,
  });

  @override
  State<HojatyAiVoiceButtonWidget> createState() => _HojatyAiVoiceButtonWidgetState();
}

class _HojatyAiVoiceButtonWidgetState extends State<HojatyAiVoiceButtonWidget>
    with SingleTickerProviderStateMixin {
  late final stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isInitialized = false;
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (!widget.isEnabled) return;

    if (_isListening) {
      await _stopListening();
      return;
    }

    try {
      if (!_isInitialized) {
        _isInitialized = await _speech.initialize(
          onError: (error) {
            debugPrint('HojatyAiVoice: Error: ${error.errorMsg}');
            _stopListening();
          },
          onStatus: (status) {
            debugPrint('HojatyAiVoice: Status: $status');
            if (status == 'done' || status == 'notListening') {
              _stopListening();
            }
          },
        );
      }

      if (!_isInitialized) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.hojatyAiMicPermissionDenied),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      setState(() {
        _isListening = true;
      });
      widget.onListeningStateChanged(true);
      _pulseController.repeat(reverse: true);

      // Try Arabic locale first, fallback to device default if not present
      final locales = await _speech.locales();
      String? selectedLocaleId;
      for (final l in locales) {
        if (l.localeId.startsWith('ar')) {
          selectedLocaleId = l.localeId;
          break;
        }
      }

      await _speech.listen(
        onResult: (result) {
          if (mounted && result.recognizedWords.isNotEmpty) {
            widget.onTextRecognized(result.recognizedWords);
          }
        },
        localeId: selectedLocaleId ?? 'ar_SA',
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
          cancelOnError: false,
        ),
      );
    } catch (e) {
      debugPrint('HojatyAiVoice: Exception during listen: $e');
      await _stopListening();
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isListening = false;
      });
      _pulseController.stop();
      _pulseController.reset();
      widget.onListeningStateChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = _isListening ? _scaleAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: Material(
            color: _isListening
                ? Colors.redAccent
                : (isDark ? AppColors.darkCardUnselected : AppColors.lightCardUnselected),
            shape: const CircleBorder(),
            elevation: _isListening ? 4 : 0,
            child: InkWell(
              onTap: widget.isEnabled ? _toggleListening : null,
              customBorder: const CircleBorder(),
              child: Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                child: Icon(
                  _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: _isListening
                      ? AppColors.white
                      : (isDark ? AppColors.accentGoldLight : AppColors.primaryDark),
                  size: 22.r,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
