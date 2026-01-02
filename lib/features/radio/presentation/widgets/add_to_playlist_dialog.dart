import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/playlist_item.dart';
import '../../data/models/playlist_model.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';

/// Shows a dialog for adding a surah to a playlist
void showAddToPlaylistDialog({
  required BuildContext context,
  required List<PlaylistModel> playlists,
  required PlaylistItem item,
  required RadioBloc radioBloc,
}) {
  if (playlists.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.strings.no_playlists_available)),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(context.strings.add_to_playlist),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: playlists.length,
          itemBuilder: (dialogContext, index) {
            final playlist = playlists[index];
            // Skip system playlists except favorites
            if (playlist.isSystem == true &&
                playlist.id != 'favorites_playlist') {
              return const SizedBox.shrink();
            }
            if (playlist.id == 'favorites_playlist') {
              return const SizedBox.shrink();
            }

            return ListTile(
              title: Text(playlist.name),
              leading: const Icon(Icons.queue_music),
              onTap: () {
                radioBloc.add(
                  AddToPlaylistEvent(playlistId: playlist.id, item: item),
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.strings.added_to_playlist(playlist.name),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.cancel),
        ),
      ],
    ),
  );
}
