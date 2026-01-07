import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/assets.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/services/json_data_service.dart';
import '../../data/models/hadith.dart';
import '../widgets/hadith_empty_view.dart';
import '../widgets/hadith_error_view.dart';
import '../widgets/hadith_list.dart';
import '../widgets/hadith_results_count.dart';
import '../widgets/hadith_search_bar.dart';

class AhadithPage extends StatefulWidget {
  const AhadithPage({super.key});

  @override
  State<AhadithPage> createState() => _AhadithPageState();
}

class _AhadithPageState extends State<AhadithPage> {
  late Future<List<Hadith>> _hadithFuture;
  List<Hadith> _allHadith = [];
  List<Hadith> _filteredHadith = [];
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _hadithFuture = _loadHadith();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<List<Hadith>> _loadHadith() async {
    final String response = await injector<JsonDataService>().loadString(
      Assets.hadithJsonKey,
    );
    // Offload parsing to a background isolate
    final hadithList = await compute(_parseHadith, response);

    if (mounted) {
      _allHadith = hadithList;
      _filteredHadith = hadithList;
    }
    return hadithList;
  }

  // Static function for compute to call
  static List<Hadith> _parseHadith(String response) {
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Hadith.fromJson(json)).toList();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = query;
        if (query.isEmpty) {
          _filteredHadith = _allHadith;
        } else {
          _filteredHadith = _allHadith.where((hadith) {
            final q = query.toLowerCase();
            return hadith.searchTerm.toLowerCase().contains(q) ||
                hadith.hadith.toLowerCase().contains(q) ||
                hadith.number.toString().contains(q);
          }).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          context.strings.ahadith,
          style: AppTextStyles.notoKufiArabicHeading24.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Hadith>>(
        future: _hadithFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return HadithErrorView(error: snapshot.error);
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return HadithEmptyView(message: context.strings.no_hadith_found);
          }

          return Column(
            children: [
              HadithSearchBar(onChanged: _onSearchChanged),
              if (_searchQuery.isNotEmpty)
                HadithResultsCount(count: _filteredHadith.length),
              Expanded(
                child: _filteredHadith.isEmpty
                    ? HadithEmptyView(
                        message: context.strings.no_hadith_found,
                        icon: Icons.search_off_rounded,
                      )
                    : HadithList(hadiths: _filteredHadith),
              ),
            ],
          );
        },
      ),
    );
  }
}
