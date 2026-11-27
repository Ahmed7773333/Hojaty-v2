import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/app_action_dispatcher.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_cubit.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_state.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_asset_download_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_empty_state_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_header_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_input_bar_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_messages_list_widget.dart';

class HojatyAiPage extends StatelessWidget {
  const HojatyAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HojatyAiCubit>(
      create: (_) => injector<HojatyAiCubit>()..init(),
      child: const _HojatyAiRoot(),
    );
  }
}

class _HojatyAiRoot extends StatelessWidget {
  const _HojatyAiRoot();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HojatyAiCubit, HojatyAiState>(
      buildWhen: (prev, curr) => prev.assetStatus != curr.assetStatus,
      builder: (context, state) {
        if (state.assetStatus == HojatyAiAssetStatus.ready) {
          return const _HojatyAiBody();
        }
        return const HojatyAiAssetDownloadWidget();
      },
    );
  }
}

class _HojatyAiBody extends StatefulWidget {
  const _HojatyAiBody();

  @override
  State<_HojatyAiBody> createState() => _HojatyAiBodyState();
}

class _HojatyAiBodyState extends State<_HojatyAiBody> {
  StreamSubscription<AppActionNavigationEvent>? _navSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<HojatyAiCubit>();
      _navSub = cubit.navigationEvents.listen((event) {
        if (!mounted) return;
        context.pushNamed(event.routeName, extra: event.arguments);
      });
    });
  }

  @override
  void dispose() {
    _navSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: Column(
          children: [
            const HojatyAiHeaderWidget(),
          Expanded(
            child: BlocBuilder<HojatyAiCubit, HojatyAiState>(
              builder: (context, state) {
                final localeCode = Localizations.localeOf(context).languageCode;
                if (state.messages.isEmpty && !state.isStreaming) {
                  return HojatyAiEmptyStateWidget(
                    onSelectStarter: (starterPrompt) {
                      context.read<HojatyAiCubit>().sendMessage(
                            starterPrompt,
                            localeCode: localeCode,
                          );
                    },
                  );
                }

                return HojatyAiMessagesListWidget(
                  messages: state.messages,
                  isStreaming: state.isStreaming,
                  processingStage: state.processingStage,
                  streamingText: state.currentStreamingText,
                  currentSources: state.currentSources,
                );
              },
            ),
          ),
          BlocBuilder<HojatyAiCubit, HojatyAiState>(
            buildWhen: (prev, curr) => prev.isStreaming != curr.isStreaming,
            builder: (context, state) {
              final localeCode = Localizations.localeOf(context).languageCode;
              return HojatyAiInputBarWidget(
                isStreaming: state.isStreaming,
                onSend: (text) {
                  context.read<HojatyAiCubit>().sendMessage(
                        text,
                        localeCode: localeCode,
                      );
                },
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}
