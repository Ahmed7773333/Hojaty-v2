enum DailyStoryCategory {
  all,
  ayah,
  salawat,
  dhikr,
  dua;

  static DailyStoryCategory fromKey(String? key) {
    for (final category in values) {
      if (category.name == key) return category;
    }
    return DailyStoryCategory.all;
  }
}

