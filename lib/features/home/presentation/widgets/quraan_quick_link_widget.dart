import 'package:flutter/material.dart';
import 'package:hojaty/core/constants/assets.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/quraan/data/services/quraan_pad_service.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/routes/app_router.dart';
import '../../../quraan/presentation/widgets/qirat_selection_dialog.dart';
import '../../../quraan/domain/repositories/quraan_repository.dart';

class QuraanQuickLinkWidget extends StatelessWidget {
  const QuraanQuickLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(Assets.quraanCard),
            fit: BoxFit.cover,
            // opacity: 0.2,
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final repo = injector<QuraanRepository>();
    final padService = injector<QuraanPadService>();

    // 1. Get the user's preferred Qirat
    final selectedQirat = await repo.getSelectedQirat();

    // 2. Check if THAT Qirat is downloaded
    final isDownloaded = await padService.isQiratDownloaded(selectedQirat);

    if (isDownloaded) {
      if (context.mounted) context.pushNamed(AppRoutes.quraan);
      return;
    }

    // 3. If not downloaded, show dialog
    if (context.mounted) {
      _showDownloadDialog(context);
    }
  }

  void _showDownloadDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (ctx) => const QiratSelectionDialog(),
    );

    // Only navigate if download was successful (result == true)
    if (result == true && context.mounted) {
      context.pushNamed(AppRoutes.quraan);
    }
  }
}
