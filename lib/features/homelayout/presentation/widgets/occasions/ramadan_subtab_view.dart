import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_hero_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_imsakiya_table_widget.dart';

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
