import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/data/models/live_stream_args.dart';
import 'package:hojaty/features/radio/services/radio_audio_player_service.dart';
import 'package:hojaty/features/radio/presentation/widgets/live_stream/live_stream_header_widget.dart';
import 'package:hojaty/features/radio/presentation/widgets/live_stream/live_stream_player_card.dart';

class LiveStreamPage extends StatefulWidget {
  final LiveStreamArgs args;

  const LiveStreamPage({super.key, required this.args});

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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
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
