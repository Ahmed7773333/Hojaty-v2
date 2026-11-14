import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/settings_mock_data.dart';
import '../bloc/homelayout_bloc.dart';
import '../bloc/homelayout_event.dart';
import '../widgets/prayer_times/current_location_button_widget.dart';
import '../widgets/prayer_times/location_selection_card_widget.dart';
import '../widgets/settings/settings_page_header_widget.dart';

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});

  @override
  State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  bool _isLocating = false;

  void _onSelectCity(BuildContext context, String city) {
    final coords = SettingsMockData.getCityCoordinates(city);
    context.read<HomelayoutBloc>().add(
      SelectPrayerCityEvent(
        cityName: city,
        coordinates: coords,
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _onDetectCurrentLocation(BuildContext context) async {
    setState(() => _isLocating = true);
    context.read<HomelayoutBloc>().add(
      const CheckLocationUpdateEvent(force: true),
    );
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLocating = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cities = SettingsMockData.cities;
    final currentCity = context.select(
      (HomelayoutBloc bloc) => bloc.state.prayerCityName,
    );

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
              child: Column(
                children: [
                  CurrentLocationButtonWidget(
                    isLoading: _isLocating,
                    onTap: () => _onDetectCurrentLocation(context),
                  ),
                  LocationSelectionCardWidget(
                    cities: cities,
                    selectedCity: currentCity.isNotEmpty ? currentCity : cities.first,
                    onSelect: (city) => _onSelectCity(context, city),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
