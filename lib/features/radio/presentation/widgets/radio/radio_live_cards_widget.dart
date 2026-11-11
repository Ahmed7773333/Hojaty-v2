// import 'package:hojaty/config/routes/app_router.dart';
// import 'package:hojaty/core/utils/extensions/context_extensions.dart';
// import 'package:hojaty/core/utils/screen_util_like.dart';
// import 'package:hojaty/features/radio/data/models/live_stream_args.dart';
// import 'package:flutter/material.dart';
// import 'radio_live_card_item.dart';

// class RadioLiveCardsWidget extends StatelessWidget {
//   const RadioLiveCardsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: RadioLiveCardItem(
//             title: context.strings.makkahLive,
//             imagePath: 'assets/images/makka.jpg',
//             onTap: () {
//               context.pushNamed(
//                 AppRoutes.liveStream,
//                 extra: LiveStreamArgs(
//                   title: context.strings.makkahLive,
//                   imagePath: 'assets/images/makka.jpg',
//                   streamUrl: 'https://backup.qurango.net/radio/makkah',
//                 ),
//               );
//             },
//           ),
//         ),
//         12.hor,
//         Expanded(
//           child: RadioLiveCardItem(
//             title: context.strings.madinahLive,
//             imagePath: 'assets/images/madina.jpg',
//             onTap: () {
//               context.pushNamed(
//                 AppRoutes.liveStream,
//                 extra: LiveStreamArgs(
//                   title: context.strings.madinahLive,
//                   imagePath: 'assets/images/madina.jpg',
//                   streamUrl: 'https://backup.qurango.net/radio/tarteel',
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
