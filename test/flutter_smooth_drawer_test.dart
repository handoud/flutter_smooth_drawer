import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_smooth_drawer/flutter_smooth_drawer.dart';

void main() {
  testWidgets('renders menu and main screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SmoothHiddenDrawer(
          menu: const Text('Menu'),
          mainScreen: const Text('Main'),
        ),
      ),
    );

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Main'), findsOneWidget);
  });

  testWidgets('controller toggles open state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SmoothHiddenDrawer(
          menu: const Text('Menu'),
          mainScreen: const Text('Main'),
        ),
      ),
    );

    final controller = SmoothHiddenDrawerController.of(
      tester.element(find.text('Main')),
    );

    expect(controller.isOpen, isFalse);
    controller.toggle();
    expect(controller.isOpen, isTrue);
    controller.close();
    expect(controller.isOpen, isFalse);
  });
}
