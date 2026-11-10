import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import 'home_athkar_quick_access_card.dart';
import 'home_hadith_quick_access_card.dart';
import 'home_hojaty_ai_quick_access_card.dart';
import 'home_occasion_quick_access_card.dart';
import 'home_quran_quick_access_card.dart';
import 'home_radio_quick_access_card.dart';
import 'home_sebha_quick_access_card.dart';

class HomeQuickAccessWidget extends StatelessWidget {
  const HomeQuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          14.ver,
          const HomeQuranQuickAccessCard(),
          12.ver,
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: HomeOccasionQuickAccessCard()),
                SizedBox(width: 12),
                Expanded(child: HomeAthkarQuickAccessCard()),
              ],
            ),
          ),
          12.ver,
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: HomeRadioQuickAccessCard()),
                SizedBox(width: 12),
                Expanded(child: HomeSebhaQuickAccessCard()),
              ],
            ),
          ),
          12.ver,
          const HomeHadithQuickAccessCard(),
          12.ver,
          const HomeHojatyAiQuickAccessCard(),
        ],
      ),
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL QUICK ACCESS CODE
// ==========================================
// class _ArchivedHomeQuickAccessWidget extends StatelessWidget {
//   const _ArchivedHomeQuickAccessWidget();
//
//   void _handleTap(BuildContext context, QuickAccessType type) {
//     switch (type) {
//       case QuickAccessType.quran:
//         final quranState = context.read<QuranBloc>().state;
//         final selectedQirat = quranState.selectedQirat;
//         final lastPage = quranState.qiratLastPages[selectedQirat] ?? quranState.currentPage;
//         context.pushNamed(AppRoutes.quranReader, extra: lastPage);
//         break;
//       case QuickAccessType.athkar:
//         context.read<HomelayoutBloc>().add(const ChangeBottomNavTabEvent(2));
//         break;
//       case QuickAccessType.occasions:
//         context.read<HomelayoutBloc>().add(const ChangeBottomNavTabEvent(3));
//         break;
//       case QuickAccessType.prayerTimes:
//         context.pushNamed(AppRoutes.prayerTimes);
//         break;
//       case QuickAccessType.radio:
//         context.pushNamed(AppRoutes.radio);
//         break;
//       case QuickAccessType.books:
//         context.pushNamed(AppRoutes.books);
//         break;
//       case QuickAccessType.sebha:
//         context.pushNamed(AppRoutes.sebha);
//         break;  
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final items = HomeMockData.quickAccessItems;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             context.strings.quickAccess,
//             style: context.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w800,
//               fontSize: 18.sp,
//             ),
//           ),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.only(top: 12.h),
//             itemCount: items.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12.w,
//               mainAxisSpacing: 12.h,
//               childAspectRatio: 1.15,
//             ),
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return HomeQuickAccessCardWidget(
//                 item: item,
//                 onTap: () => _handleTap(context, item.type),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
