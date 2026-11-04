import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import '../widgets/quran_search_input_widget.dart';
import '../widgets/quran_search_result_card_widget.dart';

class QuranSearchPage extends StatefulWidget {
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 8.w),
          child: QuranSearchInputWidget(
            controller: _searchController,
            onChanged: (val) {
              context.read<QuranBloc>().add(SearchQuranEvent(val));
            },
            onClear: () {
              _searchController.clear();
              context.read<QuranBloc>().add(const SearchQuranEvent(''));
            },
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            final results = state.searchResults;
            final query = _searchController.text.trim();

            if (query.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 48.sp,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    12.ver,
                    Text(
                      context.strings.quranSearchHint,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.find_in_page_outlined,
                      size: 48.sp,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    12.ver,
                    Text(
                      context.strings.quranNoResults,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return QuranSearchResultCardWidget(
                  result: result,
                  onTap: (pageNum) {
                    Navigator.of(context).pop(pageNum);
                  },
                  onTafseerTap: (hit) {
                    final pageData = state.quranPages[hit.pageNum];
                    context.pushNamed(
                      AppRoutes.quranTafseer,
                      extra: {
                        'pageData': pageData,
                        'pageNum': hit.pageNum,
                        'highlightVerse': hit.verseNum,
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
