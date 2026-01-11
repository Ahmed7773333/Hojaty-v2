import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/services/quraan_pad_service.dart';
import '../../domain/entities/qirat_type.dart';
import '../../domain/repositories/quraan_repository.dart';

class QuraanBottomSheetSelection extends StatefulWidget {
  const QuraanBottomSheetSelection({super.key});

  @override
  State<QuraanBottomSheetSelection> createState() =>
      _QuraanBottomSheetSelectionState();
}

class _QuraanBottomSheetSelectionState
    extends State<QuraanBottomSheetSelection> {
  final _padService = injector<QuraanPadService>();
  final _repository = injector<QuraanRepository>();

  QiratType? _selectedQirat;
  Map<QiratType, bool> _downloadStatus = {};
  final Map<QiratType, double> _downloadProgress = {};
  final Map<QiratType, bool> _isDownloading = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final selected = await _repository.getSelectedQirat();
    final status = <QiratType, bool>{};

    for (var type in QiratType.values) {
      status[type] = await _padService.isQiratDownloaded(type);
    }

    if (mounted) {
      setState(() {
        _selectedQirat = selected;
        _downloadStatus = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      // decoration handled by modal bottom sheet usually, but adding some rounding
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.strings.qiraat,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (_selectedQirat == null)
            const CircularProgressIndicator()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: QiratType.values.length,
              itemBuilder: (context, index) {
                final type = QiratType.values[index];
                return _buildItem(type);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildItem(QiratType type) {
    final isSelected = _selectedQirat == type;
    final isDownloaded = _downloadStatus[type] ?? false;
    final isDownloading = _isDownloading[type] ?? false;
    final progress = _downloadProgress[type] ?? 0.0;

    return ListTile(
      title: Text(type.label(context)),
      leading: isSelected
          ? Icon(Icons.check_circle, color: context.colors.primary)
          : const Icon(Icons.circle_outlined),
      trailing: _buildTrailing(
        type,
        isSelected,
        isDownloaded,
        isDownloading,
        progress,
      ),
      onTap: () => _handleTap(type, isDownloaded, isDownloading),
    );
  }

  Widget? _buildTrailing(
    QiratType type,
    bool isSelected,
    bool isDownloaded,
    bool isDownloading,
    double progress,
  ) {
    if (isDownloading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: progress > 0 ? progress : null,
          strokeWidth: 2,
        ),
      );
    }
    if (isDownloaded) {
      return null;
    }
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () => _startDownload(type),
    );
  }

  void _handleTap(QiratType type, bool isDownloaded, bool isDownloading) {
    if (isDownloading) return;

    if (isDownloaded) {
      _selectQirat(type);
    } else {
      _startDownload(type);
    }
  }

  Future<void> _selectQirat(QiratType type) async {
    await _repository.saveSelectedQirat(type);
    if (mounted) {
      setState(() {
        _selectedQirat = type;
      });
      // Optionally pop, or let user switch multiple times
      // Navigator.pop(context);
    }
  }

  Future<void> _startDownload(QiratType type) async {
    setState(() {
      _isDownloading[type] = true;
      _downloadProgress[type] = 0.0;
    });

    try {
      await for (final p in _padService.downloadPack(type)) {
        if (mounted) {
          setState(() {
            _downloadProgress[type] = p;
          });
        }
      }
      if (mounted) {
        setState(() {
          _isDownloading[type] = false;
          _downloadStatus[type] = true;
          // Auto select if desired? Maybe not.
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading[type] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.downloadQuranError)),
        );
      }
    }
  }
}
