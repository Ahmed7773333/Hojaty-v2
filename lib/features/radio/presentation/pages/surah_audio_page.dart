import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/services/audio_player_handler.dart';
import '../../data/models/playlist_item.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../widgets/add_to_playlist_dialog.dart';
import '../widgets/audio_controls_widget.dart';
import '../widgets/audio_progress_bar_widget.dart';
import '../widgets/download_status_widget.dart';
import '../widgets/reciter_info_widget.dart';

class SurahAudioPage extends StatefulWidget {
  final Surah surah;
  final String serverUrl;
  final String reciterName;

  const SurahAudioPage({
    super.key,
    required this.surah,
    required this.serverUrl,
    required this.reciterName,
  });

  @override
  State<SurahAudioPage> createState() => _SurahAudioPageState();
}

class _SurahAudioPageState extends State<SurahAudioPage> {
  AudioHandler? _audioHandler;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAudioHandler();
  }

  @override
  void dispose() {
    // Stop audio when leaving the page
    _audioHandler?.stop();
    super.dispose();
  }

  Future<void> _initAudioHandler() async {
    _audioHandler = await injector.getAsync<AudioHandler>();
    if (mounted) {
      setState(() => _isLoading = false);
      _checkIfFileExistsAndInit();
    }
  }

  Future<void> _checkIfFileExistsAndInit() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = "${widget.reciterName}_${widget.surah.id}.mp3";
    final file = File("${dir.path}/$fileName");

    // Update MediaItem first
    final mediaItem = MediaItem(
      id: widget.surah.id,
      album: widget.reciterName,
      title: context.strings.localeName == 'ar'
          ? widget.surah.nameAr
          : widget.surah.nameEn,
      artist: widget.reciterName,
      extras: {'surahId': widget.surah.id},
    );
    (_audioHandler! as AudioPlayerHandler).setMediaItem(mediaItem);

    if (await file.exists()) {
      setState(() => _localFilePath = file.path);
      try {
        await _audioHandler!.playFromUri(Uri.file(file.path));
      } catch (e) {
        _showError("Error playing local file: $e");
      }
    } else {
      final url = "${widget.serverUrl}${widget.surah.id}.mp3";
      debugPrint(url);
      try {
        await _audioHandler!.playFromUri(Uri.parse(url));
      } catch (e) {
        _showError("Error streaming audio: $e. Check internet.");
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _downloadSurah() async {
    setState(() => _isDownloading = true);

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = "${widget.reciterName}_${widget.surah.id}.mp3";
      final savePath = "${dir.path}/$fileName";
      final url = "${widget.serverUrl}${widget.surah.id}.mp3";

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      if (mounted) {
        setState(() {
          _localFilePath = savePath;
          _isDownloading = false;
        });

        // Switch to local file for playback
        final wasPlaying = _audioHandler!.playbackState.value.playing;
        await _audioHandler!.playFromUri(Uri.file(savePath));
        if (wasPlaying) _audioHandler!.play();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.download_success)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        _showError("${context.strings.download_failed}: $e");
      }
    }
  }

  Future<void> _shareAudio() async {
    final surahName = context.strings.localeName == 'ar'
        ? widget.surah.nameAr
        : widget.surah.nameEn;

    if (_localFilePath != null) {
      // Share the actual audio file
      final file = XFile(_localFilePath!);
      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: '$surahName - ${widget.reciterName}',
          subject: surahName,
        ),
      );
    } else {
      // File not downloaded - ask user if they want to download first or share URL
      final shouldDownload = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.strings.share),
          content: Text(context.strings.share_file_not_downloaded),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.strings.share_link),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.strings.download),
            ),
          ],
        ),
      );

      if (shouldDownload == true) {
        await _downloadSurah();
        // After download, share the file
        if (_localFilePath != null) {
          final file = XFile(_localFilePath!);
          await SharePlus.instance.share(
            ShareParams(
              files: [file],
              text: '$surahName - ${widget.reciterName}',
              subject: surahName,
            ),
          );
        }
      } else if (shouldDownload == false) {
        // Share URL
        final url = "${widget.serverUrl}${widget.surah.id}.mp3";
        await SharePlus.instance.share(
          ShareParams(
            text: '$surahName - ${widget.reciterName}\n$url',
            subject: surahName,
          ),
        );
      }
    }
  }

  PlaylistItem get _playlistItem => PlaylistItem(
    surahId: int.tryParse(widget.surah.id) ?? 0,
    surahNameAr: widget.surah.nameAr,
    surahNameEn: widget.surah.nameEn,
    reciterName: widget.reciterName,
    reciterLetter: widget.reciterName.isNotEmpty ? widget.reciterName[0] : '?',
    serverUrl: widget.serverUrl,
  );

  @override
  Widget build(BuildContext context) {
    final surahTitle = context.strings.localeName == 'ar'
        ? widget.surah.nameAr
        : widget.surah.nameEn;

    // Show loading state while audio handler is being initialized
    if (_isLoading || _audioHandler == null) {
      return Scaffold(
        appBar: AppBar(title: Text(surahTitle), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (context) => injector<RadioBloc>()..add(LoadPlaylistsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(surahTitle),
          centerTitle: true,
          actions: [
            // Share Button
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareAudio,
              tooltip: context.strings.share,
            ),
            // Favorite Button
            BlocBuilder<RadioBloc, RadioState>(
              builder: (context, state) {
                final isFav = state.isFavorite(
                  widget.surah.idUi,
                  widget.reciterName,
                );
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<RadioBloc>().add(
                      ToggleFavoriteEvent(_playlistItem),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. Reciter Info
                ReciterInfoWidget(
                  reciterName: widget.reciterName,
                  surahNameEn: widget.surah.nameEn,
                  surahNameAr: widget.surah.nameAr,
                ),

                const SizedBox(height: 20),

                // 2. Progress Bar
                AudioProgressBarWidget(audioHandler: _audioHandler!),

                const SizedBox(height: 20),

                // 3. Audio Controls
                AudioControlsWidget(audioHandler: _audioHandler!),

                const SizedBox(height: 30),

                // 4. Download Status / Button
                DownloadStatusWidget(
                  isDownloading: _isDownloading,
                  downloadProgress: _downloadProgress,
                  isDownloaded: _localFilePath != null,
                  onDownload: _downloadSurah,
                ),

                const SizedBox(height: 20),

                // 5. Add to Playlist Button
                BlocBuilder<RadioBloc, RadioState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        showAddToPlaylistDialog(
                          context: context,
                          playlists: state.playlists,
                          item: _playlistItem,
                          radioBloc: context.read<RadioBloc>(),
                        );
                      },
                      icon: const Icon(Icons.playlist_add),
                      label: Text(context.strings.add_to_playlist),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
