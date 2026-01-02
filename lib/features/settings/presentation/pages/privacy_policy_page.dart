import 'package:flutter/material.dart';
import '../../../../../../core/utils/extensions/context_extensions.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(context.strings.privacy_policy),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          context.strings.privacy_policy_text,
          style: context.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: context.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
