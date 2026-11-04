import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final RadioAudioPlayerService _playerService;
  late final RadioDownloadService _downloadService;
  late final RadioBloc _radioBloc;

  @override
  void initState() {
    super.initState();
    _playerService = injector<RadioAudioPlayerService>();
    _downloadService = injector<RadioDownloadService>();
    _radioBloc = injector<RadioBloc>();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _radioBloc.add(const LoadPlaylistsEvent());

    final localPath = await _downloadService.getExistingLocalPath(
      widget.args.reciterName,
      widget.args.surahNumber,
    );

    if (localPath != null) {
      await _playerService.playFilePath(
        filePath: localPath,
        surahId: widget.args.surahNumber,
        surahName: widget.args.surahNameAr,
        reciterName: widget.args.reciterName,
      );
    } else {
      await _playerService.playUrl(
        url: widget.args.audioUrl,
        surahId: widget.args.surahNumber,
        surahName: widget.args.surahNameAr,
        reciterName: widget.args.reciterName,
      );
    }
  }

  Future<void> _onDownloadSuccess(String localPath) async {
    final wasPlaying = _playerService.isPlaying;
    final position = _playerService.currentPosition;
    await _playerService.playFilePath(
      filePath: localPath,
      surahId: widget.args.surahNumber,
      surahName: widget.args.surahNameAr,
      reciterName: widget.args.reciterName,
    );
    await _playerService.seek(position);
    if (!wasPlaying) {
      await _playerService.pause();
    }

    _radioBloc.add(
      AddToPlaylistEvent(
        playlistId: 'downloads_playlist',
        item: widget.args.toPlaylistItem(),
      ),
    );
  }

  Future<void> _onDownloadDeleted() async {
    final wasPlaying = _playerService.isPlaying;
    final position = _playerService.currentPosition;
    await _playerService.playUrl(
      url: widget.args.audioUrl,
      surahId: widget.args.surahNumber,
      surahName: widget.args.surahNameAr,
      reciterName: widget.args.reciterName,
    );
    await _playerService.seek(position);
    if (!wasPlaying) {
      await _playerService.pause();
    }

    _radioBloc.add(
      RemoveFromPlaylistEvent(
        playlistId: 'downloads_playlist',
        surahId: widget.args.surahNumber,
        reciterName: widget.args.reciterName,
      ),
    );
  }

  @override
  void dispose() {
    _playerService.stop();
    super.dispose();
  }

  void _onToggleFavorite() {
    _radioBloc.add(ToggleFavoriteEvent(widget.args.toPlaylistItem()));
  }

  void _onOpenAddToPlaylist(RadioState state) {
    context.showDialogRoute(
      builder: RadioAddToPlaylistDialog(
        playlists: state.playlists,
        item: widget.args.toPlaylistItem(),
        radioBloc: _radioBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final pageTitle = isAr ? widget.args.surahNameAr : widget.args.surahNameEn;

    return BlocProvider.value(
      value: _radioBloc,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Column(
          children: [
            BlocBuilder<RadioBloc, RadioState>(
              builder: (context, state) {
                final isFav = state.isFavorite(
                  widget.args.surahNumber,
                  widget.args.reciterName,
                );
                return SurahAudioHeaderWidget(
                  title: pageTitle,
                  isFavorite: isFav,
                  onBack: () => context.pop(),
                  onToggleFavorite: _onToggleFavorite,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  children: [
                    SurahAudioInfoWidget(
                      surahNameAr: widget.args.surahNameAr,
                      surahNameEn: widget.args.surahNameEn,
                      reciterName: widget.args.reciterName,
                      surahNumber: widget.args.surahNumber,
                    ),
                    24.ver,
                    RadioProgressBarWidget(playerService: _playerService),
                    24.ver,
                    RadioAudioControlsWidget(playerService: _playerService),
                    24.ver,
                    SurahDownloadButtonWidget(
                      audioUrl: widget.args.audioUrl,
                      reciterName: widget.args.reciterName,
                      surahNumber: widget.args.surahNumber,
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

