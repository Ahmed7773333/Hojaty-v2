import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioControlsWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekForward;
  final VoidCallback onSeekBackward;
  final VoidCallback onChangeSpeed;

  const AudioControlsWidget({
    super.key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeekForward,
    required this.onSeekBackward,
    required this.onChangeSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Speed Control
        IconButton(
          onPressed: onChangeSpeed,
          icon: const Icon(Icons.speed),
          tooltip: "Speed",
        ),
        const SizedBox(width: 16),

        // Rewind 10s
        IconButton(
          onPressed: onSeekBackward,
          icon: const Icon(Icons.replay_10_rounded),
          iconSize: 32,
        ),

        const SizedBox(width: 16),

        // Play/Pause Main Button
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            iconSize: 48,
            color: Colors.white,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            onPressed: onPlayPause,
          ),
        ),

        const SizedBox(width: 16),

        // Forward 10s
        IconButton(
          onPressed: onSeekForward,
          icon: const Icon(Icons.forward_10_rounded),
          iconSize: 32,
        ),

        const SizedBox(width: 16),

        // Extra placeholder for alignment or future features (like loop)
        IconButton(
          onPressed: () {
            // Loop toggle logic could go here
            final mode = audioPlayer.loopMode == LoopMode.one
                ? LoopMode.off
                : LoopMode.one;
            audioPlayer.setLoopMode(mode);
          },
          icon: StreamBuilder<LoopMode>(
            stream: audioPlayer.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
              return Icon(
                loopMode == LoopMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                color: loopMode == LoopMode.off
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              );
            },
          ),
        ),
      ],
    );
  }
}
