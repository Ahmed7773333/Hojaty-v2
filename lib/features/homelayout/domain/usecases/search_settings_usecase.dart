import 'package:hojaty/core/utils/arabic_text_normalizer.dart';
import 'package:hojaty/features/homelayout/data/datasources/local/settings_search_index.dart';
import 'package:hojaty/features/homelayout/domain/entities/setting_search_item.dart';

class SearchSettingsUseCase {
  const SearchSettingsUseCase();

  List<SettingSearchItem> call(
    String rawQuery, {
    List<SettingSearchItem>? items,
    bool adhanTabOnly = false,
  }) {
    final normalizedQuery = ArabicTextNormalizer.normalize(rawQuery);
    if (normalizedQuery.isEmpty) return const [];

    final queryTokens = ArabicTextNormalizer.tokenize(normalizedQuery);
    final source = items ?? SettingsSearchIndex.items;

    final scored = <({SettingSearchItem item, int score})>[];

    for (final item in source) {
      if (adhanTabOnly &&
          item.destination != SettingSearchDestination.adhanSettingsTab) {
        continue;
      }

      final score = _scoreItem(item, normalizedQuery, queryTokens);
      if (score > 0) {
        scored.add((item: item, score: score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((e) => e.item).toList();
  }

  int _scoreItem(
    SettingSearchItem item,
    String normalizedQuery,
    List<String> queryTokens,
  ) {
    final normAr = ArabicTextNormalizer.normalize(item.titleAr);
    final normEn = ArabicTextNormalizer.normalize(item.titleEn);
    final normBreadcrumbAr = ArabicTextNormalizer.normalize(item.breadcrumbAr);
    final normBreadcrumbEn = ArabicTextNormalizer.normalize(item.breadcrumbEn);
    final normTags = item.synonymsAndTags
        .map(ArabicTextNormalizer.normalize)
        .where((t) => t.isNotEmpty)
        .toList();

    int score = 0;

    // 1. Exact or strong title match
    if (normAr == normalizedQuery || normEn == normalizedQuery) {
      score += 120;
    } else if (normAr.startsWith(normalizedQuery) ||
        normEn.startsWith(normalizedQuery)) {
      score += 90;
    } else if (normAr.contains(normalizedQuery) ||
        normEn.contains(normalizedQuery)) {
      score += 70;
    }

    // 2. Exact / partial tag & colloquial intent match
    for (final tag in normTags) {
      if (tag == normalizedQuery) {
        score += 100;
      } else if (tag.contains(normalizedQuery) ||
          normalizedQuery.contains(tag)) {
        score += 65;
      }
    }

    // 3. Breadcrumb match
    if (normBreadcrumbAr.contains(normalizedQuery) ||
        normBreadcrumbEn.contains(normalizedQuery)) {
      score += 25;
    }

    // 4. Multi-token match across combined searchable corpus
    if (queryTokens.isNotEmpty) {
      final combined =
          '$normAr $normEn $normBreadcrumbAr $normBreadcrumbEn ${normTags.join(' ')}';
      int matchedTokens = 0;
      for (final token in queryTokens) {
        if (combined.contains(token)) {
          matchedTokens++;
        }
      }
      if (matchedTokens == queryTokens.length) {
        score += 45 + (matchedTokens * 10);
      } else if (matchedTokens > 0 && score == 0) {
        score += matchedTokens * 15;
      }
    }

    return score;
  }
}
