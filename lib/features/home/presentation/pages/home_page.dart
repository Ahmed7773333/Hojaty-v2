import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../widgets/home_bottom_sheet_widget.dart';
import '../widgets/next_prayer_header_widget.dart';
import '../widgets/prayers_background_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<HomeBloc>()..add(LoadHomeEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Layer: Prayer Times
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: 100,
              ), // Push down to not hide behind header
              child: PrayersBackgroundWidget(),
            ),
          ),

          // 2. Interactive Layer: Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2, // Show at least a bit
            maxChildSize: 0.85, // Leave top 15% for the Next Prayer Header
            builder: (context, scrollController) {
              return HomeBottomSheetWidget(scrollController: scrollController);
            },
          ),

          // 3. Top Layer: Next Prayer Persistent Header
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 120, // Dedicate height for the header
                child: NextPrayerHeaderWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
