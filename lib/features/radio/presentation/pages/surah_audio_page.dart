import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../data/models/surah_audio_args.dart';
import '../../services/radio_audio_player_service.dart';
import '../../services/radio_download_service.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../widgets/audio_player/radio_add_to_playlist_dialog.dart';
import '../widgets/audio_player/radio_audio_controls_widget.dart';
import '../widgets/audio_player/radio_progress_bar_widget.dart';
import '../widgets/audio_player/share_download_confirmation_dialog.dart';
import '../widgets/audio_player/surah_audio_header_widget.dart';
import '../widgets/audio_player/surah_audio_info_widget.dart';
import '../widgets/audio_player/surah_download_button_widget.dart';

class SurahAudioPage extends StatefulWidget {
  final SurahAudioArgs args;

  const SurahAudioPage({
    super.key,
    required this.args,
  });

  @override
  State<SurahAudioPage> createState() => _SurahAudioPageState();
}

class _SurahAudioPageState extends State<SurahAudioPage> {
  final GlobalKey<SurahDownloadButtonWidgetState> _downloadButtonKey =
      GlobalKey<SurahDownloadButtonWidgetState>();
  late final RadioAudioPlayerService _playerService;
  late final RadioDownloadService _downloadService;
  late final RadioBloc _radioBloc;

  late SurahAudioArgs _activeArgs;
  StreamSubscription<SurahAudioArgs?>? _argsSubscription;

  @override
  void initState() {
    super.initState();
    _activeArgs = widget.args;
    _playerService = injector<RadioAudioPlayerService>();
    _downloadService = injector<RadioDownloadService>();
    _radioBloc = injector<RadioBloc>();

    _argsSubscription = _playerService.currentArgsStream.listen((newArgs) {
      if (newArgs != null && mounted) {
        setState(() {
          _activeArgs = newArgs;
        });
        _downloadButtonKey.currentState?.refreshStatus();
      }
    });

    _initAudio();
  }

  Future<void> _initAudio() async {
    _radioBloc.add(const LoadPlaylistsEvent());

    // If already playing this exact surah and reciter, do not restart
    if (_playerService.isCurrentTrack(
          surahId: _activeArgs.surahNumber,
          reciterName: _activeArgs.reciterName,
        ) &&
        (_playerService.isPlaying ||
            _playerService.currentPosition > Duration.zero)) {
      return;
    }

    try {
      final localPath = await _downloadService.getExistingLocalPath(
        _activeArgs.reciterName,
        _activeArgs.surahNumber,
      );

      await _playerService.playSurahSequence(
        args: _activeArgs,
        localFilePath: localPath,
      );
    } catch (e) {
      debugPrint('SurahAudioPage _initAudio error: $e');
    }
  }

  Future<void> _onDownloadSuccess(String localPath) async {
    final wasPlaying = _playerService.isPlaying;
    final position = _playerService.currentPosition;
    await _playerService.playSurahSequence(
      args: _activeArgs,
      localFilePath: localPath,
    );
    await _playerService.seek(position);
    if (!wasPlaying) {
      await _playerService.pause();
    }

    _radioBloc.add(
      AddToPlaylistEvent(
        playlistId: 'downloads_playlist',
        item: _activeArgs.toPlaylistItem(),
      ),
    );
  }

  Future<void> _onDownloadDeleted() async {
    final wasPlaying = _playerService.isPlaying;
    final position = _playerService.currentPosition;
    await _playerService.playSurahSequence(
      args: _activeArgs,
      localFilePath: null,
    );
    await _playerService.seek(position);
    if (!wasPlaying) {
      await _playerService.pause();
    }

    _radioBloc.add(
      RemoveFromPlaylistEvent(
        playlistId: 'downloads_playlist',
        surahId: _activeArgs.surahNumber,
        reciterName: _activeArgs.reciterName,
      ),
    );
  }

  @override
  void dispose() {
    _argsSubscription?.cancel();
    // ponytail: audio continues playing in background so user can control via notification and lockscreen
    super.dispose();
  }

  void _onToggleFavorite() {
    _radioBloc.add(ToggleFavoriteEvent(_activeArgs.toPlaylistItem()));
  }

  void _onOpenAddToPlaylist(RadioState state) {
    context.showDialogRoute(
      builder: RadioAddToPlaylistDialog(
        playlists: state.playlists,
        item: _activeArgs.toPlaylistItem(),
        radioBloc: _radioBloc,
      ),
    );
  }

  Future<void> _shareAudioFile(String localPath) async {
    final box = context.findRenderObject() as RenderBox?;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final surahName = isAr ? _activeArgs.surahNameAr : _activeArgs.surahNameEn;
    final shareText = '$surahName - ${_activeArgs.reciterName}';

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(localPath)],
        text: shareText,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  void _startDownloadAndShare() {
    _downloadButtonKey.currentState?.startDownload(
      onComplete: (savedPath) {
        if (mounted) {
          _shareAudioFile(savedPath);
        }
      },
    );
  }

  Future<void> _onShareAudio() async {
    final localPath = await _downloadService.getExistingLocalPath(
      _activeArgs.reciterName,
      _activeArgs.surahNumber,
    );

    if (!mounted) return;

    if (localPath != null) {
      await _shareAudioFile(localPath);
    } else if (_downloadButtonKey.currentState?.isDownloading == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.downloadingInProgress)),
      );
    } else {
      context.showDialogRoute(
        builder: ShareDownloadConfirmationDialog(
          onConfirmDownload: _startDownloadAndShare,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final pageTitle = isAr ? _activeArgs.surahNameAr : _activeArgs.surahNameEn;

    return BlocProvider.value(
      value: _radioBloc,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Column(
          children: [
            BlocBuilder<RadioBloc, RadioState>(
              builder: (context, state) {
                final isFav = state.isFavorite(
                  _activeArgs.surahNumber,
                  _activeArgs.reciterName,
                );
                return SurahAudioHeaderWidget(
                  title: pageTitle,
                  isFavorite: isFav,
                  onBack: () => context.pop(),
                  onToggleFavorite: _onToggleFavorite,
                  onShare: _onShareAudio,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  children: [
                    SurahAudioInfoWidget(
                      surahNameAr: _activeArgs.surahNameAr,
                      surahNameEn: _activeArgs.surahNameEn,
                      reciterName: _activeArgs.reciterName,
                      surahNumber: _activeArgs.surahNumber,
                    ),
                    24.ver,
                    RadioProgressBarWidget(playerService: _playerService),
                    24.ver,
                    RadioAudioControlsWidget(playerService: _playerService),
                    24.ver,
                    SurahDownloadButtonWidget(
                      key: _downloadButtonKey,
                      audioUrl: _activeArgs.audioUrl,
                      reciterName: _activeArgs.reciterName,
                      surahNumber: _activeArgs.surahNumber,
                      onDownloadSuccess: _onDownloadSuccess,
                      onDownloadDeleted: _onDownloadDeleted,
                    ),
                    24.ver,
                    BlocBuilder<RadioBloc, RadioState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          text: context.strings.addToPlaylist,
                          onPressed: () => _onOpenAddToPlaylist(state),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
