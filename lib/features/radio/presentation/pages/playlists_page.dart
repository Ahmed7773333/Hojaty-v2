import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/playlist_model.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../widgets/playlists/create_playlist_dialog.dart';
import '../widgets/playlists/playlist_card_widget.dart';
import '../widgets/playlists/playlists_header_widget.dart';

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
    context.pushNamed(
      AppRoutes.playlistDetails,
      extra: playlist,
    );
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
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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

