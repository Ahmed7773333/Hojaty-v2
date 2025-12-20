import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hojaty/features/home/presentation/pages/home_layout.dart';
import 'package:hojaty/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('HomeLayout shows 4 navigation tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: HomeLayout(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    // Verify bottom nav bar exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify 4 tabs exist (by icon or text)
    // Texts might not be found if they are not selected or hidden slightly differently,
    // but icons should be there.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Radio'), findsOneWidget);
    expect(find.text('Azkar'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
