import 'package:ecco/ecco.dart';
import 'package:flutter/material.dart';

// Test classes for AvoidDynamicEccoNotifier
class ValidNotifier extends EccoNotifier<int> {
  ValidNotifier() : super(0);
}

class InvalidNotifier extends EccoNotifier<dynamic> {
  // Should trigger AvoidDynamicEccoNotifier
  InvalidNotifier() : super(null);
}

// Test classes for InvalidRippleUsage
class TestState {
  final int value;
  TestState(this.value);
}

class TestNotifier extends EccoNotifier<TestState> {
  TestNotifier() : super(TestState(0));

  void updateStateInvalid1() {
    ripple(state); // Should trigger InvalidRippleUsage
  }

  void updateStateInvalid2() {
    ripple(state); // Should trigger InvalidRippleUsage
  }

  void updateStateValid1() {
    ripple(TestState(state.value + 1)); // Should not trigger InvalidRippleUsage
  }

  void updateStateValid2() {
    final newState = TestState(state.value + 1);
    ripple(newState); // Should not trigger InvalidRippleUsage
  }
}

// Test widgets for MissingEccoProvider
class ValidWidget extends StatelessWidget {
  const ValidWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EccoProvider<int>(
      notifier: ValidNotifier(),
      child: EccoBuilder<int>(
        // Should not trigger MissingEccoProvider
        builder: (context, state) {
          return Text('$state');
        },
      ),
    );
  }
}

class InvalidWidget extends StatelessWidget {
  const InvalidWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EccoConsumer<int, ValidNotifier>(
      // Should trigger MissingEccoProvider
      builder: (context, state, notifier) {
        return Text('$state');
      },
    );
  }
}

void main() {
  // Should trigger AvoidDynamicEccoNotifier
  EccoNotifier<dynamic> dynamicNotifier = EccoNotifier<dynamic>(null);

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const ValidWidget(),
            const InvalidWidget(),
            EccoProvider<int>(
              notifier: ValidNotifier(),
              child: const Text('Valid'),
            ),
            EccoProvider<dynamic>(
              notifier: dynamicNotifier,
              child: const Text('Invalid'),
            ),
          ],
        ),
      ),
    ),
  );

  final testNotifier = TestNotifier();
  testNotifier.updateStateInvalid1();
  testNotifier.updateStateInvalid2();
  testNotifier.updateStateValid1();
  testNotifier.updateStateValid2();
}
