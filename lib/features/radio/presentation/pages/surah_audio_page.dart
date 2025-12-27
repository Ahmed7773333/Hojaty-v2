import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../widgets/audio_controls_widget.dart';
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
  late AudioPlayer _audioPlayer;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _checkIfFileExistsAndInit();
  }

  Future<void> _checkIfFileExistsAndInit() async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = "${widget.reciterName}_${widget.surah.id}.mp3";
    final file = File("${dir.path}/$fileName");

    if (await file.exists()) {
      setState(() {
        _localFilePath = file.path;
      });
      await _audioPlayer.setFilePath(file.path);
    } else {
      // Stream form URL
      final url = "${widget.serverUrl}${widget.surah.id}.mp3";
      try {
        await _audioPlayer.setUrl(url);
      } catch (e) {
        debugPrint("Error loading URL: $e");
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
        final wasPlaying = _audioPlayer.playing;
        final position = _audioPlayer.position;
        await _audioPlayer.setFilePath(savePath);
        if (wasPlaying) _audioPlayer.play();
        _audioPlayer.seek(position);

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
                _audioPlayer.setSpeed(speed);
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
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.localeName == 'ar'
              ? widget.surah.nameAr
              : widget.surah.nameEn,
        ),
        centerTitle: true,
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
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;
                  final buffered = _audioPlayer.bufferedPosition;

                  return ProgressBar(
                    progress: position,
                    buffered: buffered,
                    total: duration,
                    onSeek: (duration) {
                      _audioPlayer.seek(duration);
                    },
                    baseBarColor: Colors.grey[300],
                    progressBarColor: Theme.of(context).primaryColor,
                    bufferedBarColor: Colors.grey[400],
                    thumbColor: Theme.of(context).primaryColor,
                    barHeight: 6.0,
                    thumbRadius: 8.0,
                    timeLabelPadding: 8.0,
                    timeLabelTextStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 3. Audio Controls
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;

                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return const CircularProgressIndicator();
                  }

                  return AudioControlsWidget(
                    audioPlayer: _audioPlayer,
                    isPlaying: playing ?? false,
                    onPlayPause: () {
                      if (playing == true) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                    onSeekForward: () {
                      _audioPlayer.seek(
                        _audioPlayer.position + const Duration(seconds: 10),
                      );
                    },
                    onSeekBackward: () {
                      _audioPlayer.seek(
                        _audioPlayer.position - const Duration(seconds: 10),
                      );
                    },
                    onChangeSpeed: _showSpeedDialog,
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
            ],
          ),
        ),
      ),
    );
  }
}
