import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/azkar_models.dart';
import '../../data/repositories/book_repository.dart';

class DuaasPage extends StatelessWidget {
  const DuaasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.duaas,
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DuaaCategory>>(
        future: injector<BookRepository>().getDuaas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                context.strings.errorMessage(snapshot.error.toString()),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(context.strings.no_duaas_found));
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
                            _DuaaDetailsPage(category: category),
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

class _DuaaDetailsPage extends StatelessWidget {
  final DuaaCategory category;

  const _DuaaDetailsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.category)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: category.duaa.length,
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final duaaText = category.duaa[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.colors.primary.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  duaaText,
                  style: AppTextStyles.hafsSmartStyle.copyWith(
                    fontSize: 22,
                    height: 1.8,
                    color: context.colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
              if (category.source != null) ...[
                const SizedBox(height: 8),
                if (category.source!.quran != null &&
                    category.source!.quran!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${context.strings.source}: ${category.source!.quran!.map((s) => "${s.surah.name} (${context.strings.ayat}: ${s.ayah.from}${(s.ayah.to != s.ayah.from) ? '-${s.ayah.to}' : ''})").join(", ")}',
                      style: TextStyle(
                        color: context.colors.secondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                // Handle Hadith source if needed, complex structure.
              ],
            ],
          );
        },
      ),
    );
  }
}
