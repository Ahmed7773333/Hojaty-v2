import 'package:equatable/equatable.dart';

class QuraanPageModel extends Equatable {
  final int pageNumber;
  final List<String> surahsNames;
  final int juzNumber;
  final int
  hizbNumber; // Derived from quarter/rub logic if needed, or simple mapping
  final String juzName;
  final String quarterName; // e.g. "الحزب الأول"
  final List<String> tafseer;
  // Additional fields from JSON if useful:
  final bool hasBesmALLAH;
  final List<String> versesContent;
  final List<int> versesNumbers;
  final bool isFateha;

  const QuraanPageModel({
    required this.pageNumber,
    required this.surahsNames,
    required this.juzNumber,
    required this.hizbNumber,
    required this.juzName,
    required this.quarterName,
    required this.tafseer,
    required this.hasBesmALLAH,
    required this.versesContent,
    required this.versesNumbers,
    required this.isFateha,
  });

  factory QuraanPageModel.fromJson(Map<String, dynamic> json) {
    return QuraanPageModel(
      pageNumber: json['pageNumber'] as int? ?? 0,
      surahsNames:
          (json['surahsNames'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      juzNumber: json['juzNumber'] as int? ?? 0,
      hizbNumber:
          0, // We can calculate this later if needed or parse if available
      juzName: json['juzName'] as String? ?? '',
      quarterName: json['quarterName'] as String? ?? '',
      tafseer:
          (json['tafseer'] as List?)?.map((e) => e.toString()).toList() ?? [],
      hasBesmALLAH: json['hasBesmALLAH'] as bool? ?? false,
      versesContent:
          (json['versesContent'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      versesNumbers:
          (json['versesNumbers'] as List?)
              ?.map((e) => int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
      isFateha: json['isFateha'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    pageNumber,
    surahsNames,
    juzNumber,
    hizbNumber,
    juzName,
    quarterName,
    tafseer,
    hasBesmALLAH,
    versesContent,
    versesNumbers,
    isFateha,
  ];
}
