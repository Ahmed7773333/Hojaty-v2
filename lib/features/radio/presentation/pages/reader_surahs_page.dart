import 'package:flutter/material.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/readers_response.dart';
import 'surah_audio_page.dart';

class ReaderSurahsPage extends StatelessWidget {
  final Reciters reciter;

  const ReaderSurahsPage({super.key, required this.reciter});

  @override
  Widget build(BuildContext context) {
    // Assuming the first moshaf is the main one we want to use for now.
    // In a full implementation, we might let the user choose the Moshaf type (Warsh, Hafs, etc.)
    final moshaf = reciter.moshaf?.isNotEmpty == true
        ? reciter.moshaf!.first
        : null;
    final serverUrl = moshaf?.server;
    final availableSurahIds = moshaf?.surahList?.split(',') ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(reciter.name ?? "Reader")),
      body: moshaf == null
          ? const Center(child: Text("No Moshaf available"))
          : ListView.builder(
              itemCount: availableSurahIds.length,
              itemBuilder: (context, index) {
                // surahList contains numbers like "1,2,3...". We need to map these to our SurahsList
                final surahIdStr = availableSurahIds[index];
                final surahNumber = int.tryParse(surahIdStr);

                if (surahNumber == null) return const SizedBox.shrink();

                // Find local Surah data to get Names
                final surah = SurahsList.all.firstWhere(
                  (s) => s.number == surahNumber,
                  orElse: () => const Surah('000', 0, "Unknown", "Unknown"),
                );

                if (surah.number == 0) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${surah.number}")),
                    title: Text(
                      surah.nameEn,
                    ), // Use localized version based on app lang
                    subtitle: Text(surah.nameAr),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: () {
                      if (serverUrl != null) {
                        context.push(
                          SurahAudioPage(
                            surah: surah,
                            serverUrl: serverUrl,
                            reciterName: reciter.name ?? "",
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
