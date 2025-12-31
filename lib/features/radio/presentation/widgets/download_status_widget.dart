import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class DownloadStatusWidget extends StatelessWidget {
  final bool isDownloading;
  final double downloadProgress;
  final bool isDownloaded;
  final VoidCallback onDownload;

  const DownloadStatusWidget({
    super.key,
    required this.isDownloading,
    required this.downloadProgress,
    required this.isDownloaded,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    if (isDownloaded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              context.strings.offline_available,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isDownloading) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: downloadProgress,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(downloadProgress * 100).toStringAsFixed(0)}% - ${context.strings.downloading}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    return OutlinedButton.icon(
      onPressed: onDownload,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      icon: const Icon(Icons.download_rounded),
      label: Text(context.strings.download),
    );
  }
}
