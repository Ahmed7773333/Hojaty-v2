import 'playlist_item_model.dart';

class SurahAudioArgs {
  final int surahNumber;
  final String surahNameAr;
  final String surahNameEn;
  final String reciterName;
  final String reciterLetter;
  final String serverUrl;
  final String? reciterId;

  const SurahAudioArgs({
    required this.surahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.reciterName,
    required this.reciterLetter,
    required this.serverUrl,
    this.reciterId,
  });

  PlaylistItemModel toPlaylistItem() {
    return PlaylistItemModel(
      surahId: surahNumber,
      surahNameAr: surahNameAr,
      surahNameEn: surahNameEn,
      reciterName: reciterName,
      reciterLetter: reciterLetter,
      serverUrl: serverUrl,
      reciterId: reciterId,
    );
  }

  String get audioUrl {
    final cleanServer = serverUrl.endsWith('/') ? serverUrl : '$serverUrl/';
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    return '$cleanServer$formattedNumber.mp3';
  }
}

