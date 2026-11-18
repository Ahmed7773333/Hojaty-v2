import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_next_prayer_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_prayer_times_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_qibla_banner_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/home/home_quick_access_widget.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          RepaintBoundary(
            child: ColoredBox(
              color: AppColors.primaryDarkBackground,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    const HomeHeaderWidget(),
                    const HomeNextPrayerCardWidget(),
                    const HomeQiblaBannerWidget(),
                    12.ver,
                  ],
                ),
              ),
            ),
          ),
          RepaintBoundary(
            child: ColoredBox(
              color: context.isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              child: Column(
                children: [
                  20.ver,
                  const HomePrayerTimesWidget(),
                  20.ver,
                  const HomeQuickAccessWidget(),
                  20.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
