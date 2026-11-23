import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hojaty/features/quran/data/models/quran_checkpoint_model.dart';

class QuranCheckpointLocalDataSource {
  static const String _checkpointsBoxName = 'quran_checkpoints_box';

  const QuranCheckpointLocalDataSource();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(QuranCheckpointModelAdapter());
    }

    try {
      if (!Hive.isBoxOpen(_checkpointsBoxName)) {
        await Hive.openBox<QuranCheckpointModel>(_checkpointsBoxName);
      }
    } catch (e) {
      debugPrint('Error opening $_checkpointsBoxName: $e');
      await Hive.deleteBoxFromDisk(_checkpointsBoxName);
      await Hive.openBox<QuranCheckpointModel>(_checkpointsBoxName);
    }
  }

  Box<QuranCheckpointModel> get _box =>
      Hive.box<QuranCheckpointModel>(_checkpointsBoxName);

  Future<List<QuranCheckpointModel>> getAll() async {
    await init();
    final list = _box.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> save(QuranCheckpointModel checkpoint) async {
    await init();
    await _box.put(checkpoint.id, checkpoint);
  }

  Future<void> remove(String id) async {
    await init();
    await _box.delete(id);
  }

  bool isBookmarked(int pageNumber, int verseIndex) {
    if (!Hive.isBoxOpen(_checkpointsBoxName)) return false;
    return _box.containsKey('${pageNumber}_$verseIndex');
  }

  ValueListenable<Box<QuranCheckpointModel>>? listenable() {
    if (!Hive.isBoxOpen(_checkpointsBoxName)) return null;
    return _box.listenable();
  }
}

