import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

/// Audio player wrapper for Hifz memorization.
///
/// Uses a single `just_audio` [AudioPlayer] with `just_audio_background` [MediaItem]
/// tags (sharing the global `JustAudioBackground.init` initialized in `main.dart`),
/// `AudioSessionConfiguration.speech()`, interruption / noisy-stream handling, and
/// `ClippingAudioSource` over `silence_30s.mp3` to keep iOS/Android background audio
/// sessions alive during Pause-to-Repeat.
class HifzAudioHandler {
  static const String _silenceAssetPath = 'assets/audio/silence_30s.mp3';

  final AudioPlayer _player = AudioPlayer();
  final RadioAudioPlayerService radioPlayerService;

  String? _silenceFilePath;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSub;
  StreamSubscription<void>? _becomingNoisySub;
  bool _audioSessionConfigured = false;
  bool _wasPlayingBeforeInterruption = false;

  VoidCallback? onPauseRequested;
  VoidCallback? onResumeRequested;

  HifzAudioHandler({
    required this.radioPlayerService,
  });

  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;
  bool get isPlaying => _player.playing;
  Duration? get currentDuration => _player.duration;

  Future<void> ensureInitialized() async {
    if (!_audioSessionConfigured) {
      _audioSessionConfigured = true;
      try {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.speech());
        _interruptionSub = session.interruptionEventStream.listen((event) {
          if (event.begin) {
            _wasPlayingBeforeInterruption = _player.playing;
            if (_wasPlayingBeforeInterruption) {
              onPauseRequested?.call();
            }
          } else {
            if (_wasPlayingBeforeInterruption &&
                (event.type == AudioInterruptionType.pause ||
                    event.type == AudioInterruptionType.duck)) {
              onResumeRequested?.call();
            }
            _wasPlayingBeforeInterruption = false;
          }
        });
        _becomingNoisySub = session.becomingNoisyEventStream.listen((_) {
          if (_player.playing) {
            onPauseRequested?.call();
          }
        });
      } catch (e) {
        debugPrint('HifzAudioHandler AudioSession init error: $e');
      }
    }

    await _ensureSilenceFileExtracted();
  }

  Future<String> _ensureSilenceFileExtracted() async {
    if (_silenceFilePath != null && File(_silenceFilePath!).existsSync()) {
      return _silenceFilePath!;
    }
    final supportDir = await getApplicationSupportDirectory();
    final dir = Directory('${supportDir.path}/hifz_audio');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final silenceFile = File('${dir.path}/silence_30s.mp3');
    final data = await rootBundle.load(_silenceAssetPath);
    if (!silenceFile.existsSync() ||
        silenceFile.lengthSync() != data.lengthInBytes) {
      await silenceFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }
    _silenceFilePath = silenceFile.path;
    return _silenceFilePath!;
  }

  /// Plays a local ayah MP3 file (or a clipped hint snippet if [clipEnd] is provided).
  Future<void> playLocalAyah({
    required String filePath,
    required MediaItem mediaItem,
    required double speed,
    Duration? clipEnd,
  }) async {
    await ensureInitialized();
    if (radioPlayerService.isPlaying) {
      await radioPlayerService.pause();
    }

    final AudioSource source;
    if (clipEnd != null) {
      source = ClippingAudioSource(
        start: Duration.zero,
        end: clipEnd,
        child: AudioSource.file(filePath),
        tag: mediaItem,
      );
    } else {
      source = AudioSource.file(filePath, tag: mediaItem);
    }

    await _player.setAudioSource(source);
    await _player.setSpeed(speed);
    await _player.play();
  }

  /// Plays a clipped silent MP3 segment to keep iOS/Android background audio active
  /// during Pause-to-Repeat (سكتة الترديد).
  Future<void> playSilencePause({
    required Duration duration,
    required MediaItem mediaItem,
  }) async {
    await ensureInitialized();
    final silencePath = await _ensureSilenceFileExtracted();
    final clampedMs = duration.inMilliseconds.clamp(1000, 30000);
    final source = ClippingAudioSource(
      start: Duration.zero,
      end: Duration(milliseconds: clampedMs),
      child: AudioSource.file(silencePath),
      tag: mediaItem,
    );
    await _player.setAudioSource(source);
    await _player.setSpeed(1.0);
    await _player.play();
  }

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.play();

  Future<void> stop() => _player.stop();

  Future<void> dispose() async {
    await _interruptionSub?.cancel();
    await _becomingNoisySub?.cancel();
    await _player.dispose();
  }
}

