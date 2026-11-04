import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/settings_mock_data.dart';
import '../widgets/prayer_times/location_selection_card_widget.dart';
import '../widgets/settings/settings_page_header_widget.dart';

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  String _selectedCity = 'القاهرة، مصر';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cities = SettingsMockData.cities;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          SettingsPageHeaderWidget(
            title: context.strings.locationSettingsTitle,
            subtitle: context.strings.locationSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: LocationSelectionCardWidget(
                cities: cities,
                selectedCity: _selectedCity,
                onSelect: (city) => setState(() => _selectedCity = city),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
