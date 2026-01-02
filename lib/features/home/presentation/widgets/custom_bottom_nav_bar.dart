import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(CupertinoIcons.home),
          selectedIcon: const Icon(CupertinoIcons.house_fill),
          label: context.strings.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.radio_outlined),
          selectedIcon: const Icon(Icons.radio),
          label: context.strings.radio,
        ),
        // NavigationDestination(
        //   icon: const Icon(Icons.menu_book_outlined),
        //   selectedIcon: const Icon(Icons.menu_book),
        //   label: context.strings.azkar,
        // ),
        NavigationDestination(
          icon: const Icon(CupertinoIcons.settings),
          selectedIcon: const Icon(CupertinoIcons.settings_solid),
          label: context.strings.settings,
        ),
      ],
    );
  }
}
