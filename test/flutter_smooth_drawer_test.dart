import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_smooth_drawer/flutter_smooth_drawer.dart';

void main() {
  _menuPanelTests();
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

void _menuPanelTests() {
  testWidgets('the menu panel sits on the side the drawer uncovers',
      (tester) async {
    Future<Alignment> alignmentFor(TextDirection direction) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: SmoothHiddenDrawer(
              menu: const SmoothDrawerMenuPanel(
                width: 200,
                child: SizedBox.shrink(),
              ),
              mainScreen: const SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      return tester
          .widget<AnimatedAlign>(find.byType(AnimatedAlign))
          .alignment as Alignment;
    }

    expect(await alignmentFor(TextDirection.ltr), Alignment.centerLeft);
    expect(await alignmentFor(TextDirection.rtl), Alignment.centerRight);
  });

  testWidgets('the panel glides rather than snapping across a direction change',
      (tester) async {
    Widget app(TextDirection direction) => Directionality(
          textDirection: direction,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: SmoothHiddenDrawer(
              animationDuration: const Duration(milliseconds: 600),
              menu: const SmoothDrawerMenuPanel(
                width: 200,
                child: SizedBox.expand(),
              ),
              mainScreen: const SizedBox.shrink(),
            ),
          ),
        );

    await tester.pumpWidget(app(TextDirection.ltr));
    await tester.pumpAndSettle();
    final start = tester.getTopLeft(find.byType(SizedBox).first).dx;

    await tester.pumpWidget(app(TextDirection.rtl));
    await tester.pump(const Duration(milliseconds: 300));
    final middle = tester.getTopLeft(find.byType(SizedBox).first).dx;

    await tester.pumpAndSettle();
    final end = tester.getTopLeft(find.byType(SizedBox).first).dx;

    expect(end, greaterThan(start), reason: 'the panel changed side');
    expect(
      middle,
      allOf(greaterThan(start), lessThan(end)),
      reason: 'mid-transition it is between the two sides, not at either',
    );
  });
}
