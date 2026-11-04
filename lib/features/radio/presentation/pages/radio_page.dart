import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../widgets/radio/radio_header_widget.dart';
import '../widgets/radio/radio_live_cards_widget.dart';
import '../widgets/radio/radio_playlist_banner_widget.dart';
import '../widgets/radio/radio_reciters_list_widget.dart';
import '../widgets/radio/radio_search_bar_widget.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late final TextEditingController _searchController;
  late final RadioBloc _radioBloc;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _radioBloc = injector<RadioBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final lang = Localizations.localeOf(context).languageCode;
      _radioBloc.add(LoadRadioEvent(language: lang));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _radioBloc.add(SearchRecitersEvent(query));
    setState(() {});
  }

  void _onSearchCleared() {
    _searchController.clear();
    _radioBloc.add(const SearchRecitersEvent(''));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return BlocProvider.value(
      value: _radioBloc,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Column(
          children: [
            RadioHeaderWidget(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const RadioLiveCardsWidget(),
                    // 16.ver,
                    const RadioPlaylistBannerWidget(),
                    16.ver,
                    RadioSearchBarWidget(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: _onSearchCleared,
                    ),
                    16.ver,
                    Text(
                      context.strings.recitersList,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    // 12.ver,
                    const RadioRecitersListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
