import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/assets.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../data/models/prophet_name.dart';

class ProphetPage extends StatefulWidget {
  const ProphetPage({super.key});

  @override
  State<ProphetPage> createState() => _ProphetPageState();
}

class _ProphetPageState extends State<ProphetPage> {
  late Future<List<ProphetName>> _namesFuture;

  @override
  void initState() {
    super.initState();
    _namesFuture = _loadNames();
  }

  Future<List<ProphetName>> _loadNames() async {
    final String response = await rootBundle.loadString(
      Assets.prophetNamesJson,
    );
    final Map<String, dynamic> jsonResponse = json.decode(response);
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => ProphetName.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.strings.prophetNames,
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProphetName>>(
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
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: names.length,
            itemBuilder: (context, index) {
              return _ProphetNameCard(name: names[index]);
            },
          );
        },
      ),
    );
  }
}

class _ProphetNameCard extends StatelessWidget {
  final ProphetName name;

  const _ProphetNameCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: Text(
          name.name,
          style: AppTextStyles.notoKufiArabicHeading20.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
