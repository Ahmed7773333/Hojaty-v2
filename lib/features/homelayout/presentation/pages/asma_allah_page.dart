import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/datasources/local/athkar_local_data_source.dart';
import '../../data/models/asma_allah_model.dart';
import '../widgets/asma_allah/asma_allah_empty_widget.dart';
import '../widgets/asma_allah/asma_allah_header_widget.dart';
import '../widgets/asma_allah/asma_allah_list_widget.dart';
import '../widgets/asma_allah/asma_allah_search_bar_widget.dart';

class AsmaAllahPage extends StatefulWidget {
  const AsmaAllahPage({super.key});

  @override
  State<AsmaAllahPage> createState() => _AsmaAllahPageState();
}

class _AsmaAllahPageState extends State<AsmaAllahPage> {
  final TextEditingController _searchController = TextEditingController();
  final AthkarLocalDataSource _dataSource = const AthkarLocalDataSource();

  List<AsmaAllahModel> _allNames = const [];
  List<AsmaAllahModel> _filteredNames = const [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final names = await _dataSource.getAsmaAllah();
    if (!mounted) return;
    setState(() {
      _allNames = names;
      _filteredNames = names;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _filteredNames = _allNames;
      } else {
        final q = _searchQuery.toLowerCase();
        _filteredNames = _allNames.where((item) {
          return item.arabic.contains(q) ||
              item.transliteration.toLowerCase().contains(q) ||
              item.arMeaning.contains(q) ||
              item.arExplanation.contains(q) ||
              item.enExplanation.toLowerCase().contains(q) ||
              item.enMeaning.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          AsmaAllahHeaderWidget(totalCount: _allNames.length),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
            child: AsmaAllahSearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _onClearSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark ? AppColors.accentGold : AppColors.primaryDark,
                    ),
                  )
                : (_filteredNames.isEmpty
                    ? AsmaAllahEmptyWidget(onClear: _onClearSearch)
                    : AsmaAllahListWidget(items: _filteredNames)),
          ),
        ],
      ),
    );
  }
}

