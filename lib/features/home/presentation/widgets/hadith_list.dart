import 'package:flutter/material.dart';
import '../../data/models/hadith.dart';
import 'hadith_card.dart';

class HadithList extends StatelessWidget {
  final List<Hadith> hadiths;

  const HadithList({super.key, required this.hadiths});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        return HadithCard(hadith: hadiths[index]);
      },
    );
  }
}
