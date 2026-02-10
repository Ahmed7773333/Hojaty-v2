import 'package:flutter/material.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class ServiceData {
  final String label;
  final String assetPath;
  final String routeName;

  ServiceData({
    required this.label,
    required this.assetPath,
    required this.routeName,
  });
}

class ServicesGridWidget extends StatelessWidget {
  const ServicesGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Defined using a getter or inside build to access context for localization
    final List<ServiceData> services = [
      ServiceData(
        label: context.strings.allah_names,
        assetPath: Assets.allahNames,
        routeName: AppRoutes.allahNames,
      ),
      ServiceData(
        label: context.strings.azkar,
        assetPath: Assets.azkar,
        routeName: AppRoutes.azkar,
      ),
      // ServiceData(
      //   label: context.strings.duaas,
      //   assetPath: Assets.duaas,
      //   routeName: AppRoutes.duaas,
      // ),
      ServiceData(
        label: context.strings.prophet,
        assetPath: Assets.prophet,
        routeName: AppRoutes.prophet,
      ),
      ServiceData(
        label: context.strings.prophets_stories,
        assetPath: Assets.prophetsStories,
        routeName: AppRoutes.prophetsStories,
      ),
      ServiceData(
        label: context.strings.qibla,
        assetPath: Assets.qibla,
        routeName: AppRoutes.qibla,
      ),
      // ServiceData(
      //   label: context.strings.ramadan,
      //   assetPath: Assets.ramdan,
      //   routeName: AppRoutes.ramadan,
      // ),
      ServiceData(
        label: context.strings.sebhaTitle,
        assetPath: Assets.tasbeh,
        routeName: AppRoutes.sebha,
      ),
      ServiceData(
        label: context.strings.ahadith,
        assetPath: Assets.ahadith,
        routeName: AppRoutes.ahadith,
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
        context.pushNamed(service.routeName);
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
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
