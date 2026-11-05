import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../quran/domain/entities/qirat_type.dart';
import '../../../../quran/presentation/bloc/quran_bloc.dart';
import '../../../../quran/presentation/bloc/quran_event.dart';
import 'quran_qirat_card_widget.dart';
import 'quran_tab_header_widget.dart';

class QuranTabView extends StatefulWidget {
  const QuranTabView({super.key});

  @override
  State<QuranTabView> createState() => _QuranTabViewState();
}

class _QuranTabViewState extends State<QuranTabView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuranBloc>().add(const CheckQuranAssetStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          const QuranTabHeaderWidget(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: QiratType.values.length,
              separatorBuilder: (_, __) => 12.ver,
              itemBuilder: (context, index) {
                final qirat = QiratType.values[index];
                return QuranQiratCardWidget(qirat: qirat);
              },
            ),
          ),
        ],
      ),
    );
  }
}
