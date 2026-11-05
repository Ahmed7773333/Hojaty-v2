import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/quran_mock_data.dart';
import '../../../homelayout/data/models/surah_item_model.dart';
import '../../../homelayout/presentation/widgets/quran/quran_continue_reading_widget.dart';
import '../../../homelayout/presentation/widgets/quran/quran_header_widget.dart';
import '../../../homelayout/presentation/widgets/quran/surah_list_card_widget.dart';
import '../../constants/quran_text_helper.dart';
import '../bloc/quran_bloc.dart';

class QuranFehresPage extends StatefulWidget {
  const QuranFehresPage({super.key});

  @override
  State<QuranFehresPage> createState() => _QuranFehresPageState();
}

class _QuranFehresPageState extends State<QuranFehresPage> {
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

  void _onSurahSelected(int pageNumber) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(pageNumber);
    } else {
      context.pushNamed(AppRoutes.quranReader, extra: pageNumber);
    }
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
            showBackButton: true,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  QuranContinueReadingWidget(
                    surahName: lastSurahName.isNotEmpty
                        ? lastSurahName
                        : context.strings.surahBaqarah,
                    ayahNumber: lastPage,
                    onTap: () => _onSurahSelected(lastPage),
                  ),
                  18.ver,
                  SurahListCardWidget(
                    surahs: _filteredSurahs,
                    onSurahTap: (surah) => _onSurahSelected(surah.pageNumber),
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
