import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import 'next_prayer_header_widget.dart';
import 'quraan_quick_link_widget.dart';
import 'services_grid_widget.dart';

class HomeBottomSheetWidget extends StatelessWidget {
  final ScrollController scrollController;

  const HomeBottomSheetWidget({required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const NextPrayerHeaderWidget(sheetPosition: 0),

          const SizedBox(height: 24),
          const QuraanQuickLinkWidget(),
          const ServicesGridWidget(),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }
}
