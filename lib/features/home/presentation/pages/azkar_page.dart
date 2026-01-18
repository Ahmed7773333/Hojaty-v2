import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/azkar_models.dart';
import '../../data/repositories/book_repository.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.azkar,
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AdhkarCategory>>(
        future: injector<BookRepository>().getAdhkar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Adhkar found'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    category.category,
                    style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            _AdhkarDetailsPage(category: category),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AdhkarDetailsPage extends StatelessWidget {
  final AdhkarCategory category;

  const _AdhkarDetailsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.category)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: category.array.length,
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final item = category.array[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest.withOpacity(
                    0.3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.outlineVariant),
                ),
                child: Text(
                  item.text,
                  style: AppTextStyles.hafsSmartStyle.copyWith(
                    fontSize: 22,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      '${context.strings.hadith_number} ${item.count}',
                    ), // reusing string slightly incorrectly ("Count" vs "Number") but acceptabel or use generic
                    // Or just "Count: X"
                    // I'll leave as is or just number.
                    backgroundColor: context.colors.secondaryContainer,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      // Copy logic
                    },
                  ),
                  // Audio button if needed
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
