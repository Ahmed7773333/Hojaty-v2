import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_ayah_content.dart';
import 'package:hojaty/features/hifz/domain/entities/hifz_session_config.dart';
import 'package:hojaty/features/hifz/presentation/widgets/focus_ayah_card.dart';
import 'package:material_ui/material_ui.dart';

class FocusCardView extends StatefulWidget {
  final List<HifzAyahContent> ayahs;
  final int activeGlobalAyahId;
  final bool isTestingMode;
  final Set<int> revealedAyahs;
  final Set<int> hintedAyahs;
  final Set<int> masteredAyahs;
  final Set<int> needsReviewAyahs;
  final Map<int, AudioCacheStatus> ayahCacheMap;
  final ValueChanged<int> onSelectAyah;
  final ValueChanged<int> onHintFirstWords;
  final ValueChanged<int> onHintAudio;
  final void Function(int globalAyahId, bool mastered) onMarkResult;

  const FocusCardView({
    super.key,
    required this.ayahs,
    required this.activeGlobalAyahId,
    required this.isTestingMode,
    required this.revealedAyahs,
    required this.hintedAyahs,
    required this.masteredAyahs,
    required this.needsReviewAyahs,
    required this.ayahCacheMap,
    required this.onSelectAyah,
    required this.onHintFirstWords,
    required this.onHintAudio,
    required this.onMarkResult,
  });

  @override
  State<FocusCardView> createState() => _FocusCardViewState();
}

class _FocusCardViewState extends State<FocusCardView> {
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void didUpdateWidget(covariant FocusCardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeGlobalAyahId != widget.activeGlobalAyahId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToActiveAyah();
      });
    }
  }

  void _scrollToActiveAyah() {
    if (!mounted) return;
    final key = _itemKeys[widget.activeGlobalAyahId];
    final targetContext = key?.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.35,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: widget.ayahs.length,
      separatorBuilder: (_, _) => 12.ver,
      itemBuilder: (context, index) {
        final ayah = widget.ayahs[index];
        final key = _itemKeys.putIfAbsent(ayah.globalAyahId, GlobalKey.new);
        return KeyedSubtree(
          key: key,
          child: FocusAyahCard(
            ayah: ayah,
            isActive: ayah.globalAyahId == widget.activeGlobalAyahId,
            isTestingMode: widget.isTestingMode,
            isRevealed: widget.revealedAyahs.contains(ayah.globalAyahId),
            isHinted: widget.hintedAyahs.contains(ayah.globalAyahId),
            isMastered: widget.masteredAyahs.contains(ayah.globalAyahId),
            needsReview: widget.needsReviewAyahs.contains(ayah.globalAyahId),
            cacheStatus:
                widget.ayahCacheMap[ayah.globalAyahId] ??
                AudioCacheStatus.notCached,
            onTap: () => widget.onSelectAyah(ayah.globalAyahId),
            onLongPressHint: () => widget.onHintFirstWords(ayah.globalAyahId),
            onAudioHint: () => widget.onHintAudio(ayah.globalAyahId),
            onMarkMastered: () => widget.onMarkResult(ayah.globalAyahId, true),
            onMarkNeedsReview: () =>
                widget.onMarkResult(ayah.globalAyahId, false),
          ),
        );
      },
    );
  }
}

