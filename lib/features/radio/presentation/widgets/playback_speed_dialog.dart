import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Shows a dialog for selecting playback speed
void showPlaybackSpeedDialog({
  required BuildContext context,
  required void Function(double speed) onSpeedSelected,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return SimpleDialog(
        title: Text(context.strings.playback_speed),
        children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
          return SimpleDialogOption(
            onPressed: () {
              onSpeedSelected(speed);
              Navigator.pop(dialogContext);
            },
            child: Text("${speed}x"),
          );
        }).toList(),
      );
    },
  );
}
