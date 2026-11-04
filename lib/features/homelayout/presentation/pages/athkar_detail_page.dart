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
import '../widgets/athkar/thikr_counter_button_widget.dart';
import '../widgets/athkar/thikr_nav_controls_widget.dart';
import '../widgets/athkar/thikr_requirement_card_widget.dart';
import '../widgets/athkar/thikr_text_card_widget.dart';

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
  int _currentIndex = 0;
  int _currentCount = 0;
  bool _isAdvancing = false;
  bool _isAllCompleted = false;

  @override
  void initState() {
    super.initState();
    _initItems();
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

  void _onTapCounter() {
    if (_isAdvancing || _isAllCompleted || _items.isEmpty) return;

    final currentThikr = _items[_currentIndex];
    if (_currentCount < currentThikr.requiredCount) {
      setState(() {
        _currentCount++;
      });

      if (_currentCount >= currentThikr.requiredCount) {
        _isAdvancing = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          if (_currentIndex < _items.length - 1) {
            setState(() {
              _currentIndex++;
              _currentCount = 0;
              _isAdvancing = false;
            });
          } else {
            setState(() {
              _isAdvancing = false;
              _isAllCompleted = true;
            });
          }
        });
      }
    }
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentCount = 0;
        _isAllCompleted = false;
      });
    }
  }

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _currentCount = 0;
        _isAllCompleted = false;
      });
    }
  }

  void _onReset() {
    setState(() {
      _currentCount = 0;
      _isAllCompleted = false;
    });
  }

  void _onRestartAll() {
    setState(() {
      _currentIndex = 0;
      _currentCount = 0;
      _isAllCompleted = false;
    });
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

    final currentThikr = _items[_currentIndex];
    final isCompleted = _currentCount >= currentThikr.requiredCount;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          AthkarDetailHeaderWidget(
            title: title,
            currentIndex: _currentIndex + 1,
            totalCount: _items.length,
          ),
          AthkarSegmentedProgressWidget(
            totalSegments: _items.length,
            currentSegmentIndex: _currentIndex,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: _isAllCompleted
                  ? AthkarCompletedCardWidget(
                      onRestart: _onRestartAll,
                      onDone: () => context.pop(),
                    )
                  : Column(
                      children: [
                        12.ver,
                        ThikrTextCardWidget(thikr: currentThikr),
                        16.ver,
                        ThikrRequirementCardWidget(
                          requiredCount: currentThikr.requiredCount,
                          currentCount: _currentCount,
                        ),
                        32.ver,
                        ThikrCounterButtonWidget(
                          currentCount: _currentCount,
                          isCompleted: isCompleted,
                          onTap: _onTapCounter,
                        ),
                        24.ver,
                        ThikrNavControlsWidget(
                          hasPrevious: _currentIndex > 0,
                          hasNext: _currentIndex < _items.length - 1,
                          onPrevious: _onPrevious,
                          onNext: _onNext,
                          onReset: _onReset,
                        ),
                        20.ver,
                      ],
                    ),
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
