import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hojaty/features/hifz/data/models/curated_track_model.dart';
import 'package:hojaty/features/hifz/domain/entities/curated_track.dart';

/// Loads curated memorization journeys from `assets/data/hifz_tracks.json`.
class CuratedTracksLoader {
  static const String _assetPath = 'assets/data/hifz_tracks.json';

  List<CuratedTrack>? _cachedTracks;

  Future<List<CuratedTrack>> loadTracks() async {
    if (_cachedTracks != null) return _cachedTracks!;

    final raw = await rootBundle.loadString(_assetPath);
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final list = decoded['tracks'] as List<dynamic>? ?? const [];

    _cachedTracks = list
        .whereType<Map<String, dynamic>>()
        .map(CuratedTrackModel.fromJson)
        .toList(growable: false);

    return _cachedTracks!;
  }
}

