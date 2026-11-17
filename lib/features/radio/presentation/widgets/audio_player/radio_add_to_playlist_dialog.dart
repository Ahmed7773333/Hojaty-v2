import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/radio/data/models/playlist_item_model.dart';
import 'package:hojaty/features/radio/data/models/playlist_model.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:hojaty/features/radio/presentation/bloc/radio_event.dart';
import 'package:flutter/material.dart';

class RadioAddToPlaylistDialog extends StatefulWidget {
  final List<PlaylistModel> playlists;
  final PlaylistItemModel item;
  final RadioBloc radioBloc;

  const RadioAddToPlaylistDialog({
    super.key,
    required this.playlists,
    required this.item,
    required this.radioBloc,
  });

  @override
  State<RadioAddToPlaylistDialog> createState() =>
      _RadioAddToPlaylistDialogState();
}

class _RadioAddToPlaylistDialogState extends State<RadioAddToPlaylistDialog> {
  late final TextEditingController _newPlaylistController;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _newPlaylistController = TextEditingController();
  }

  @override
  void dispose() {
    _newPlaylistController.dispose();
    super.dispose();
  }

  void _onAddToPlaylist(String playlistId) {
    widget.radioBloc.add(
      AddToPlaylistEvent(playlistId: playlistId, item: widget.item),
    );
    context.pop();
  }

  void _onCreateAndAdd() {
    final name = _newPlaylistController.text.trim();
    if (name.isEmpty) return;

    widget.radioBloc.add(CreatePlaylistEvent(name));
    widget.radioBloc.add(
      AddToPlaylistEvent(playlistId: name, item: widget.item),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final customPlaylists = widget.playlists.where((p) => !p.isSystem).toList();

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        context.strings.addToPlaylist,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isCreating)
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.accentGold,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    context.strings.newPlaylistTitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => setState(() => _isCreating = true),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newPlaylistController,
                          autofocus: true,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: context.strings.playlistNameHint,
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.check_rounded,
                          color: AppColors.accentGold,
                        ),
                        onPressed: _onCreateAndAdd,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _isCreating = false),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              if (customPlaylists.isEmpty && !_isCreating)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    context.strings.noSurahsInPlaylist,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ...customPlaylists.map((playlist) {
                final isInPlaylist = playlist.items.any(
                  (i) =>
                      i.surahId == widget.item.surahId &&
                      i.reciterName == widget.item.reciterName,
                );

                return ListTile(
                  leading: const Icon(
                    Icons.playlist_play_rounded,
                    color: AppColors.accentGold,
                  ),
                  title: Text(
                    playlist.name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${playlist.items.length} ${context.strings.listenToSurah}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  trailing: isInPlaylist
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.accentGold,
                        )
                      : null,
                  onTap: () => _onAddToPlaylist(playlist.id),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
