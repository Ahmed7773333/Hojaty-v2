import 'package:flutter/material.dart';

class ReciterInfoWidget extends StatelessWidget {
  final String reciterName;
  final String surahNameEn;
  final String surahNameAr;

  const ReciterInfoWidget({
    super.key,
    required this.reciterName,
    required this.surahNameEn,
    required this.surahNameAr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder or actual image if we had one
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.mic_external_on_rounded,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          surahNameAr, // Main title Arabic
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Noto Kufi Arabic', // Ensuring nice font
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          reciterName,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
