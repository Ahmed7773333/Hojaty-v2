import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../data/models/allah_name.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../../../core/constants/assets.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/services/json_data_service.dart';

class AllahNamesPage extends StatefulWidget {
  const AllahNamesPage({super.key});

  @override
  State<AllahNamesPage> createState() => _AllahNamesPageState();
}

class _AllahNamesPageState extends State<AllahNamesPage> {
  late Future<List<AllahName>> _namesFuture;

  @override
  void initState() {
    super.initState();
    _namesFuture = _loadNames();
  }

  Future<List<AllahName>> _loadNames() async {
    final String response = await injector<JsonDataService>().loadString(
      Assets.allahNamesJsonKey,
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => AllahName.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.allah_names,
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AllahName>>(
        future: _namesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No names found'));
          }

          final names = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: names.length,
            itemBuilder: (context, index) {
              return _NameCard(name: names[index]);
            },
          );
        },
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final AllahName name;

  const _NameCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showNameDetails(context, name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name.name,
              style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${name.id}',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDetails(BuildContext context, AllahName name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name.name,
                style: AppTextStyles.notoKufiArabicHeading24.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                height: 2,
                width: 50,
                color: context.colors.secondary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                name.text,
                style: AppTextStyles.notoKufiArabicBody13Medium.copyWith(
                  height: 1.8,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.strings.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
