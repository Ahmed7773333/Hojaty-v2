import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../../../data/mocks/athkar_mock_data.dart';
import '../../../data/datasources/local/athkar_local_data_source.dart';
import '../../../data/models/athkar_category_model.dart';
import '../../../data/models/athkar_detail_args.dart';
import 'athkar_header_widget.dart';
import 'athkar_main_content_widget.dart';
import 'athkar_search_bar_widget.dart';
import 'athkar_search_results_widget.dart';

class AthkarGridView extends StatefulWidget {
  const AthkarGridView({super.key});

  @override
  State<AthkarGridView> createState() => _AthkarGridViewState();
}

class _AthkarGridViewState extends State<AthkarGridView> {
  final TextEditingController _searchController = TextEditingController();
  final AthkarLocalDataSource _dataSource = const AthkarLocalDataSource();

  List<AthkarCategoryModel> _dailyCategories = AthkarMockData.categories;
  List<AthkarCategoryModel> _allCategories = const [];
  List<AthkarCategoryModel> _filteredCategories = const [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final daily = await _dataSource.getDailyCategories();
    final all = await _dataSource.getAllCategories();
    if (!mounted) return;
    setState(() {
      _dailyCategories = daily;
      _allCategories = all;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _filteredCategories = const [];
      } else {
        final queryLower = _searchQuery.toLowerCase();
        _filteredCategories = _allCategories.where((category) {
          final title = category.titleResolver(context.strings).toLowerCase();
          return title.contains(queryLower);
        }).toList();
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _onCategoryTap(AthkarCategoryModel category) {
    if (category.type == AthkarCategoryType.sebha) {
      context.pushNamed(AppRoutes.sebha);
    } else if (category.isGuide) {
      context.pushNamed(AppRoutes.istikhara);
    } else {
      context.pushNamed(
        AppRoutes.athkarDetail,
        extra: AthkarDetailArgs(
          title: category.titleResolver(context.strings),
          items: category.items ?? const [],
          categoryType: category.type,
          categoryId: category.categoryId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          const AthkarHeaderWidget(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
            child: AthkarSearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: _onClearSearch,
            ),
          ),
          Expanded(
            child: isSearching
                ? AthkarSearchResultsWidget(
                    results: _filteredCategories,
                    onCategoryTap: _onCategoryTap,
                    onClear: _onClearSearch,
                  )
                : AthkarMainContentWidget(
                    dailyCategories: _dailyCategories,
                    allCategories: _allCategories,
                    onCategoryTap: _onCategoryTap,
                  ),
          ),
        ],
      ),
    );
  }
}
