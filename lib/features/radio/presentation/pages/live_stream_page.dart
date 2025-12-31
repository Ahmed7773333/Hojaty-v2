import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveStreamPage extends StatefulWidget {
  final String streamUrl;
  final String title;

  const LiveStreamPage({
    super.key,
    required this.streamUrl,
    required this.title,
  });

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.streamUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        isLive: true,
        autoPlay: true,
        forceHD: true,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        liveUIColor: Colors.red,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: Center(child: player),
        );
      },
    );
  }
}
