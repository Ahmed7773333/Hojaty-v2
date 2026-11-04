import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioPlayerService {
  static final RadioAudioPlayerService _instance = RadioAudioPlayerService._internal();
  factory RadioAudioPlayerService() => _instance;

  final AudioPlayer _player = AudioPlayer();

  int? _currentSurahId;
  String? _currentSurahName;
  String? _currentReciterName;
  String? _currentAudioUrl;
  String? _currentFilePath;

  RadioAudioPlayerService._internal() {
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<double> get speedStream => _player.speedStream;

  // Getters
  bool get isPlaying => _player.playing;
  Duration get currentPosition => _player.position;
  Duration? get totalDuration => _player.duration;
  double get currentSpeed => _player.speed;
  int? get currentSurahId => _currentSurahId;
  String? get currentSurahName => _currentSurahName;
  String? get currentReciterName => _currentReciterName;
  String? get currentAudioUrl => _currentAudioUrl;
  String? get currentFilePath => _currentFilePath;
  bool get isPlayingLocal => _currentFilePath != null;

  Future<void> playUrl({
    required String url,
    int? surahId,
    String? surahName,
    String? reciterName,
  }) async {
    try {
      _currentSurahId = surahId;
      _currentSurahName = surahName;
      _currentReciterName = reciterName;
      _currentAudioUrl = url;
      _currentFilePath = null;

      debugPrint('RadioAudioPlayerService: Loading $url');
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      debugPrint('RadioAudioPlayerService error: $e');
      rethrow;
    }
  }

  Future<void> playFilePath({
    required String filePath,
    int? surahId,
    String? surahName,
    String? reciterName,
  }) async {
    try {
      _currentSurahId = surahId;
      _currentSurahName = surahName;
      _currentReciterName = reciterName;
      _currentAudioUrl = null;
      _currentFilePath = filePath;

      debugPrint('RadioAudioPlayerService: Loading local file $filePath');
      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e) {
      debugPrint('RadioAudioPlayerService playFilePath error: $e');
      rethrow;
    }
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> seekForward([int seconds = 10]) async {
    final target = _player.position + Duration(seconds: seconds);
    final max = _player.duration ?? target;
    await _player.seek(target > max ? max : target);
  }

  Future<void> seekBackward([int seconds = 10]) async {
    final target = _player.position - Duration(seconds: seconds);
    await _player.seek(target < Duration.zero ? Duration.zero : target);
  }

  void dispose() {
    _player.dispose();
  }
}

