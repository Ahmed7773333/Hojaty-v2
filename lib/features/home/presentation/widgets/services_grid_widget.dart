import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../pages/ahadith_page.dart';
import '../pages/allah_names_page.dart';
import '../pages/azkar_page.dart';
import '../pages/duaas_page.dart';
import '../pages/prophet_page.dart';
import '../pages/prophets_stories_page.dart';
import '../pages/qibla_page.dart';
import '../pages/ramadan_page.dart';
import '../pages/sebha_page.dart';

class ServiceData {
  final String label;
  final String assetPath;
  final Widget destination;

  ServiceData({
    required this.label,
    required this.assetPath,
    required this.destination,
  });
}

class ServicesGridWidget extends StatelessWidget {
  const ServicesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Defined using a getter or inside build to access context for localization
    final List<ServiceData> services = [
      ServiceData(
        label: context.strings.azkar,
        assetPath: Assets.azkar,
        destination: const AzkarPage(),
      ),
      ServiceData(
        label: context.strings.duaas,
        assetPath: Assets.duaas,
        destination: const DuaasPage(),
      ),
      ServiceData(
        label: context.strings.prophet,
        assetPath: Assets.prophet,
        destination: const ProphetPage(),
      ),
      ServiceData(
        label: context.strings.prophets_stories,
        assetPath: Assets.prophetsStories,
        destination: const ProphetsStoriesPage(),
      ),
      ServiceData(
        label: context.strings.qibla,
        assetPath: Assets.qibla,
        destination: const QiblaPage(),
      ),
      ServiceData(
        label: context.strings.ramadan,
        assetPath: Assets.ramdan,
        destination: const RamadanPage(),
      ),
      ServiceData(
        label: context.strings.sebhaTitle,
        assetPath: Assets.tasbeh,
        destination: const SebhaPage(),
      ),
      ServiceData(
        label: context.strings.ahadith,
        assetPath: Assets.ahadith,
        destination: const AhadithPage(),
      ),
      ServiceData(
        label: context.strings.allah_names,
        assetPath: Assets.allahNames,
        destination: const AllahNamesPage(),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85, // Adjusted for image + text
      ),
      itemBuilder: (context, index) {
        return _ServiceItem(service: services[index]);
      },
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final ServiceData service;

  const _ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(service.destination);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(service.assetPath, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: Text(
                service.label,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
