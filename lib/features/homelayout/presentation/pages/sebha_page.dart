import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/athkar/sebha_controls_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/athkar/sebha_counter_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/athkar/sebha_header_widget.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = UserHiveHelper.getSebhaCounter();
  }

  void _increment() {
    setState(() {
      _count++;
    });
    UserHiveHelper.setSebhaCounter(_count);
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
    UserHiveHelper.setSebhaCounter(0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const SebhaHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  60.ver,
                  SebhaCounterButtonWidget(count: _count, onTap: _increment),
                  40.ver,
                  SebhaControlsWidget(onReset: _reset),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
