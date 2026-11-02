import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:${templateOption:projectName}/app.dart';
import 'package:${templateOption:projectName}/features/home/home_page.dart';

void main() {
  testWidgets('home shows one card per tile', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(Card), findsNWidgets(HomePage.tiles.length));
    expect(find.text('Network'), findsOneWidget);
  });

  testWidgets('tapping a tile opens its page', (tester) async {
    await tester.pumpWidget(const App());

    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Camera'), findsOneWidget);
    expect(find.text('Nothing here yet'), findsOneWidget);
  });
}
