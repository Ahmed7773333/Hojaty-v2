import 'package:equatable/equatable.dart';
import 'moshaf_model.dart';

class ReciterModel extends Equatable {
  final int? id;
  final String? name;
  final String? letter;
  final List<MoshafModel>? moshaf;

  const ReciterModel({
    this.id,
    this.name,
    this.letter,
    this.moshaf,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      letter: json['letter'] as String?,
      moshaf: (json['moshaf'] as List<dynamic>?)
          ?.map((e) => MoshafModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'letter': letter,
      'moshaf': moshaf?.map((e) => e.toJson()).toList(),
    };
  }

  ReciterModel copyWith({
    int? id,
    String? name,
    String? letter,
    List<MoshafModel>? moshaf,
  }) {
    return ReciterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      letter: letter ?? this.letter,
      moshaf: moshaf ?? this.moshaf,
    );
  }

  bool hasSurah(int surahNumber) {
    if (moshaf == null || moshaf!.isEmpty) return true;
    return moshaf!.any((m) {
      if (m.surahList == null || m.surahList!.trim().isEmpty) return true;
      final numbers = m.surahList!
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>();
      return numbers.contains(surahNumber);
    });
  }

  MoshafModel? getMoshafForSurah(int surahNumber) {
    if (moshaf == null || moshaf!.isEmpty) return null;
    for (final m in moshaf!) {
      if (m.surahList != null && m.surahList!.trim().isNotEmpty) {
        final numbers = m.surahList!
            .split(',')
            .map((s) => int.tryParse(s.trim()))
            .whereType<int>();
        if (numbers.contains(surahNumber)) return m;
      }
    }
    for (final m in moshaf!) {
      if (m.surahList == null || m.surahList!.trim().isEmpty) return m;
    }
    return moshaf!.firstOrNull;
  }

  @override
  List<Object?> get props => [id, name, letter, moshaf];
}

