import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/home_bottom_sheet_widget.dart';
import '../widgets/prayers_background_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HomeBloc>()..add(LoadHomeEvent()),
      child: ChangeNotifierProvider(
        create: (_) => PrayerTimesProvider()..initialize(),
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Track sheet position for animations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Layer: Prayer Times
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: 60.h),
              child: const PrayersBackgroundWidget(),
            ),
          ),

          // 2. Interactive Layer: Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {});
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.1,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return HomeBottomSheetWidget(
                  scrollController: scrollController,
                );
              },
            ),
          ),

          // // 3. Top Layer: Next Prayer Persistent Header
          // SafeArea(
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: SizedBox(
          //       height: 130.h,
          //       child: NextPrayerHeaderWidget(sheetPosition: _sheetPosition),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
