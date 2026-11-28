import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/data/models/reciter_registry.dart';
import 'package:hojaty/features/hifz/domain/entities/reciter.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_state.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_storage_surah_tile.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_surah_picker_dropdown.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class AudioStorageSheet extends StatefulWidget {
  const AudioStorageSheet({super.key});

  @override
  State<AudioStorageSheet> createState() => _AudioStorageSheetState();
}

class _AudioStorageSheetState extends State<AudioStorageSheet> {
  int _selectedSurahId = 67;
  Reciter _selectedReciter = ReciterRegistry.husaryMuallim;

  @override
  void initState() {
    super.initState();
    _selectedReciter = context.read<HifzSessionCubit>().state.reciter;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      constraints: BoxConstraints(maxHeight: 0.82.sh),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<HifzHubCubit, HifzHubState>(
          builder: (context, state) {
            final hubCubit = context.read<HifzHubCubit>();
            final sessionState = context.watch<HifzSessionCubit>().state;
            final mb =
                (state.totalCachedBytes / (1024 * 1024)).toStringAsFixed(1);
            final isDownloading = state.downloadingSurahId != null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.strings.hifzStorageTitle,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => hubCubit.clearTemporaryCache(),
                      child: Text(context.strings.hifzClearTempCache),
                    ),
                  ],
                ),
                4.ver,
                Text(
                  context.strings.hifzTotalCachedSize(mb),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                14.ver,
                DropdownButtonFormField<String>(
                  initialValue: _selectedReciter.id,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  items: ReciterRegistry.all
                      .map(
                        (r) => DropdownMenuItem(
                          value: r.id,
                          child: Text(r.localizedName(isArabic)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (id) {
                    if (id != null) {
                      setState(
                        () => _selectedReciter = ReciterRegistry.byId(id),
                      );
                    }
                  },
                ),
                10.ver,
                HifzSurahPickerDropdown(
                  selectedSurahId: _selectedSurahId,
                  onChanged: (id) => setState(() => _selectedSurahId = id),
                ),
                12.ver,
                if (isDownloading) ...[
                  LinearProgressIndicator(
                    value: state.surahDownloadProgress,
                    color: AppColors.accentGold,
                  ),
                  8.ver,
                  OutlinedButton(
                    onPressed: hubCubit.cancelSurahDownload,
                    child: Text(context.strings.cancel),
                  ),
                ] else
                  CustomElevatedButton(
                    text: context.strings.hifzDownloadSurah,
                    height: 44.h,
                    borderRadius: 14.r,
                    onPressed: () => hubCubit.downloadSurahForOffline(
                      reciter: _selectedReciter,
                      surahId: _selectedSurahId,
                      quality: sessionState.audioQuality,
                    ),
                  ),
                16.ver,
                Flexible(
                  child: state.cachedSurahSummaries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Text(
                              context.strings.hifzNoCachedSurahs,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.cachedSurahSummaries.length,
                          separatorBuilder: (_, _) => 8.ver,
                          itemBuilder: (context, index) {
                            final summary = state.cachedSurahSummaries[index];
                            return HifzStorageSurahTile(
                              summary: summary,
                              onDelete: () => hubCubit.deleteSurahCache(
                                summary.reciterId,
                                summary.surahId,
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

