import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/data/models/azan_audio_item_model.dart';
import 'package:hojaty/features/homelayout/data/models/prayer_time_model.dart';
import 'package:hojaty/features/homelayout/data/services/azan_audio_service.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_delete_confirm_dialog.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_library_empty_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_library_filter_chips_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_library_item_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_library_search_bar_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/adhan_library/adhan_prayer_selector_bottom_sheet.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_page_header_widget.dart';

class AdhanSoundsLibraryPage extends StatefulWidget {
  final PrayerType? initialPrayerType;

  const AdhanSoundsLibraryPage({super.key, this.initialPrayerType});

  @override
  State<AdhanSoundsLibraryPage> createState() => _AdhanSoundsLibraryPageState();
}

class _AdhanSoundsLibraryPageState extends State<AdhanSoundsLibraryPage> {
  late final AzanAudioService _audioService;
  late final RadioAudioPlayerService _playerService;
  final TextEditingController _searchController = TextEditingController();

  List<AzanAudioItemModel> _allAzans = [];
  bool _isLoadingList = true;
  AdhanFilterType _filterType = AdhanFilterType.all;

  String? _currentAzanId;
  bool _isPlaying = false;
  bool _isAudioBuffering = false;

  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    _audioService = injector<AzanAudioService>();
    _playerService = injector<RadioAudioPlayerService>();
    _initAudioPlayer();
    _loadAzans();
  }

  void _initAudioPlayer() {
    _playerService.playerStateStream.listen((state) {
      if (!mounted) return;
      final isPlaying =
          state.playing && state.processingState != ProcessingState.completed;
      final isBuffering =
          state.processingState == ProcessingState.buffering ||
          state.processingState == ProcessingState.loading;

      setState(() {
        _isPlaying = isPlaying;
        _isAudioBuffering = isBuffering;
        if (state.processingState == ProcessingState.completed) {
          _currentAzanId = null;
        }
      });
    });
  }

  Future<void> _loadAzans() async {
    setState(() => _isLoadingList = true);
    final items = await _audioService.loadAllAzans();
    if (!mounted) return;
    setState(() {
      _allAzans = items;
      _isLoadingList = false;
    });
  }

  @override
  void dispose() {
    _playerService.stop();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(AzanAudioItemModel item) async {
    if (_currentAzanId == item.id) {
      if (_isPlaying) {
        await _playerService.pause();
      } else {
        await _playerService.play();
      }
      return;
    }

    try {
      setState(() {
        _currentAzanId = item.id;
        _isAudioBuffering = true;
      });

      if (item.isBuiltIn && item.localPath != null) {
        await _playerService.playAsset(
          assetPath: item.localPath!,
          title: item.title,
          artist: 'أذان',
          album: 'أصوات الأذان',
        );
      } else if (item.isDownloaded && item.localPath != null) {
        await _playerService.playFilePath(
          filePath: item.localPath!,
          surahName: item.title,
          reciterName: 'أذان',
          album: 'أصوات الأذان',
          isAlert: true,
        );
      } else {
        await _playerService.playUrl(
          url: item.url,
          surahName: item.title,
          reciterName: 'أذان',
        );
      }
    } catch (e) {
      debugPrint('Adhan play error: $e');
      if (!mounted) return;
      setState(() {
        _currentAzanId = null;
        _isPlaying = false;
        _isAudioBuffering = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.adhanPlayFailed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _startDownload(
    AzanAudioItemModel item, {
    VoidCallback? onDone,
  }) async {
    if (_downloadProgress.containsKey(item.id)) return;

    setState(() {
      _downloadProgress[item.id] = 0.0;
    });

    try {
      final savedPath = await _audioService.downloadAzan(
        item: item,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _downloadProgress[item.id] = progress;
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _downloadProgress.remove(item.id);
        final index = _allAzans.indexWhere((a) => a.id == item.id);
        if (index != -1) {
          _allAzans[index] = _allAzans[index].copyWith(
            isDownloaded: true,
            localPath: savedPath,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.adhanDownloadSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );

      onDone?.call();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _downloadProgress.remove(item.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.adhanDownloadFailed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _confirmDelete(AzanAudioItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AdhanDeleteConfirmDialog(
        title: item.title,
        onConfirm: () => Navigator.of(dialogCtx).pop(true),
      ),
    );

    if (confirmed == true) {
      if (_currentAzanId == item.id) {
        await _playerService.stop();
        setState(() {
          _currentAzanId = null;
          _isPlaying = false;
        });
      }

      await _audioService.deleteAzan(item.id);

      // If any prayer was using this deleted sound, reset to makkah
      for (final type in PrayerType.values) {
        if (UserHiveHelper.getPrayerAdhanSound(type.name) == item.id) {
          if (!mounted) return;
          context.read<HomelayoutBloc>().add(
            SelectPrayerAdhanSoundEvent(prayerType: type, soundId: 'makkah'),
          );
        }
      }

      if (!mounted) return;
      setState(() {
        final index = _allAzans.indexWhere((a) => a.id == item.id);
        if (index != -1) {
          _allAzans[index] = _allAzans[index].copyWith(isDownloaded: false);
        }
      });
    }
  }

  void _onSetAdhan(AzanAudioItemModel item, HomelayoutState state) {
    if (!item.isDownloaded && !item.isBuiltIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.strings.downloadFirstToSetAdhan),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _startDownload(
        item,
        onDone: () {
          if (mounted) {
            _showPrayerSelector(item, state);
          }
        },
      );
      return;
    }

    _showPrayerSelector(item, state);
  }

  void _showPrayerSelector(AzanAudioItemModel item, HomelayoutState state) {
    _playerService.stop();
    final prayerSounds = state.adhanSettings.prayerSoundIds.isNotEmpty
        ? state.adhanSettings.prayerSoundIds
        : UserHiveHelper.getAllPrayerAdhanSounds();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => AdhanPrayerSelectorBottomSheet(
        adhan: item,
        currentPrayerSounds: prayerSounds,
        onSelect: (selectedPrayer) {
          context.read<HomelayoutBloc>().add(
            SelectPrayerAdhanSoundEvent(
              prayerType: selectedPrayer,
              soundId: item.id,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.strings.adhanSetSuccessMessage),
              behavior: SnackBarBehavior.floating,
            ),
          );

          if (widget.initialPrayerType != null) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  List<String> _getAssignedPrayerNames(
    BuildContext context,
    String soundId,
    HomelayoutState state,
  ) {
    final Map<String, String> prayerSounds =
        state.adhanSettings.prayerSoundIds.isNotEmpty
        ? state.adhanSettings.prayerSoundIds
        : UserHiveHelper.getAllPrayerAdhanSounds();

    final List<String> names = [];
    for (final type in PrayerType.values) {
      if (prayerSounds[type.name] == soundId) {
        switch (type) {
          case PrayerType.fajr:
            names.add(context.strings.fajr);
            break;
          case PrayerType.dhuhr:
            names.add(context.strings.dhuhr);
            break;
          case PrayerType.asr:
            names.add(context.strings.asr);
            break;
          case PrayerType.maghrib:
            names.add(context.strings.maghrib);
            break;
          case PrayerType.isha:
            names.add(context.strings.isha);
            break;
        }
      }
    }
    return names;
  }

  List<AzanAudioItemModel> _filterList(List<AzanAudioItemModel> list) {
    final query = _searchController.text.trim().toLowerCase();

    return list.where((item) {
      if (_filterType == AdhanFilterType.builtIn && !item.isBuiltIn) {
        return false;
      }
      if (_filterType == AdhanFilterType.downloaded &&
          !item.isDownloaded &&
          !item.isBuiltIn) {
        return false;
      }
      if (query.isNotEmpty) {
        return item.title.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      builder: (context, state) {
        final filteredList = _filterList(_allAzans);
        final builtInCount = _allAzans.where((a) => a.isBuiltIn).length;
        final downloadedCount = _allAzans
            .where((a) => a.isDownloaded || a.isBuiltIn)
            .length;

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: Column(
            children: [
              SettingsPageHeaderWidget(
                title: context.strings.adhanLibraryTitle,
                subtitle: context.strings.adhanLibrarySubtitle,
              ),
              Expanded(
                child: _isLoadingList
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => _audioService
                            .loadAllAzans(forceRefresh: true)
                            .then((items) {
                              if (mounted) setState(() => _allAzans = items);
                            }),
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  16.h,
                                  20.w,
                                  8.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AdhanLibrarySearchBarWidget(
                                      controller: _searchController,
                                      onChanged: (_) => setState(() {}),
                                      onClear: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    ),
                                    12.ver,
                                    AdhanLibraryFilterChipsWidget(
                                      selectedFilter: _filterType,
                                      onSelectFilter: (type) =>
                                          setState(() => _filterType = type),
                                      allCount: _allAzans.length,
                                      builtInCount: builtInCount,
                                      downloadedCount: downloadedCount,
                                    ),
                                    8.ver,
                                  ],
                                ),
                              ),
                            ),
                            if (filteredList.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: AdhanLibraryEmptyWidget(
                                  message:
                                      _filterType == AdhanFilterType.downloaded
                                      ? context.strings.noDownloadedAdhans
                                      : context.strings.noAdhansFound,
                                ),
                              )
                            else
                              SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 8.h,
                                ),
                                sliver: SliverList.separated(
                                  itemCount: filteredList.length,
                                  separatorBuilder: (_, __) => 10.ver,
                                  itemBuilder: (context, index) {
                                    final item = filteredList[index];
                                    final isCurrentItem =
                                        _currentAzanId == item.id;
                                    final isPlaying =
                                        isCurrentItem && _isPlaying;
                                    final isLoading =
                                        isCurrentItem && _isAudioBuffering;
                                    final isDownloading = _downloadProgress
                                        .containsKey(item.id);
                                    final progress =
                                        _downloadProgress[item.id] ?? 0.0;
                                    final assignedPrayers =
                                        _getAssignedPrayerNames(
                                          context,
                                          item.id,
                                          state,
                                        );

                                    return AdhanLibraryItemCardWidget(
                                      item: item,
                                      isPlaying: isPlaying,
                                      isLoadingAudio: isLoading,
                                      isDownloading: isDownloading,
                                      downloadProgress: progress,
                                      assignedPrayerNames: assignedPrayers,
                                      onTogglePlay: () => _togglePlay(item),
                                      onDownload: () => _startDownload(item),
                                      onDelete: () => _confirmDelete(item),
                                      onSet: () => _onSetAdhan(item, state),
                                    );
                                  },
                                ),
                              ),
                            SliverToBoxAdapter(child: 24.ver),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
