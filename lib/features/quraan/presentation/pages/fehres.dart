import 'package:flutter/material.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
// Removed QuraanBloc imports as they are no longer needed for navigation result pattern

class FehrsPage extends StatefulWidget {
  const FehrsPage({super.key});

  @override
  State<FehrsPage> createState() => _FehrsPageState();
}

class _FehrsPageState extends State<FehrsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        title: Text(
          context.strings.surahs,
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.secondaryColor,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            itemBuilder: (BuildContext context, int index) {
              final surah = AppConstants.surahMap[index + 1]!;
              return FadeTransition(
                opacity: _animation,
                child: Card(
                  color: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: const BorderSide(
                      color: AppColor.secondaryColor,
                      width: 1.4,
                    ),
                  ),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: () {
                      Navigator.pop(context, surah.pageNumber);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            surah.pageNumber.toString(),
                            style: AppTextStyles.notoKufiArabicHeading20
                                .copyWith(color: Colors.black87),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                surah.name,
                                style: AppTextStyles.notoKufiArabicHeading20,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '${context.strings.itsNumber}: ${surah.number}  ${context.strings.ayat}: ${surah.ayahCount}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8.h);
            },
            itemCount: 114,
          ),
        ),
      ),
    );
  }
}
