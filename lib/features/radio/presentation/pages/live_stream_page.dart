import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/live_stream_args.dart';
import '../../services/radio_audio_player_service.dart';
import '../widgets/live_stream/live_stream_header_widget.dart';
import '../widgets/live_stream/live_stream_player_card.dart';

class LiveStreamPage extends StatefulWidget {
  final LiveStreamArgs args;

  const LiveStreamPage({
    super.key,
    required this.args,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late final RadioAudioPlayerService _playerService;

  @override
  void initState() {
    super.initState();
    // ponytail: audio-only live stream, upgrade to video player when video streaming dependency is requested
    _playerService = injector<RadioAudioPlayerService>();
    _playerService.playUrl(
      url: widget.args.streamUrl,
      reciterName: widget.args.title,
    );
  }

  @override
  void dispose() {
    _playerService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          LiveStreamHeaderWidget(
            title: widget.args.title,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: LiveStreamPlayerCard(
                title: widget.args.title,
                imagePath: widget.args.imagePath,
                playerService: _playerService,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

