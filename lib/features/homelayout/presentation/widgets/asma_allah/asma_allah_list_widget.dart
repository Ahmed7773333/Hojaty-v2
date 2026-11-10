import 'package:flutter/material.dart';
import '../../../../../core/utils/screen_util_like.dart';
import '../../../data/models/asma_allah_model.dart';
import 'asma_allah_card_widget.dart';

class AsmaAllahListWidget extends StatelessWidget {
  final List<AsmaAllahModel> items;

  const AsmaAllahListWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => 10.ver,
      itemBuilder: (context, index) {
        final item = items[index];
        return AsmaAllahCardWidget(item: item);
      },
    );
  }
}

