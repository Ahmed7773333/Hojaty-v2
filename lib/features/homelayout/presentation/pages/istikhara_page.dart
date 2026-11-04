import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/athkar_mock_data.dart';
import '../widgets/occasions/istikhara_dua_card_widget.dart';
import '../widgets/occasions/istikhara_header_widget.dart';
import '../widgets/occasions/istikhara_step_card_widget.dart';

class IstikharaPage extends StatelessWidget {
  const IstikharaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = AthkarMockData.istikharaSteps;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const IstikharaHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.istikharaStepsTitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  14.ver,
                  ...steps.map((step) {
                    if (step.isDua) {
                      return IstikharaDuaCardWidget(step: step);
                    }
                    return IstikharaStepCardWidget(step: step);
                  }),
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
