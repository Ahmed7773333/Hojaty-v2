import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_hero_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/occasions/ramadan_imsakiya_table_widget.dart';

class RamadanSubtabView extends StatelessWidget {
  const RamadanSubtabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        20.w,
        16.h + MediaQuery.paddingOf(context).bottom,
      ),
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
