import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../features/quran/constants/quran_constants.dart';
import '../data/models/surah_audio_args.dart';

class RadioAudioPlayerService {
  static final RadioAudioPlayerService _instance =
      RadioAudioPlayerService._internal();
  factory RadioAudioPlayerService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final StreamController<SurahAudioArgs?> _currentArgsController =
      StreamController<SurahAudioArgs?>.broadcast();

  int? _currentSurahId;
  String? _currentSurahName;
  String? _currentReciterName;
  String? _currentAudioUrl;
  String? _currentFilePath;
  SurahAudioArgs? _currentArgs;

  RadioAudioPlayerService._internal() {
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });

    _player.currentIndexStream.listen((index) {
      if (index != null && _currentArgs != null) {
        final surahNumber = index + 1;
        final surah = QuranConstants.surahMap[surahNumber];
        if (surah != null && surah.number != _currentSurahId) {
          _currentSurahId = surah.number;
          _currentSurahName = surah.name;
          _currentFilePath = null;
          _currentArgs = SurahAudioArgs(
            surahNumber: surah.number,
            surahNameAr: surah.name,
            surahNameEn: surah.englishName,
            reciterName: _currentArgs!.reciterName,
            reciterLetter: _currentArgs!.reciterLetter,
            serverUrl: _currentArgs!.serverUrl,
            reciterId: _currentArgs!.reciterId,
          );
          _currentAudioUrl = _currentArgs!.audioUrl;
          _currentArgsController.add(_currentArgs);
        }
      }
    });
  }

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<double> get speedStream => _player.speedStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Stream<SurahAudioArgs?> get currentArgsStream => _currentArgsController.stream;

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
  SurahAudioArgs? get currentArgs => _currentArgs;
  bool get isPlayingLocal => _currentFilePath != null;
  bool get hasActiveTrack =>
      _currentSurahId != null ||
      _currentAudioUrl != null ||
      _currentFilePath != null;
  bool get hasNext => _player.hasNext;
  bool get hasPrevious => _player.hasPrevious;

  bool isCurrentTrack({required int surahId, required String reciterName}) {
    return _currentSurahId == surahId && _currentReciterName == reciterName;
  }

  Future<void> playSurahSequence({
    required SurahAudioArgs args,
    String? localFilePath,
  }) async {
    try {
      _currentArgs = args;
      _currentSurahId = args.surahNumber;
      _currentSurahName = args.surahNameAr;
      _currentReciterName = args.reciterName;
      _currentAudioUrl = args.audioUrl;
      _currentFilePath = localFilePath;
      _currentArgsController.add(args);

      final cleanServer = args.serverUrl.endsWith('/')
          ? args.serverUrl
          : '${args.serverUrl}/';

      final allSurahs = QuranConstants.surahMap.values.toList();
      final sources = <AudioSource>[];

      for (final s in allSurahs) {
        final formattedNumber = s.number.toString().padLeft(3, '0');
        final surahUrl = '$cleanServer$formattedNumber.mp3';
        final isSelectedLocal =
            s.number == args.surahNumber && localFilePath != null;

        if (isSelectedLocal) {
          sources.add(
            AudioSource.file(
              localFilePath,
              tag: MediaItem(
                id: localFilePath,
                title: s.name,
                artist: args.reciterName,
                album: 'القرآن الكريم',
                artUri: Uri.parse('asset:///assets/icons/logo.png'),
              ),
            ),
          );
        } else {
          sources.add(
            AudioSource.uri(
              Uri.parse(surahUrl),
              tag: MediaItem(
                id: surahUrl,
                title: s.name,
                artist: args.reciterName,
                album: 'القرآن الكريم',
                artUri: Uri.parse('asset:///assets/icons/logo.png'),
              ),
            ),
          );
        }
      }

      final playlist = ConcatenatingAudioSource(
        children: sources,
        useLazyPreparation: true,
      );

      final initialIndex =
          (args.surahNumber - 1).clamp(0, sources.length - 1);
      await _player.setAudioSource(playlist, initialIndex: initialIndex);
      await _player.play();
    } catch (e) {
      debugPrint('RadioAudioPlayerService playSurahSequence error: $e');
      rethrow;
    }
  }

  Future<void> playUrl({
    required String url,
    int? surahId,
    String? surahName,
    String? reciterName,
  }) async {
    try {
      _currentArgs = null;
      _currentSurahId = surahId;
      _currentSurahName = surahName;
      _currentReciterName = reciterName;
      _currentAudioUrl = url;
      _currentFilePath = null;
      _currentArgsController.add(null);

      debugPrint('RadioAudioPlayerService: Loading $url');
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          title: surahName ?? reciterName ?? 'إذاعة القرآن الكريم',
          artist: reciterName ?? 'القرآن الكريم',
          album: 'القرآن الكريم',
          artUri: Uri.parse('asset:///assets/icons/logo.png'),
        ),
      );
      await _player.setAudioSource(audioSource);
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
      _currentArgs = null;
      _currentSurahId = surahId;
      _currentSurahName = surahName;
      _currentReciterName = reciterName;
      _currentAudioUrl = null;
      _currentFilePath = filePath;
      _currentArgsController.add(null);

      debugPrint('RadioAudioPlayerService: Loading local file $filePath');
      final audioSource = AudioSource.file(
        filePath,
        tag: MediaItem(
          id: filePath,
          title: surahName ?? reciterName ?? 'إذاعة القرآن الكريم',
          artist: reciterName ?? 'القرآن الكريم',
          album: 'القرآن الكريم',
          artUri: Uri.parse('asset:///assets/icons/logo.png'),
        ),
      );
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      debugPrint('RadioAudioPlayerService playFilePath error: $e');
      rethrow;
    }
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() async {
    _currentSurahId = null;
    _currentSurahName = null;
    _currentReciterName = null;
    _currentAudioUrl = null;
    _currentFilePath = null;
    _currentArgs = null;
    _currentArgsController.add(null);
    await _player.stop();
  }

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  Future<void> skipToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    }
  }

  Future<void> skipToPrevious() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

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
    _currentArgsController.close();
    _player.dispose();
  }
}
