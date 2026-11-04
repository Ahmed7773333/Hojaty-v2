import 'package:equatable/equatable.dart';
import 'thikr_item_model.dart';

enum AthkarCategoryType {
  morning,
  evening,
  sleep,
  afterPrayer,
  misc,
  sebha,
  istikhara,
}

class AthkarCategoryModel extends Equatable {
  final AthkarCategoryType type;
  final String Function(dynamic s) titleResolver;
  final int count;
  final bool isGuide;
  final int? categoryId;
  final List<ThikrItemModel>? items;

  const AthkarCategoryModel({
    required this.type,
    required this.titleResolver,
    this.count = 0,
    this.isGuide = false,
    this.categoryId,
    this.items,
  });

  AthkarCategoryModel copyWith({
    AthkarCategoryType? type,
    String Function(dynamic s)? titleResolver,
    int? count,
    bool? isGuide,
    int? categoryId,
    List<ThikrItemModel>? items,
  }) {
    return AthkarCategoryModel(
      type: type ?? this.type,
      titleResolver: titleResolver ?? this.titleResolver,
      count: count ?? this.count,
      isGuide: isGuide ?? this.isGuide,
      categoryId: categoryId ?? this.categoryId,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [type, count, isGuide, categoryId, items];
}

// ==========================================
// ARCHIVED ORIGINAL ATHKAR CATEGORY MODEL CODE
// ==========================================
// class AthkarCategoryModel extends Equatable {
//   final AthkarCategoryType type;
//   final String Function(dynamic s) titleResolver;
//   final int count;
//   final bool isGuide;
// 
//   const AthkarCategoryModel({
//     required this.type,
//     required this.titleResolver,
//     this.count = 0,
//     this.isGuide = false,
//   });
// 
//   @override
//   List<Object?> get props => [type, count, isGuide];
// }

