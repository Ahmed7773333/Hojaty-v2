import 'package:equatable/equatable.dart';
import 'athkar_category_model.dart';
import 'thikr_item_model.dart';

class AthkarDetailArgs extends Equatable {
  final String title;
  final List<ThikrItemModel> items;
  final AthkarCategoryType? categoryType;
  final int? categoryId;

  const AthkarDetailArgs({
    required this.title,
    this.items = const [],
    this.categoryType,
    this.categoryId,
  });

  @override
  List<Object?> get props => [title, items, categoryType, categoryId];
}
