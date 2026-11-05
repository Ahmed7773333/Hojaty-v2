import 'package:flutter/material.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/local_notification_service.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/onboarding_mock_data.dart';
import '../../data/models/onboarding_item_model.dart';
import '../widgets/onboarding_actions_widget.dart';
import '../widgets/onboarding_slide_widget.dart';
import '../widgets/onboarding_top_bar_widget.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final List<OnboardingItemModel> _items = OnboardingMockData.items;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    final user = UserHiveHelper.getUser();
    if (user != null) {
      user.onBoardingCompletedSetter = true;
    }
    await LocalNotificationService.requestPermission();
    if (!mounted) return;
    context.pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLastSlide = _currentIndex == _items.length - 1;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            12.ver,
            OnboardingTopBarWidget(
              count: _items.length,
              currentIndex: _currentIndex,
              onSkip: _completeOnboarding,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingSlideWidget(item: _items[index]);
                },
              ),
            ),
            OnboardingActionsWidget(
              isLastSlide: isLastSlide,
              onNext: _onNext,
              onSkipAll: _completeOnboarding,
            ),
            20.ver,
          ],
        ),
      ),
    );
  }
}
