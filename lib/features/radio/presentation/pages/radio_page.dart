import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../bloc/radio_bloc.dart';
import '../bloc/radio_event.dart';
import '../bloc/radio_state.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/live_card.dart';
import 'reader_surahs_page.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is available and safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = context.strings.localeName;
      context.read<RadioBloc>().add(LoadRadioEvent(language: locale));
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
      appBar: AppBar(title: Text(context.strings.radio)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LiveCard(
                          title: context.strings.madina_live,
                          imagePath: 'assets/images/madina.jpg',
                          streamUrl: AppConstants.madinaLiveStreamUrl,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: LiveCard(
                          title: context.strings.makkah_live,
                          imagePath: 'assets/images/makka.jpg',
                          streamUrl: AppConstants.makkahLiveStreamUrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Field
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText:
                          context.strings.quranSearch, // Reusing search key
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<RadioBloc>().add(SearchRecitersEvent(value));
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                context.strings.readers_list,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          BlocBuilder<RadioBloc, RadioState>(
            builder: (context, state) {
              if (state.status == RadioStatus.loading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == RadioStatus.error) {
                return SliverFillRemaining(
                  child: Center(child: Text(state.message)),
                );
              }

              if (state.filteredReciters.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No Reciters Found")),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final reciter = state.filteredReciters[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                        child: Text(reciter.letter ?? reciter.name?[0] ?? "?"),
                      ),
                      title: Text(
                        reciter.name ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.push(ReaderSurahsPage(reciter: reciter));
                      },
                    ),
                  );
                }, childCount: state.filteredReciters.length),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}
