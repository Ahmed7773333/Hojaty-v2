import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class LocationCard extends StatelessWidget {
  final String cityName;

  const LocationCard({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on,
            color: context.colors.onSecondaryContainer,
          ),
        ),
        title: Text(context.strings.currentCity),
        subtitle: Text(
          cityName.isNotEmpty ? cityName : context.strings.unknown,
        ),
      ),
    );
  }
}
