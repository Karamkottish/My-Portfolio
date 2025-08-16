import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karam_portfolio/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Adjust these expectations to whatever your app actually shows.
    expect(find.text('0'), findsOneWidget);

    // If your FAB has the default tooltip:
    // await tester.tap(find.byTooltip('Increment'));

    // Or if you have an add icon FAB:
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}
