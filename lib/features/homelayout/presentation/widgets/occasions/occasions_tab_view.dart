import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import 'calendar_subtab_view.dart';
import 'occasions_header_widget.dart';
import 'occasions_list_subtab_view.dart';
import 'occasions_tab_bar_widget.dart';
import 'ramadan_subtab_view.dart';

class OccasionsTabView extends StatefulWidget {
  const OccasionsTabView({super.key});

  @override
  State<OccasionsTabView> createState() => _OccasionsTabViewState();
}

class _OccasionsTabViewState extends State<OccasionsTabView> {
  int _selectedTabIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLang = Localizations.localeOf(context).languageCode;
    final bloc = context.read<HomelayoutBloc>();
    if (bloc.state.currentLanguage != currentLang) {
      bloc.add(LoadOccasionsDataEvent(language: currentLang));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final subtabs = [
      const OccasionsListSubtabView(),
      const CalendarSubtabView(),
      const RamadanSubtabView(),
    ];

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          const OccasionsHeaderWidget(),
          OccasionsTabBarWidget(
            selectedIndex: _selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: subtabs,
            ),
          ),
        ],
      ),
    );
  }
}
