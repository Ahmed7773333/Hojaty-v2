import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/home_mock_data.dart';
import '../../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../data/models/quick_access_model.dart';
import '../../bloc/homelayout_bloc.dart';
import '../../bloc/homelayout_event.dart';
import 'home_quick_access_card_widget.dart';

class HomeQuickAccessWidget extends StatelessWidget {
  const HomeQuickAccessWidget({super.key});

  void _handleTap(BuildContext context, QuickAccessType type) {
    switch (type) {
      case QuickAccessType.quran:
        final quranState = context.read<QuranBloc>().state;
        final selectedQirat = quranState.selectedQirat;
        final lastPage = quranState.qiratLastPages[selectedQirat] ?? quranState.currentPage;
        context.pushNamed(AppRoutes.quranReader, extra: lastPage);
        break;
      case QuickAccessType.athkar:
        context.read<HomelayoutBloc>().add(const ChangeBottomNavTabEvent(2));
        break;
      case QuickAccessType.occasions:
        context.read<HomelayoutBloc>().add(const ChangeBottomNavTabEvent(3));
        break;
      case QuickAccessType.prayerTimes:
        context.pushNamed(AppRoutes.prayerTimes);
        break;
      case QuickAccessType.radio:
        context.pushNamed(AppRoutes.radio);
        break;
      case QuickAccessType.books:
        context.pushNamed(AppRoutes.books);
        break;
      case QuickAccessType.sebha:
        context.pushNamed(AppRoutes.sebha);
        break;  
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = HomeMockData.quickAccessItems;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.quickAccess,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 12.h),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return HomeQuickAccessCardWidget(
                item: item,
                onTap: () => _handleTap(context, item.type),
              );
            },
          ),
        ],
      ),
    );
  }
}
