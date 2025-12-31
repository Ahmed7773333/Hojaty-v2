import 'package:flutter/material.dart';
import '../../../../core/constants/surahs_list.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/readers_response.dart';
import 'surah_audio_page.dart';

class ReaderSurahsPage extends StatefulWidget {
  final Reciters reciter;

  const ReaderSurahsPage({super.key, required this.reciter});

  @override
  State<ReaderSurahsPage> createState() => _ReaderSurahsPageState();
}

class _ReaderSurahsPageState extends State<ReaderSurahsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredSurahIds = [];
  List<String> _allSurahIds = [];
  String? _serverUrl;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  void _initializeData() {
    final moshaf = widget.reciter.moshaf?.isNotEmpty == true
        ? widget.reciter.moshaf!.first
        : null;
    _serverUrl = moshaf?.server;
    _allSurahIds = moshaf?.surahList?.split(',') ?? [];
    _filteredSurahIds = _allSurahIds;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahIds = _allSurahIds;
      } else {
        _filteredSurahIds = _allSurahIds.where((surahIdStr) {
          final surahNumber = int.tryParse(surahIdStr);
          if (surahNumber == null) return false;

          final surah = SurahsList.all.firstWhere(
            (s) => s.number == surahNumber,
            orElse: () => const Surah('000', 0, "Unknown", "Unknown"),
          );

          if (surah.number == 0) return false;

          return surah.nameEn.toLowerCase().contains(query) ||
              surah.nameAr.contains(query) ||
              surah.number.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reciter.name ?? "Reader")),
      body: _serverUrl == null
          ? const Center(child: Text("No Moshaf available"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: context.strings.search ?? "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredSurahIds.isEmpty
                      ? const Center(child: Text("No surahs found"))
                      : ListView.builder(
                          itemCount: _filteredSurahIds.length,
                          itemBuilder: (context, index) {
                            final surahIdStr = _filteredSurahIds[index];
                            final surahNumber = int.tryParse(surahIdStr);

                            if (surahNumber == null)
                              return const SizedBox.shrink();

                            final surah = SurahsList.all.firstWhere(
                              (s) => s.number == surahNumber,
                              orElse: () =>
                                  const Surah('000', 0, "Unknown", "Unknown"),
                            );

                            if (surah.number == 0)
                              return const SizedBox.shrink();

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text("${surah.number}"),
                                ),
                                title: Text(
                                  surah.nameEn,
                                ), // Use localized version based on app lang
                                subtitle: Text(surah.nameAr),
                                trailing: const Icon(Icons.play_arrow),
                                onTap: () {
                                  if (_serverUrl != null) {
                                    context.push(
                                      SurahAudioPage(
                                        surah: surah,
                                        serverUrl: _serverUrl!,
                                        reciterName: widget.reciter.name ?? "",
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
