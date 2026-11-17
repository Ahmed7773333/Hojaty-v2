import 'package:equatable/equatable.dart';

class AzanAudioItemModel extends Equatable {
  final String id;
  final String title;
  final String file;
  final String url;
  final int durationSec;
  final int sizeKb;
  final bool isDownloaded;
  final String? localPath;
  final bool isBuiltIn;

  const AzanAudioItemModel({
    required this.id,
    required this.title,
    required this.file,
    required this.url,
    required this.durationSec,
    required this.sizeKb,
    this.isDownloaded = false,
    this.localPath,
    this.isBuiltIn = false,
  });

  static String cleanTitle(String rawTitle) {
    return rawTitle
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  factory AzanAudioItemModel.fromJson(
    Map<String, dynamic> json, {
    bool isDownloaded = false,
    String? localPath,
  }) {
    final rawTitle = json['title'] as String? ?? '';
    return AzanAudioItemModel(
      id: json['id'] as String? ?? '',
      title: cleanTitle(rawTitle),
      file: json['file'] as String? ?? '',
      url: json['url'] as String? ?? '',
      durationSec: (json['duration_sec'] as num?)?.toInt() ?? 0,
      sizeKb: (json['size_kb'] as num?)?.toInt() ?? 0,
      isDownloaded: isDownloaded,
      localPath: localPath,
    );
  }

  AzanAudioItemModel copyWith({
    String? id,
    String? title,
    String? file,
    String? url,
    int? durationSec,
    int? sizeKb,
    bool? isDownloaded,
    String? localPath,
    bool? isBuiltIn,
  }) {
    return AzanAudioItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      file: file ?? this.file,
      url: url ?? this.url,
      durationSec: durationSec ?? this.durationSec,
      sizeKb: sizeKb ?? this.sizeKb,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }

  String get formattedDuration {
    final minutes = (durationSec ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSec % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedSize {
    if (sizeKb >= 1024) {
      final mb = (sizeKb / 1024).toStringAsFixed(1);
      return '$mb MB';
    }
    return '$sizeKb KB';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    file,
    url,
    durationSec,
    sizeKb,
    isDownloaded,
    localPath,
    isBuiltIn,
  ];
}

