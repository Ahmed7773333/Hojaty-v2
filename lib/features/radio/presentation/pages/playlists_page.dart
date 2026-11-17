import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/di/injector.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/data/models/playlist_model.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_event.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_state.dart';
import 'package:hojaty/features/radio/presentation/widgets/playlists/create_playlist_dialog.dart';
import 'package:hojaty/features/radio/presentation/widgets/playlists/playlist_card_widget.dart';
import 'package:hojaty/features/radio/presentation/widgets/playlists/playlists_header_widget.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  late final RadioBloc _radioBloc;

  @override
  void initState() {
    super.initState();
    _radioBloc = injector<RadioBloc>();
    _radioBloc.add(const LoadPlaylistsEvent());
  }

  void _onOpenCreateDialog() {
    context.showDialogRoute(
      builder: CreatePlaylistDialog(
        onCreate: (name) => _radioBloc.add(CreatePlaylistEvent(name)),
      ),
    );
  }

  void _onOpenPlaylist(PlaylistModel playlist) {
    context.pushNamed(AppRoutes.playlistDetails, extra: playlist);
  }

  void _onDeletePlaylist(String playlistId) {
    _radioBloc.add(DeletePlaylistEvent(playlistId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BlocProvider.value(
      value: _radioBloc,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Column(
          children: [
            PlaylistsHeaderWidget(
              onBack: () => context.pop(),
              onCreateNew: _onOpenCreateDialog,
            ),
            Expanded(
              child: BlocBuilder<RadioBloc, RadioState>(
                builder: (context, state) {
                  final playlists = state.playlists;
                  if (playlists.isEmpty) {
                    return Center(
                      child: Text(
                        context.strings.noSurahsInPlaylist,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount: playlists.length,
                    separatorBuilder: (_, __) => 12.ver,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return PlaylistCardWidget(
                        playlist: playlist,
                        onTap: () => _onOpenPlaylist(playlist),
                        onDelete: playlist.isSystem
                            ? null
                            : () => _onDeletePlaylist(playlist.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
