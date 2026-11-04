import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/quran_mock_data.dart';
import '../../../../quran/constants/quran_text_helper.dart';
import '../../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../../quran/presentation/bloc/quran_state.dart';
import '../../../data/models/surah_item_model.dart';
import 'quran_continue_reading_widget.dart';
import 'quran_header_widget.dart';
import 'surah_list_card_widget.dart';

class QuranTabView extends StatefulWidget {
  const QuranTabView({super.key});

  @override
  State<QuranTabView> createState() => _QuranTabViewState();
}

class _QuranTabViewState extends State<QuranTabView> {
  final TextEditingController _searchController = TextEditingController();
  List<SurahItemModel> _allSurahs = [];
  List<SurahItemModel> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _allSurahs = QuranMockData.surahs;
    _filteredSurahs = _allSurahs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        final q = query.trim().toLowerCase();
        _filteredSurahs = _allSurahs.where((s) {
          final arabicMatch = s.arabicName.contains(q);
          final englishMatch = s.englishName.toLowerCase().contains(q);
          final numberMatch = s.number.toString() == q;
          return arabicMatch || englishMatch || numberMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final quranState = context.watch<QuranBloc>().state;
    final lastPage = quranState.currentPage;
    final lastSurahName = QuranTextHelper.getSurahName(lastPage);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          QuranHeaderWidget(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  QuranContinueReadingWidget(
                    surahName: lastSurahName.isNotEmpty ? lastSurahName : context.strings.surahBaqarah,
                    ayahNumber: lastPage,
                    onTap: () {
                      context.pushNamed(AppRoutes.quranReader, extra: lastPage);
                    },
                  ),
                  18.ver,
                  SurahListCardWidget(
                    surahs: _filteredSurahs,
                    onSurahTap: (surah) {
                      context.pushNamed(AppRoutes.quranReader, extra: surah.pageNumber);
                    },
                  ),
                  24.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
