import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_sample/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: const MyApp()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNWidgets(3));
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));

    await tester.tap(find.byIcon(CupertinoIcons.minus));
    await tester.tap(find.byIcon(CupertinoIcons.minus));
    await tester.pump();
    expect(find.text('-1'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
