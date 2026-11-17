import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/hadith_item_model.dart';

class BookReaderSearchSheet extends StatefulWidget {
  final List<HadithItemModel> hadiths;
  final Map<int, int> hadithPages;
  final ValueChanged<int> onSelectPage;

  const BookReaderSearchSheet({
    super.key,
    required this.hadiths,
    required this.hadithPages,
    required this.onSelectPage,
  });

  @override
  State<BookReaderSearchSheet> createState() => _BookReaderSearchSheetState();
}

class _BookReaderSearchSheetState extends State<BookReaderSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<HadithItemModel> _results = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.length < 2) {
      setState(() => _results = []);
      return;
    }

    final matched = widget.hadiths
        .where((h) {
          return h.arabic.toLowerCase().contains(trimmed) ||
              h.englishText.toLowerCase().contains(trimmed) ||
              h.idInBook.toString() == trimmed;
        })
        .take(50)
        .toList();

    setState(() => _results = matched);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBorderUnselected
                  : AppColors.lightBorderUnselected,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.searchHadithsHint,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          8.ver,
          TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearch,
            decoration: InputDecoration(
              hintText: context.strings.searchHadithsHint,
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          12.ver,
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.trim().length >= 2
                          ? context.strings.noHadithsFound
                          : context.strings.searchHadithsHint,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => 8.ver,
                    itemBuilder: (context, index) {
                      final h = _results[index];
                      final page = widget.hadithPages[h.id] ?? 1;

                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkBorderUnselected
                                : AppColors.lightBorderUnselected,
                          ),
                        ),
                        tileColor: isDark
                            ? AppColors.darkCardUnselected
                            : AppColors.lightBackground,
                        title: Text(
                          '${context.strings.hadithWord} ${h.idInBook > 0 ? h.idInBook : h.id}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: isDark
                                ? AppColors.accentGold
                                : AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            h.arabic,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              height: 1.4,
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${context.strings.pageWord} $page',
                            style: context.textTheme.labelSmall?.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSelectPage(page);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
