import 'package:flutter/material.dart';
import '../../../../../core/utils/screen_util_like.dart';
import 'ramadan_hero_card_widget.dart';
import 'ramadan_imsakiya_table_widget.dart';

class RamadanSubtabView extends StatelessWidget {
  const RamadanSubtabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          const RamadanHeroCardWidget(),
          24.ver,
          const RamadanImsakiyaTableWidget(),
          24.ver,
        ],
      ),
    );
  }
}
