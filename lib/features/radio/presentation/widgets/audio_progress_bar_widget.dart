import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

/// A reusable audio progress bar widget that works with AudioHandler
class AudioProgressBarWidget extends StatelessWidget {
  final AudioHandler audioHandler;

  const AudioProgressBarWidget({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        return StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, mediaSnapshot) {
            final duration = mediaSnapshot.data?.duration ?? Duration.zero;
            return ProgressBar(
              progress: position,
              total: duration,
              onSeek: (duration) {
                audioHandler.seek(duration);
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
    );
  }
}
