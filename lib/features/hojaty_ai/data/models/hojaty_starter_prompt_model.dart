import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

class HojatyStarterPromptModel extends Equatable {
  final String label;
  final String prompt;
  final IconData icon;
  final bool isAction;

  const HojatyStarterPromptModel({
    required this.label,
    required this.prompt,
    required this.icon,
    this.isAction = false,
  });

  @override
  List<Object?> get props => [label, prompt, icon, isAction];
}
