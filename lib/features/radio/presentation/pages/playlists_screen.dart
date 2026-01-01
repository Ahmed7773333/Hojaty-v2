import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/di/injector.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../../../../config/routes/app_router.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RadioBloc>()..add(LoadPlaylistsEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.strings.playlists)),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                _showCreatePlaylistDialog(context);
              },
              child: const Icon(Icons.add),
            );
          },
        ),
        body: BlocBuilder<RadioBloc, RadioState>(
          builder: (context, state) {
            if (state.playlistsStatus == PlaylistsStatus.loaded) {
              // Wait, RadioStatus? No, PlaylistsStatus.
              // Check RadioState definition. It has playlistsStatus field of type PlaylistsStatus.
              // Wait, previous code used state.playlistsStatus == PlaylistsStatus.loading.
              // Let's check RadioState definition again or assume it's correct.
              // The state file had `this.playlistsStatus = PlaylistsStatus.initial`.
              // So I should use PlaylistsStatus not RadioStatus for this field.
              if (state.playlistsStatus == PlaylistsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.playlistsStatus == PlaylistsStatus.error) {
                return Center(child: Text(state.playlistErrorMessage));
              }

              final playlists = state.playlists;
              final downloads = state.downloadsPlaylist;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Downloads Playlist
                  if (downloads != null)
                    _buildPlaylistCard(context, downloads, isDownloads: true),
                  const SizedBox(height: 16),

                  // User Playlists (including Favorites if it's in the list)
                  ...playlists.map((playlist) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildPlaylistCard(context, playlist),
                    );
                  }),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator()); // Fallback
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(
    BuildContext context,
    dynamic playlist, {
    bool isDownloads = false,
  }) {
    // playlist is PlaylistModel
    final String name = playlist.name;
    final String count = "${playlist.items.length} Surahs";
    final bool isSystem = isDownloads || (playlist.isSystem ?? false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          isDownloads
              ? Icons.download_done
              : (name == 'Favorites' ? Icons.favorite : Icons.queue_music),
          color: context.colors.primary,
          size: 32,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(count),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.pushNamed(AppRoutes.playlistDetails, extra: playlist);
        },
        onLongPress: !isSystem
            ? () {
                // Delete option for user playlists
                _showDeleteDialog(context, playlist);
              }
            : null,
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Playlist"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Playlist Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<RadioBloc>().add(
                  CreatePlaylistEvent(controller.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic playlist) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Playlist"),
        content: Text("Are you sure you want to delete ${playlist.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<RadioBloc>().add(DeletePlaylistEvent(playlist.id));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
