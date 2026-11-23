import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/utils/snackbar_helper.dart';
import 'package:hojaty/features/quran/data/datasources/quran_checkpoint_local_data_source.dart';
import 'package:hojaty/features/quran/data/models/quran_checkpoint_model.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_checkpoint_card_widget.dart';
import 'package:hojaty/features/quran/presentation/widgets/quran_checkpoints_empty_widget.dart';

class QuranCheckpointsPage extends StatefulWidget {
  const QuranCheckpointsPage({super.key});

  @override
  State<QuranCheckpointsPage> createState() => _QuranCheckpointsPageState();
}

class _QuranCheckpointsPageState extends State<QuranCheckpointsPage> {
  final QuranCheckpointLocalDataSource _dataSource =
      injector<QuranCheckpointLocalDataSource>();
  List<QuranCheckpointModel> _checkpoints = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCheckpoints();
  }

  Future<void> _loadCheckpoints() async {
    final list = await _dataSource.getAll();
    if (!mounted) return;
    setState(() {
      _checkpoints = list;
      _isLoading = false;
    });
  }

  Future<void> _deleteCheckpoint(QuranCheckpointModel checkpoint) async {
    await _dataSource.remove(checkpoint.id);
    if (!mounted) return;
    setState(() {
      _checkpoints.removeWhere((c) => c.id == checkpoint.id);
    });
    SnackbarHelper.showSuccess(
      context,
      message: context.strings.bookmarkRemoved,
    );
  }

  void _onCheckpointTap(QuranCheckpointModel checkpoint) {
    final result = {
      'pageNum': checkpoint.pageNumber,
      'verseIndex': checkpoint.verseIndex,
    };
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    } else {
      context.pushNamed(AppRoutes.quranReader, extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          context.strings.quranCheckpoints,
          style: context.textTheme.titleLarge?.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                ),
              )
            : _checkpoints.isEmpty
                ? const QuranCheckpointsEmptyWidget()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    itemCount: _checkpoints.length,
                    itemBuilder: (context, index) {
                      final checkpoint = _checkpoints[index];
                      return QuranCheckpointCardWidget(
                        checkpoint: checkpoint,
                        onTap: () => _onCheckpointTap(checkpoint),
                        onDelete: () => _deleteCheckpoint(checkpoint),
                      );
                    },
                  ),
      ),
    );
  }
}

