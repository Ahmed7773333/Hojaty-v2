import 'package:flutter/material.dart';
import '../../data/models/playlist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final PlaylistModel playlist;

  const PlaylistDetailsScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RadioBloc>()..add(LoadPlaylistsEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(playlist.name)),
        body: BlocBuilder<RadioBloc, RadioState>(
          builder: (context, state) {
            // Find updated playlist from state to show real-time changes
            final currentPlaylist = state.playlists.firstWhere(
              (p) => p.id == playlist.id,
              orElse: () => state.downloadsPlaylist?.id == playlist.id
                  ? state.downloadsPlaylist!
                  : playlist,
            );

            if (currentPlaylist.items.isEmpty) {
              return Center(child: Text(context.strings.noSurahsInPlaylist));
            }

            return ListView.builder(
              itemCount: currentPlaylist.items.length,
              itemBuilder: (context, index) {
                final item = currentPlaylist.items[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(item.reciterLetter)),
                  title: Text(item.surahNameEn), // Could localize
                  subtitle: Text(item.reciterName),
                  onTap: () {
                    final surahIdStr = item.surahId.toString().padLeft(3, '0');
                    final surah = Surah(
                      surahIdStr,
                      item.surahId,
                      item.surahNameEn,
                      item.surahNameAr,
                    );

                    context.pushNamed(
                      AppRoutes.surahAudio,
                      extra: {
                        'surah': surah,
                        'serverUrl': item.serverUrl,
                        'reciterName': item.reciterName,
                      },
                    );
                  },
                  trailing:
                      (playlist.isSystem == true &&
                          playlist.id == 'downloads_playlist')
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<RadioBloc>().add(
                              RemoveFromPlaylistEvent(
                                playlistId: playlist.id,
                                item: item,
                              ),
                            );
                          },
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
