import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hojaty/core/services/audio_player_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../widgets/download_status_widget.dart';
import '../widgets/reciter_info_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/playlist_item.dart';
import '../../data/models/playlist_model.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';

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
  late AudioHandler _audioHandler;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _audioHandler = injector<AudioHandler>();
    _checkIfFileExistsAndInit();
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
      artUri: Uri.parse(
        "https://i.imgur.com/s6E6R2u.png",
      ), // Placeholder or app icon
      extras: {'surahId': widget.surah.id},
    );
    _audioHandler.addQueueItem(mediaItem);

    if (await file.exists()) {
      setState(() {
        _localFilePath = file.path;
      });
      if (_audioHandler is AudioPlayerHandler) {
        await (_audioHandler as AudioPlayerHandler).setFilePath(file.path);
        _audioHandler.play();
      }
    } else {
      // Stream form URL
      final url = "${widget.serverUrl}${widget.surah.id}.mp3";
      if (_audioHandler is AudioPlayerHandler) {
        await (_audioHandler as AudioPlayerHandler).setUrl(url);
        _audioHandler.play();
      }
    }
  }

  Future<void> _downloadSurah() async {
    setState(() {
      _isDownloading = true;
    });

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
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _localFilePath = savePath;
          _isDownloading = false;
        });

        // Switch to the local file for playback
        if (_audioHandler is AudioPlayerHandler) {
          final wasPlaying = _audioHandler.playbackState.value.playing;
          await (_audioHandler as AudioPlayerHandler).setFilePath(savePath);
          if (wasPlaying) _audioHandler.play();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.download_success)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${context.strings.download_failed}: $e")),
        );
      }
    }
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(context.strings.playback_speed),
          children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
            return SimpleDialogOption(
              onPressed: () {
                _audioHandler.setSpeed(speed);
                Navigator.pop(context);
              },
              child: Text("${speed}x"),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RadioBloc>()..add(LoadPlaylistsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.strings.localeName == 'ar'
                ? widget.surah.nameAr
                : widget.surah.nameEn,
          ),
          centerTitle: true,
          actions: [
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
                // 1. Info & Image
                ReciterInfoWidget(
                  reciterName: widget.reciterName,
                  surahNameEn: widget.surah.nameEn,
                  surahNameAr: widget.surah.nameAr,
                ),

                const SizedBox(height: 20),

                // 2. Progress Bar
                StreamBuilder<Duration>(
                  stream: AudioService.position,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<MediaItem?>(
                      stream: _audioHandler.mediaItem,
                      builder: (context, mediaSnapshot) {
                        final duration =
                            mediaSnapshot.data?.duration ?? Duration.zero;
                        return ProgressBar(
                          progress: position,
                          total: duration,
                          onSeek: (duration) {
                            _audioHandler.seek(duration);
                          },
                          baseBarColor: Colors.grey[300],
                          progressBarColor: Theme.of(context).primaryColor,
                          bufferedBarColor: Colors.grey[400],
                          thumbColor: Theme.of(context).primaryColor,
                          barHeight: 6.0,
                          thumbRadius: 8.0,
                          timeLabelPadding: 8.0,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 3. Audio Controls
                StreamBuilder<PlaybackState>(
                  stream: _audioHandler.playbackState,
                  builder: (context, snapshot) {
                    final playbackState = snapshot.data;
                    final processingState = playbackState?.processingState;
                    final playing = playbackState?.playing;

                    if (processingState == AudioProcessingState.loading ||
                        processingState == AudioProcessingState.buffering) {
                      return const CircularProgressIndicator();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.speed),
                          onPressed: _showSpeedDialog,
                        ),
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: () {
                            if (_audioHandler is AudioPlayerHandler) {
                              final pos = (_audioHandler as AudioPlayerHandler)
                                  .position;
                              _audioHandler.seek(
                                pos - const Duration(seconds: 10),
                              );
                            }
                          },
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: Icon(
                              playing == true ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              if (playing == true) {
                                _audioHandler.pause();
                              } else {
                                _audioHandler.play();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () {
                            if (_audioHandler is AudioPlayerHandler) {
                              final pos = (_audioHandler as AudioPlayerHandler)
                                  .position;
                              _audioHandler.seek(
                                pos + const Duration(seconds: 10),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),

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
                        _showAddToPlaylistDialog(context, state.playlists);
                      },
                      icon: const Icon(Icons.playlist_add),
                      label: const Text("Add to Playlist"),
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

  PlaylistItem get _playlistItem => PlaylistItem(
    surahId: int.tryParse(widget.surah.id) ?? 0,
    surahNameAr: widget.surah.nameAr,
    surahNameEn: widget.surah.nameEn,
    reciterName: widget.reciterName,
    reciterLetter: widget.reciterName.isNotEmpty ? widget.reciterName[0] : '?',
    serverUrl: widget.serverUrl,
  );

  void _showAddToPlaylistDialog(
    BuildContext context,
    List<PlaylistModel> playlists,
  ) {
    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No playlists available. Create one first!"),
        ),
      );
      return;
    }

    // Capture the bloc to use inside the dialog
    final radioBloc = context.read<RadioBloc>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add to Playlist"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              if (playlist.isSystem == true &&
                  playlist.id != 'favorites_playlist') {
                return const SizedBox.shrink();
              }
              if (playlist.id == 'favorites_playlist') {
                return const SizedBox.shrink();
              }

              return ListTile(
                title: Text(playlist.name),
                leading: const Icon(Icons.queue_music),
                onTap: () {
                  radioBloc.add(
                    AddToPlaylistEvent(
                      playlistId: playlist.id,
                      item: _playlistItem,
                    ),
                  );
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added to ${playlist.name}")),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
