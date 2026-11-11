import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../bloc/hojaty_ai_cubit.dart';
import '../bloc/hojaty_ai_state.dart';
import '../widgets/hojaty_ai_empty_state_widget.dart';
import '../widgets/hojaty_ai_header_widget.dart';
import '../widgets/hojaty_ai_input_bar_widget.dart';
import '../widgets/hojaty_ai_messages_list_widget.dart';

class HojatyAiPage extends StatelessWidget {
  const HojatyAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HojatyAiCubit>(
      create: (_) => injector<HojatyAiCubit>(),
      child: const _HojatyAiBody(),
    );
  }
}

class _HojatyAiBody extends StatelessWidget {
  const _HojatyAiBody();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const HojatyAiHeaderWidget(),
          Expanded(
            child: BlocBuilder<HojatyAiCubit, HojatyAiState>(
              builder: (context, state) {
                if (state.messages.isEmpty && !state.isStreaming) {
                  return HojatyAiEmptyStateWidget(
                    onSelectStarter: (starterPrompt) {
                      context.read<HojatyAiCubit>().sendMessage(starterPrompt);
                    },
                  );
                }

                return HojatyAiMessagesListWidget(
                  messages: state.messages,
                  isStreaming: state.isStreaming,
                  streamingText: state.currentStreamingText,
                  currentSources: state.currentSources,
                );
              },
            ),
          ),
          BlocBuilder<HojatyAiCubit, HojatyAiState>(
            buildWhen: (prev, curr) => prev.isStreaming != curr.isStreaming,
            builder: (context, state) {
              return HojatyAiInputBarWidget(
                isStreaming: state.isStreaming,
                onSend: (text) {
                  context.read<HojatyAiCubit>().sendMessage(text);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
