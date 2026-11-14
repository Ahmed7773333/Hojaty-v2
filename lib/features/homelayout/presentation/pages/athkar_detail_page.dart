import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/athkar_mock_data.dart';
import '../../data/models/athkar_category_model.dart';
import '../../data/models/thikr_item_model.dart';
import '../widgets/athkar/athkar_completed_card_widget.dart';
import '../widgets/athkar/athkar_detail_header_widget.dart';
import '../widgets/athkar/athkar_segmented_progress_widget.dart';
import '../widgets/athkar/thikr_page_content_widget.dart';

class AthkarDetailPage extends StatefulWidget {
  final String title;
  final List<ThikrItemModel>? items;
  final AthkarCategoryType? categoryType;
  final AthkarCategoryModel? categoryModel;

  const AthkarDetailPage({
    super.key,
    required this.title,
    this.items,
    this.categoryType,
    this.categoryModel,
  });

  @override
  State<AthkarDetailPage> createState() => _AthkarDetailPageState();
}

class _AthkarDetailPageState extends State<AthkarDetailPage> {
  late List<ThikrItemModel> _items;
  late List<int> _counts;
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isAdvancing = false;

  @override
  void initState() {
    super.initState();
    _initItems();
    _counts = List<int>.filled(_items.length, 0);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initItems() {
    if (widget.items != null && widget.items!.isNotEmpty) {
      _items = List.from(widget.items!);
      return;
    }

    final type = widget.categoryType ?? widget.categoryModel?.type;
    switch (type) {
      case AthkarCategoryType.morning:
        _items = AthkarMockData.morningAthkar;
        break;
      case AthkarCategoryType.evening:
        _items = AthkarMockData.eveningAthkar;
        break;
      case AthkarCategoryType.sleep:
        _items = AthkarMockData.sleepAthkar;
        break;
      case AthkarCategoryType.afterPrayer:
        _items = AthkarMockData.afterPrayerAthkar;
        break;
      case AthkarCategoryType.misc:
        _items = AthkarMockData.miscAthkar;
        break;
      default:
        _items = AthkarMockData.morningAthkar;
        break;
    }
  }

  String _resolveTitle(BuildContext context) {
    if (widget.title.isNotEmpty) {
      return widget.title;
    }
    if (widget.categoryModel != null) {
      return widget.categoryModel!.titleResolver(context.strings);
    }
    return context.strings.morningAthkar;
  }

  bool get _areAllItemsCompleted {
    if (_items.isEmpty) return false;
    for (int i = 0; i < _items.length; i++) {
      if (_counts[i] < _items[i].requiredCount) {
        return false;
      }
    }
    return true;
  }

  void _onTapCounter(int index) {
    if (_isAdvancing || _items.isEmpty) return;
    if (index < 0 || index >= _items.length) return;

    final currentThikr = _items[index];
    if (_counts[index] < currentThikr.requiredCount) {
      setState(() {
        _counts[index]++;
      });

      if (_counts[index] >= currentThikr.requiredCount) {
        _isAdvancing = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          _isAdvancing = false;
          if (_currentIndex == index) {
            if (_areAllItemsCompleted) {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  _items.length,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            } else if (index < _items.length) {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  index + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }
          }
        });
      }
    }
  }

  void _onPrevious() {
    if (_currentIndex > 0 && _pageController.hasClients) {
      final prevIndex = _currentIndex - 1;
      setState(() {
        _currentIndex = prevIndex;
      });
      _pageController.animateToPage(
        prevIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNext() {
    if (_currentIndex < _items.length && _pageController.hasClients) {
      final nextIndex = _currentIndex + 1;
      setState(() {
        _currentIndex = nextIndex;
      });
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onReset(int index) {
    if (index < 0 || index >= _counts.length) return;
    setState(() {
      _counts[index] = 0;
    });
  }

  void _onRestartAll() {
    setState(() {
      _currentIndex = 0;
      _counts = List<int>.filled(_items.length, 0);
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final title = _resolveTitle(context);

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Center(child: Text(title, style: context.textTheme.titleMedium)),
      );
    }

    final displayIndex =
        _currentIndex < _items.length ? _currentIndex + 1 : _items.length;
    final segmentIndex =
        _currentIndex < _items.length ? _currentIndex : _items.length - 1;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          AthkarDetailHeaderWidget(
            title: title,
            currentIndex: displayIndex,
            totalCount: _items.length,
          ),
          AthkarSegmentedProgressWidget(
            totalSegments: _items.length,
            currentSegmentIndex: segmentIndex,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length + 1,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: AthkarCompletedCardWidget(
                        onRestart: _onRestartAll,
                        onDone: () => context.pop(),
                      ),
                    ),
                  );
                }

                final currentThikr = _items[index];
                final currentCount = _counts[index];
                final isCompleted = currentCount >= currentThikr.requiredCount;

                return ThikrPageContentWidget(
                  thikr: currentThikr,
                  currentCount: currentCount,
                  isCompleted: isCompleted,
                  hasPrevious: index > 0,
                  hasNext: true,
                  onTapCounter: () => _onTapCounter(index),
                  onPrevious: _onPrevious,
                  onNext: _onNext,
                  onReset: () => _onReset(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ARCHIVED ORIGINAL ATHKAR DETAIL PAGE CODE
// ==========================================
// class AthkarDetailPage extends StatefulWidget {
//   final String title;
//
//   const AthkarDetailPage({
//     super.key,
//     required this.title,
//   });
//
//   @override
//   State<AthkarDetailPage> createState() => _AthkarDetailPageState();
// }
//
// class _AthkarDetailPageState extends State<AthkarDetailPage> {
//   final List<ThikrItemModel> _items = AthkarMockData.sampleMorningAthkar;
//   int _currentIndex = 0;
//   int _currentCount = 0;
//   bool _isAdvancing = false;
//
//   void _onTapCounter() {
//     if (_isAdvancing) return;
//
//     final currentThikr = _items[_currentIndex];
//     if (_currentCount < currentThikr.requiredCount) {
//       setState(() {
//         _currentCount++;
//       });
//
//       if (_currentCount >= currentThikr.requiredCount) {
//         _isAdvancing = true;
//         Future.delayed(const Duration(milliseconds: 600), () {
//           if (!mounted) return;
//           if (_currentIndex < _items.length - 1) {
//             setState(() {
//               _currentIndex++;
//               _currentCount = 0;
//               _isAdvancing = false;
//             });
//           } else {
//             _isAdvancing = false;
//           }
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = context.isDark;
//     final currentThikr = _items[_currentIndex];
//     final isCompleted = _currentCount >= currentThikr.requiredCount;
//
//     return Scaffold(
//       backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
//       body: Column(
//         children: [
//           AthkarDetailHeaderWidget(
//             title: widget.title,
//             currentIndex: _currentIndex + 1,
//             totalCount: _items.length,
//           ),
//           AthkarSegmentedProgressWidget(
//             totalSegments: _items.length,
//             currentSegmentIndex: _currentIndex,
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(vertical: 8.h),
//               child: Column(
//                 children: [
//                   12.ver,
//                   ThikrTextCardWidget(thikr: currentThikr),
//                   16.ver,
//                   ThikrRequirementCardWidget(
//                     requiredCount: currentThikr.requiredCount,
//                     currentCount: _currentCount,
//                   ),
//                   40.ver,
//                   ThikrCounterButtonWidget(
//                     currentCount: _currentCount,
//                     isCompleted: isCompleted,
//                     onTap: _onTapCounter,
//                   ),
//                   30.ver,
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
