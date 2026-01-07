import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/theme/app_color.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/quraan_bloc.dart';
import '../bloc/quraan_event.dart';
import '../bloc/quraan_state.dart';
import '../../../../config/routes/app_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controll = TextEditingController();

  @override
  void dispose() {
    controll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: AppColor.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            textDirection: TextDirection.rtl,
            controller: controll,
            decoration: InputDecoration(
              hintText: context.strings.quranSearchHint,
              hintStyle: AppTextStyles.notoKufiArabicHeading20.copyWith(
                color: AppColor.secondaryColor,
              ),
              hintTextDirection: TextDirection.rtl,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            style: AppTextStyles.notoKufiArabicHeading20.copyWith(
              color: AppColor.secondaryColor,
            ),
            onChanged: (value) {
              context.read<QuraanBloc>().add(SearchQuraan(value));
            },
          ),
        ),
      ),
      body: BlocBuilder<QuraanBloc, QuraanState>(
        builder: (context, state) {
          final result = state.searchResults;

          if (result.isEmpty) {
            return Center(
              child: Text(
                context.strings.quranNoResults,
                style: AppTextStyles.notoKufiArabicHeading24.copyWith(
                  color: AppColor.secondaryColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            itemCount: result.length,
            itemBuilder: (context, index) {
              final res = result[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, res.pageNum);
                },
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: const BorderSide(
                      color: AppColor.secondaryColor,
                      width: 1.5,
                    ),
                  ),
                  color: AppColor.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          res.content,
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                          style: AppTextStyles.hafsSmartStyle.copyWith(),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                context.pushNamed(
                                  AppRoutes.tafseer,
                                  extra: {
                                    'content': res.tafseer,
                                    'pageNum': res.pageNum.toString(),
                                  },
                                );
                              },
                              child: Text(context.strings.quranTafseer),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  res.surahName,
                                  style: AppTextStyles.notoKufiArabicHeading20
                                      .copyWith(color: Colors.black),
                                ),
                                Text(
                                  '${context.strings.safha} ${res.pageNum}',
                                  style: AppTextStyles.notoKufiArabicHeading20
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
