import 'package:flutter/material.dart';
import 'package:hojaty/core/constants/assets.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/quraan/data/services/quraan_pad_service.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/routes/app_router.dart';
import '../../../quraan/presentation/widgets/qirat_selection_dialog.dart';
import '../../../quraan/domain/entities/qirat_type.dart';

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
    // Check if Hafs (default) is downloaded at least, or maybe we check what is selected preference?
    // For QuickLink, usually it opens the Quran. If nothing is downloaded, we show dialog to download.
    // Let's assume we need at least one downloaded.

    final padService = injector<QuraanPadService>();
    // Check if Hafs is downloaded as it's the default default.
    // Or we could check if ANY is downloaded.
    // For now, let's keep it simple: check Hafs.
    // If user wants functionality to open even if Hafs missing but others present, we need to check preferences.
    // But we haven't implemented preferences check here yet.

    final isHafsDownloaded = await padService.isQiratDownloaded(QiratType.hafs);

    if (isHafsDownloaded) {
      if (context.mounted) context.pushNamed(AppRoutes.quraan);
      return;
    }

    if (context.mounted) {
      _showDownloadDialog(context);
    }
  }

  void _showDownloadDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (ctx) => const QiratSelectionDialog(),
    );

    if (result == true && context.mounted) {
      context.pushNamed(AppRoutes.quraan);
    }
  }
}
