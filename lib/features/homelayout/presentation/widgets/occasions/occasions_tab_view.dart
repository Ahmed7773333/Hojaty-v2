import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/calendar_subtab_view.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasions_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasions_list_subtab_view.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/occasions_tab_bar_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_subtab_view.dart';

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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: Column(
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
            child: IndexedStack(index: _selectedTabIndex, children: subtabs),
            ),
          ],
        ),
      ),
    );
  }
}
