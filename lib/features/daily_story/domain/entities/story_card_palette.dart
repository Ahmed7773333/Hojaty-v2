enum StoryCardPalette {
  emeraldDawn,
  midnightGold,
  warmParchment;

  static StoryCardPalette fromKey(String? key) {
    for (final palette in values) {
      if (palette.name == key) return palette;
    }
    return StoryCardPalette.emeraldDawn;
  }
}

