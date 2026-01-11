// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/services/quraan_pad_service.dart';
import '../../domain/entities/qirat_type.dart';

class QiratSelectionDialog extends StatefulWidget {
  const QiratSelectionDialog({super.key});

  @override
  State<QiratSelectionDialog> createState() => _QiratSelectionDialogState();
}

class _QiratSelectionDialogState extends State<QiratSelectionDialog> {
  final Set<QiratType> selectedQirats = {QiratType.hafs};
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? errorMessage;
  String? currentDownloadingItem;

  @override
  Widget build(BuildContext context) {
    if (isDownloading) {
      return _buildProgressDialog();
    }
    return AlertDialog(
      title: Text(context.strings.select_qirat),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: QiratType.values.map((qirat) {
            return CheckboxListTile(
              title: Text(qirat.label(context)),
              value: selectedQirats.contains(qirat),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedQirats.add(qirat);
                  } else {
                    selectedQirats.remove(qirat);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.cancel),
        ),
        FilledButton(
          onPressed: selectedQirats.isEmpty ? null : _startDownload,
          child: Text(context.strings.download_selected),
        ),
      ],
    );
  }

  Widget _buildProgressDialog() {
    return AlertDialog(
      title: Text(context.strings.downloadingQuran),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentDownloadingItem != null) ...[
            Text(currentDownloadingItem!),
            const SizedBox(height: 8),
          ],
          LinearProgressIndicator(value: downloadProgress),
          const SizedBox(height: 10),
          Text("${(downloadProgress * 100).toInt()}%"),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(errorMessage!, style: TextStyle(color: context.colors.error)),
          ],
        ],
      ),
      actions: errorMessage != null
          ? [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.strings.close),
              ),
            ]
          : null, // No cancel while downloading for simplicity, or add cancel support
    );
  }

  Future<void> _startDownload() async {
    setState(() {
      isDownloading = true;
      errorMessage = null;
      downloadProgress = 0.0;
    });

    final padService = injector<QuraanPadService>();
    final total = selectedQirats.length;
    int completed = 0;

    try {
      for (final qirat in selectedQirats) {
        if (!mounted) return;

        setState(() {
          currentDownloadingItem = qirat.label(context);
          downloadProgress = 0.0;
        });

        // Check if already downloaded to skip?
        // PadService might handle it or we re-download.
        // Let's check first to save bandwidth/time if service doesn't.
        if (await padService.isQiratDownloaded(qirat)) {
          completed++;
          continue;
        }

        await for (final p in padService.downloadPack(qirat)) {
          if (!mounted) return;
          setState(() {
            // Local progress for this item
            downloadProgress = p;
          });
        }
        completed++;
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.downloadQuranSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    }
  }
}
