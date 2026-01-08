import 'package:flutter/material.dart';
import 'package:hojaty/core/constants/assets.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/features/quraan/data/services/quraan_pad_service.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/routes/app_router.dart';

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
    // Check if we need to download assets (Mainly for Android PAD)
    final padService = injector<QuraanPadService>();
    final isDownloaded = await padService.isPackDownloaded();

    // If downloaded (or logic indicates we shouldn't blocking), navigate.
    // Note: on iOS if not configured, isPackDownloaded might return false always.
    // If we only moved assets for Android, iOS users might not see images if we enforce this.
    // But since we removed from pubspec, they are gone everywhere.
    // Assuming cross-platform capability or Android focus as requested.
    if (isDownloaded) {
      if (context.mounted) context.pushNamed(AppRoutes.quraan);
      return;
    }

    if (context.mounted) {
      _showDownloadDialog(context);
    }
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.strings.downloadQuranTitle),
        content: Text(context.strings.downloadQuranMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.strings.downloadQuranCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startDownload(context);
            },
            child: Text(context.strings.downloadQuranAction),
          ),
        ],
      ),
    );
  }

  Future<void> _startDownload(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _DownloadProgressDialog(),
    );
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  const _DownloadProgressDialog();

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double progress = 0.0;
  String? error;

  @override
  void initState() {
    super.initState();
    _download();
  }

  void _download() async {
    try {
      final padService = injector<QuraanPadService>();
      await for (final p in padService.downloadPack()) {
        if (mounted) {
          setState(() {
            progress = p;
          });
        }
      }
      if (mounted) {
        Navigator.pop(context); // Pop dialog
        context.pushNamed(AppRoutes.quraan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.downloadQuranSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.strings.downloadingQuran),
      content: error != null
          ? Text(context.strings.errorMessage(error!))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 10),
                Text("${(progress * 100).toInt()}%"),
              ],
            ),
      actions: error != null
          ? [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.strings.close),
              ),
            ]
          : null,
    );
  }
}
