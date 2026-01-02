import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'playback_speed_dialog.dart';

/// A reusable audio controls widget that works with AudioHandler
class AudioControlsWidget extends StatelessWidget {
  final AudioHandler audioHandler;

  const AudioControlsWidget({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final processingState = playbackState?.processingState;
        final playing = playbackState?.playing ?? false;

        // Show loading indicator while buffering
        if (processingState == AudioProcessingState.loading ||
            processingState == AudioProcessingState.buffering) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Speed Control
            IconButton(
              onPressed: () {
                showPlaybackSpeedDialog(
                  context: context,
                  onSpeedSelected: (speed) {
                    audioHandler.setSpeed(speed);
                  },
                );
              },
              icon: const Icon(Icons.speed),
              tooltip: "Speed",
            ),
            const SizedBox(width: 8),

            // Rewind 10s
            IconButton(
              onPressed: () => audioHandler.rewind(),
              icon: const Icon(Icons.replay_10_rounded),
              iconSize: 32,
            ),

            const SizedBox(width: 8),

            // Play/Pause Main Button
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 48,
                color: Colors.white,
                icon: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                onPressed: () {
                  if (playing) {
                    audioHandler.pause();
                  } else {
                    audioHandler.play();
                  }
                },
              ),
            ),

            const SizedBox(width: 8),

            // Forward 10s
            IconButton(
              onPressed: () => audioHandler.fastForward(),
              icon: const Icon(Icons.forward_10_rounded),
              iconSize: 32,
            ),
          ],
        );
      },
    );
  }
}
