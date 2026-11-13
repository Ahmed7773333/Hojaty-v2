import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/qibla_bloc.dart';
import '../bloc/qibla_event.dart';
import '../bloc/qibla_state.dart';
import 'qibla_app_bar_widget.dart';
import 'qibla_compass_dial_widget.dart';
import 'qibla_guidance_card_widget.dart';
import 'qibla_location_info_card_widget.dart';
import 'qibla_manual_slider_widget.dart';
import 'qibla_status_banner_widget.dart';
import 'qibla_tilt_warning_widget.dart';

class QiblaPageView extends StatelessWidget {
  const QiblaPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          const QiblaAppBarWidget(),
          Expanded(
            child: BlocBuilder<QiblaBloc, QiblaState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    children: [
                      8.ver,
                      QiblaTiltWarningWidget(
                        isLevel: state.isLevel,
                        pitch: state.pitch,
                        roll: state.roll,
                      ),
                      QiblaStatusBannerWidget(
                        isAligned: state.isAligned,
                        isClose: state.isClose,
                        offsetToQibla: state.offsetToQibla,
                      ),
                      16.ver,
                      QiblaCompassDialWidget(
                        heading: state.smoothHeading,
                        qiblaBearing: state.qiblaBearing,
                        isAligned: state.isAligned,
                        hasSensor: state.hasSensor,
                      ),
                      16.ver,
                      QiblaLocationInfoCardWidget(
                        cityName: state.cityName,
                        distanceKm: state.distanceKm,
                        qiblaBearing: state.qiblaBearing,
                        heading: state.heading,
                        accuracy: state.accuracy,
                        hasSensor: state.hasSensor,
                      ),
                      QiblaGuidanceCardWidget(
                        accuracy: state.accuracy,
                        hasSensor: state.hasSensor,
                      ),
                      if (!state.hasSensor) ...[
                        QiblaManualSliderWidget(
                          heading: state.heading,
                          onHeadingChanged: (val) {
                            context.read<QiblaBloc>().add(
                              ManualHeadingChangedEvent(val),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

