import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hifz/domain/utils/global_ayah_mapper.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_hub_cubit.dart';
import 'package:hojaty/features/hifz/presentation/cubits/hifz_session_cubit.dart';
import 'package:hojaty/features/hifz/presentation/widgets/hifz_surah_picker_dropdown.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:hojaty/shared/widgets/custom_elevated_button.dart';
import 'package:material_ui/material_ui.dart';

class TrackSetupSheet extends StatefulWidget {
  final bool isQuickLoop;

  const TrackSetupSheet({
    super.key,
    this.isQuickLoop = false,
  });

  @override
  State<TrackSetupSheet> createState() => _TrackSetupSheetState();
}

class _TrackSetupSheetState extends State<TrackSetupSheet> {
  final TextEditingController _titleController = TextEditingController();
  int _selectedSurahId = 67;
  int _startAyah = 1;
  int _endAyah = 5;
  int _dailyTarget = 5;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _endAyah = GlobalAyahMapper.surahAyahCount(_selectedSurahId).clamp(1, 30);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSurahChanged(int surahId) {
    final maxAyah = GlobalAyahMapper.surahAyahCount(surahId);
    setState(() {
      _selectedSurahId = surahId;
      _startAyah = 1;
      _endAyah = widget.isQuickLoop ? maxAyah.clamp(1, 10) : maxAyah;
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final startGlobal = GlobalAyahMapper.toGlobalAyahId(
      _selectedSurahId,
      _startAyah,
    );
    final endGlobal = GlobalAyahMapper.toGlobalAyahId(
      _selectedSurahId,
      _endAyah,
    );
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final surahInfo = QuranConstants.surahMap[_selectedSurahId];
    final defaultTitle = isArabic
        ? 'حفظ سورة ${surahInfo?.name ?? ''}'
        : 'Memorize ${surahInfo?.englishName ?? ''}';

    if (widget.isQuickLoop) {
      await context.read<HifzSessionCubit>().startSession(
            startGlobalAyah: startGlobal,
            endGlobalAyah: endGlobal,
            isArabic: isArabic,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      context.pushNamed(AppRoutes.hifzStudio);
      return;
    }

    final customTitle = _titleController.text.trim().isEmpty
        ? defaultTitle
        : _titleController.text.trim();

    await context.read<HifzHubCubit>().createCustomPlan(
          title: customTitle,
          surahId: _selectedSurahId,
          startGlobalAyah: startGlobal,
          endGlobalAyah: endGlobal,
          dailyTargetAyahs: _dailyTarget,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final maxAyah = GlobalAyahMapper.surahAyahCount(_selectedSurahId);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        20.w,
        20.h + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.isQuickLoop
                    ? context.strings.hifzQuickLoopTitle
                    : context.strings.hifzCustomPlan,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              14.ver,
              if (!widget.isQuickLoop) ...[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: context.strings.hifzPlanTitleLabel,
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkCardUnselected
                        : AppColors.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
                12.ver,
              ],
              HifzSurahPickerDropdown(
                selectedSurahId: _selectedSurahId,
                onChanged: _onSurahChanged,
              ),
              12.ver,
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _startAyah,
                      decoration: InputDecoration(
                        labelText: context.strings.hifzFromAyah,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      items: [
                        for (int a = 1; a <= maxAyah; a++)
                          DropdownMenuItem(value: a, child: Text('$a')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _startAyah = v;
                          if (_endAyah < _startAyah) _endAyah = _startAyah;
                        });
                      },
                    ),
                  ),
                  12.hor,
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _endAyah,
                      decoration: InputDecoration(
                        labelText: context.strings.hifzToAyah,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      items: [
                        for (int a = _startAyah; a <= maxAyah; a++)
                          DropdownMenuItem(value: a, child: Text('$a')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _endAyah = v);
                      },
                    ),
                  ),
                ],
              ),
              if (!widget.isQuickLoop) ...[
                12.ver,
                Row(
                  children: [
                    Text(
                      context.strings.hifzDailyTargetLabel,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _dailyTarget > 1
                          ? () => setState(() => _dailyTarget--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                    ),
                    Text(
                      '$_dailyTarget',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: _dailyTarget < 30
                          ? () => setState(() => _dailyTarget++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                  ],
                ),
              ],
              18.ver,
              CustomElevatedButton(
                text: widget.isQuickLoop
                    ? context.strings.hifzStartQuickLoopAction
                    : context.strings.hifzCreatePlanAction,
                isLoading: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

