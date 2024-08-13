import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecco/ecco.dart';

void main() {
  group('EccoDebugOverlay', () {
    testWidgets('renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EccoDebugOverlay(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('toggle overlay visibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EccoDebugOverlay(
            child: Container(),
          ),
        ),
      );

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(ListView), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('diagnostic test for overlay content', (
      WidgetTester tester,
    ) async {
      final testNotifier1 = EccoNotifier<int>(0);
      final testNotifier2 = EccoNotifier<String>('test');

      await tester.pumpWidget(
        MaterialApp(
          home: EccoProvider<int>(
            notifier: testNotifier1,
            child: EccoProvider<String>(
              notifier: testNotifier2,
              child: EccoDebugOverlay(
                child: Container(),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      debugDumpApp();

      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsAtLeastNWidgets(1));

      tester.widgetList<Text>(textWidgets).forEach((widget) {
        debugPrint('Found Text widget with data: ${widget.data}');
      });

      final listTiles = find.byType(ListTile);

      debugPrint('Number of ListTiles found: ${listTiles.evaluate().length}');

      if (listTiles.evaluate().isEmpty) {
        debugPrint('ListTiles not found, checking for alternative widgets:');
        debugPrint(
          'Container widgets: ${find.byType(Container).evaluate().length}',
        );
        debugPrint('Card widgets: ${find.byType(Card).evaluate().length}');
        debugPrint('Column widgets: ${find.byType(Column).evaluate().length}');
      }

      expect(find.textContaining('int'), findsAtLeastNWidgets(1));
      expect(find.textContaining('String'), findsAtLeastNWidgets(1));
      expect(find.textContaining('0'), findsAtLeastNWidgets(1));
      expect(find.textContaining('test'), findsAtLeastNWidgets(1));
    });
  });
}
