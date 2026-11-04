import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/playlist_item_model.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/surah_audio_args.dart';
import '../../services/radio_download_service.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../widgets/playlist_details/playlist_details_header_widget.dart';
import '../widgets/playlist_details/playlist_surah_tile_widget.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final PlaylistModel playlist;

  const PlaylistDetailsPage({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  late final RadioBloc _radioBloc;

  @override
  void initState() {
    super.initState();
    _radioBloc = injector<RadioBloc>();
    _radioBloc.add(const LoadPlaylistsEvent());
  }

  void _onPlaySurah(PlaylistItemModel item) {
    context.pushNamed(
      AppRoutes.surahAudio,
      extra: SurahAudioArgs(
        surahNumber: item.surahId,
        surahNameAr: item.surahNameAr,
        surahNameEn: item.surahNameEn,
        reciterName: item.reciterName,
        reciterLetter: item.reciterLetter,
        serverUrl: item.serverUrl,
        reciterId: item.reciterId,
      ),
    );
  }

  void _onRemoveItem(PlaylistItemModel item) {
    if (widget.playlist.id == 'downloads_playlist') {
      injector<RadioDownloadService>().deleteDownloadedSurah(
        item.reciterName,
        item.surahId,
      );
    }
    _radioBloc.add(
      RemoveFromPlaylistEvent(
        playlistId: widget.playlist.id,
        surahId: item.surahId,
        reciterName: item.reciterName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isFavorites = widget.playlist.id == 'favorites_playlist';
    final isDownloads = widget.playlist.id == 'downloads_playlist';

    final String displayName;
    if (isFavorites) {
      displayName = context.strings.favorites;
    } else if (isDownloads) {
      displayName = context.strings.downloadedAudios;
    } else {
      displayName = widget.playlist.name;
    }

    final emptyText = isDownloads
        ? context.strings.noDownloadsYet
        : context.strings.noSurahsInPlaylist;

    return BlocProvider.value(
      value: _radioBloc,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: BlocBuilder<RadioBloc, RadioState>(
          builder: (context, state) {
            final currentPlaylist = state.playlists.firstWhere(
              (p) => p.id == widget.playlist.id,
              orElse: () => widget.playlist,
            );
            final items = currentPlaylist.items;

            return Column(
              children: [
                PlaylistDetailsHeaderWidget(
                  title: displayName,
                  count: items.length,
                  onBack: () => context.pop(),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            emptyText,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => 8.ver,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return PlaylistSurahTileWidget(
                              item: item,
                              onTap: () => _onPlaySurah(item),
                              onRemove: () => _onRemoveItem(item),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

