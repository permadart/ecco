import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecco/ecco.dart';

class TestEquatable with Equatable {
  final int value;
  TestEquatable(this.value);
  @override
  List<Object?> get props => [value];
}

class TestViewModel extends EccoNotifier<int> {
  TestViewModel(super.initialValue);

  void increment() {
    ripple(state + 1);
  }
}

void main() {
  late List<String> logOutput;

  setUp(() {
    EccoDebug.instance.clearState();
    logOutput = [];
    Eccoes.setTestLogCallback((message) {
      logOutput.add(message);
    });
    Eccoes.enable();
    Eccoes.setLogLevel(EccoesLogLevel.info);
  });

  tearDown(() {
    Eccoes.setTestLogCallback(null);
    Eccoes.disable();
  });

  group('EccoNotifier', () {
    test('initial state is set correctly', () {
      final notifier = EccoNotifier<int>(5);
      expect(notifier.state, equals(5));
    });

    test('ripple updates state and notifies listeners', () {
      final notifier = EccoNotifier<int>(0);
      int callCount = 0;
      notifier.addListener(() {
        callCount++;
      });

      notifier.ripple(1);
      expect(notifier.state, equals(1));
      expect(callCount, equals(1));

      notifier.ripple(1);
      expect(notifier.state, equals(1));
      expect(
        callCount,
        equals(1),
        reason: 'Listener should not be called when state doesn\'t change',
      );
    });

    test('ripple with Equatable objects', () {
      final notifier = EccoNotifier<TestEquatable>(TestEquatable(0));
      int callCount = 0;
      notifier.addListener(() {
        callCount++;
      });

      notifier.ripple(TestEquatable(1));
      expect(notifier.state.value, equals(1));
      expect(callCount, equals(1));

      notifier.ripple(TestEquatable(1));
      expect(notifier.state.value, equals(1));
      expect(
        callCount,
        equals(1),
        reason: 'Listener should\'t be called when Equatable objects are equal',
      );

      notifier.ripple(TestEquatable(2));
      expect(notifier.state.value, equals(2));
      expect(callCount, equals(2));
    });

    test('ripple throws StateError after disposal', () {
      final notifier = EccoNotifier<int>(0);
      notifier.dispose();

      expect(
        () => notifier.ripple(2),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('EccoProvider', () {
    testWidgets('provides EccoNotifier to descendants', (
      WidgetTester tester,
    ) async {
      final notifier = EccoNotifier<int>(0);
      late EccoNotifier<int> capturedNotifier;

      await tester.pumpWidget(
        EccoProvider<int>(
          notifier: notifier,
          child: Builder(
            builder: (context) {
              capturedNotifier = EccoProvider.of<int>(context);
              return Container();
            },
          ),
        ),
      );

      expect(capturedNotifier, equals(notifier));
    });

    testWidgets('throws assertion error when provider is not found', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            return EccoBuilder<int>(
              builder: (_, __) => Container(),
            );
          },
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });
  });

  group('EccoBuilder', () {
    testWidgets('rebuilds when state changes', (
      WidgetTester tester,
    ) async {
      final notifier = EccoNotifier<int>(0);
      int buildCount = 0;

      await tester.pumpWidget(
        EccoProvider<int>(
          notifier: notifier,
          child: EccoBuilder<int>(
            builder: (context, state) {
              buildCount++;
              return Text('$state', textDirection: TextDirection.ltr);
            },
          ),
        ),
      );

      expect(buildCount, equals(1));
      expect(find.text('0'), findsOneWidget);

      notifier.ripple(1);
      await tester.pump();

      expect(buildCount, equals(2));
      expect(find.text('1'), findsOneWidget);
    });
  });

  group('EccoConsumer', () {
    testWidgets('provides state and notifier to builder', (
      WidgetTester tester,
    ) async {
      final notifier = TestViewModel(0);
      late int capturedState;
      late TestViewModel capturedNotifier;

      await tester.pumpWidget(
        EccoProvider<int>(
          notifier: notifier,
          child: EccoConsumer<int, TestViewModel>(
            builder: (context, state, viewModel) {
              capturedState = state;
              capturedNotifier = viewModel;
              return Container();
            },
          ),
        ),
      );

      expect(capturedState, equals(0));
      expect(capturedNotifier, equals(notifier));

      notifier.increment();
      await tester.pump();

      expect(capturedState, equals(1));
    });
  });

  group('Eccoes', () {
    test('logging can be enabled and disabled', () {
      Eccoes.log('Enabled message');
      expect(logOutput, contains('Ecco [INFO]: Enabled message'));

      Eccoes.disable();
      logOutput.clear();
      Eccoes.log('Disabled message');
      expect(logOutput, isEmpty);
    });

    test('logs message when attempting to update disposed notifier', () {
      final notifier = EccoNotifier<int>(0);
      notifier.dispose();

      expect(
        () => notifier.ripple(1),
        throwsA(isA<StateError>()),
      );

      expect(
        logOutput,
        contains(
          'Ecco [INFO]: EccoNotifier<int>: Attempted to update disposed notifier',
        ),
      );
    });

    test('respects log level settings', () {
      Eccoes.setLogLevel(EccoesLogLevel.warning);

      Eccoes.log('Debug message', level: EccoesLogLevel.debug);
      Eccoes.log('Info message', level: EccoesLogLevel.info);
      Eccoes.log('Warning message', level: EccoesLogLevel.warning);
      Eccoes.log('Error message', level: EccoesLogLevel.error);

      expect(logOutput, hasLength(2));
      expect(logOutput[0], contains('WARNING'));
      expect(logOutput[1], contains('ERROR'));
    });

    test('does not log when disabled', () {
      Eccoes.disable();

      Eccoes.log('This should not be logged');

      expect(logOutput, isEmpty);
    });
  });

  group('EccoDebug', () {
    setUp(() {
      EccoDebug.instance.clearState();
    });

    test('tracks notifiers through their lifecycle', () {
      final debug = EccoDebug.instance;

      expect(debug.getNotifiersData(), isEmpty);

      final notifier1 = EccoNotifier<int>(0);
      final notifier2 = EccoNotifier<String>('');

      var data = debug.getNotifiersData();
      expect(data.length, equals(2));
      expect(data.any((d) => d['type'] == 'int'), isTrue);
      expect(data.any((d) => d['type'] == 'String'), isTrue);

      notifier1.dispose();

      data = debug.getNotifiersData();
      expect(data.length, equals(1));
      expect(data.any((d) => d['type'] == 'String'), isTrue);

      notifier2.dispose();

      expect(debug.getNotifiersData(), isEmpty);
    });

    test('notifies listeners on state changes', () {
      final debug = EccoDebug.instance;
      final notifier = EccoNotifier<int>(0);
      int listenerCallCount = 0;

      debug.addListener(() {
        listenerCallCount++;
      });

      notifier.ripple(1);

      expect(listenerCallCount, equals(1));

      notifier.ripple(2);

      expect(listenerCallCount, equals(2));

      notifier.dispose();
    });
  });

  group('EccoNotifier with debug mode', () {
    test('logs state updates in debug mode', () {
      final notifier = EccoNotifier<int>(0);

      notifier.ripple(1);

      expect(
        logOutput,
        contains(
          'Ecco [INFO]: EccoNotifier<int>: State updated',
        ),
      );

      notifier.dispose();
    });

    test('logs attempts to access disposed notifier', () {
      final notifier = EccoNotifier<int>(0);
      notifier.dispose();

      expect(() => notifier.state, throwsStateError);
      expect(
        logOutput,
        contains(
          'Ecco [INFO]: EccoNotifier<int>: Attempted to access disposed notifier',
        ),
      );
    });

    test('logs attempts to update disposed notifier', () {
      final notifier = EccoNotifier<int>(0);
      notifier.dispose();

      expect(() => notifier.ripple(1), throwsStateError);
      expect(
        logOutput,
        contains(
          'Ecco [INFO]: EccoNotifier<int>: Attempted to update disposed notifier',
        ),
      );
    });
  });
}
