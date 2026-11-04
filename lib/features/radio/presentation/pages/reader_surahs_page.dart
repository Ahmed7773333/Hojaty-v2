import 'package:flutter/material.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../quran/constants/quran_constants.dart';
import '../../../quran/constants/quran_text_helper.dart';
import '../../../quran/data/models/surah_info_model.dart';
import '../../data/models/reciter_model.dart';
import '../../data/models/surah_audio_args.dart';
import '../widgets/reader_surahs/reader_surahs_header_widget.dart';
import '../widgets/reader_surahs/reader_surahs_list_widget.dart';
import '../widgets/reader_surahs/reader_surahs_search_bar_widget.dart';

class ReaderSurahsPage extends StatefulWidget {
  final ReciterModel reciter;

  const ReaderSurahsPage({
    super.key,
    required this.reciter,
  });

  @override
  State<ReaderSurahsPage> createState() => _ReaderSurahsPageState();
}

class _ReaderSurahsPageState extends State<ReaderSurahsPage> {
  late final TextEditingController _searchController;
  late final List<SurahInfoModel> _allSurahs;
  List<SurahInfoModel> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initSurahs();
  }

  void _initSurahs() {
    final moshaf = widget.reciter.moshaf?.firstOrNull;
    if (moshaf == null || (moshaf.surahList?.isEmpty??true)) {
      _allSurahs = QuranConstants.surahMap.values.toList();
    } else {
      final numbers = (moshaf.surahList??"")
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();

      _allSurahs = numbers
          .map((n) => QuranConstants.surahMap[n])
          .whereType<SurahInfoModel>()
          .toList();
    }
    _filteredSurahs = List.from(_allSurahs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => _filteredSurahs = List.from(_allSurahs));
      return;
    }

    final normalized = QuranTextHelper.normalizeArabic(trimmed).toLowerCase();
    setState(() {
      _filteredSurahs = _allSurahs.where((surah) {
        if ('${surah.number}'.contains(trimmed)) return true;
        final nameAr = QuranTextHelper.normalizeArabic(surah.name).toLowerCase();
        if (nameAr.contains(normalized)) return true;
        final nameEn = surah.englishName.toLowerCase();
        if (nameEn.contains(normalized)) return true;
        return false;
      }).toList();
    });
  }

  void _onSearchCleared() {
    _searchController.clear();
    setState(() => _filteredSurahs = List.from(_allSurahs));
  }

  void _onSurahSelected(SurahInfoModel surah) {
    final serverUrl = widget.reciter.moshaf?.firstOrNull?.server ?? '';
    context.pushNamed(
      AppRoutes.surahAudio,
      extra: SurahAudioArgs(
        surahNumber: surah.number,
        surahNameAr: surah.name,
        surahNameEn: surah.englishName,
        reciterName: widget.reciter.name??'',
        reciterLetter: widget.reciter.letter??'',
        serverUrl: serverUrl,
        reciterId: '${widget.reciter.id}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          ReaderSurahsHeaderWidget(
            reciter: widget.reciter,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReaderSurahsSearchBarWidget(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onClear: _onSearchCleared,
                  ),
                  16.ver,
                  Text(
                    '${context.strings.listenToSurah} (${_filteredSurahs.length})',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  12.ver,
                  ReaderSurahsListWidget(
                    surahs: _filteredSurahs,
                    onSurahSelected: _onSurahSelected,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

