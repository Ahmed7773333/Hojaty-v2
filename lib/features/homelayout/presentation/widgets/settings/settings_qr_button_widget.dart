import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../../core/utils/screen_util_like.dart';
import '../shared/app_qr_code_dialog.dart';

class SettingsQrButtonWidget extends StatelessWidget {
  const SettingsQrButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            context.showDialogRoute(
              builder: const AppQrCodeDialog(),
            );
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.qr_code_2_rounded,
            size: 22.r,
            color: isDark ? AppColors.accentGold : AppColors.primaryDark,
          ),
        ),
        8.hor,
        Icon(
          Icons.arrow_forward_ios,
          size: 14.r,
          color: isDark
              ? AppColors.darkTextMuted
              : AppColors.lightTextMuted,
        ),
      ],
    );
  }
}

