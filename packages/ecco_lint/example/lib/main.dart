// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:ecco/ecco.dart';

void main() {
  runApp(const MyApp());
}

class CounterModel {
  final int count;
  CounterModel(this.count);
}

class CounterViewModel extends EccoNotifier<CounterModel> {
  CounterViewModel() : super(CounterModel(0));

  void increment() {
    ripple(CounterModel(state.count + 1));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EccoProvider<CounterModel>(
        notifier: CounterViewModel(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: avoid_dynamic_ecco_notifier
    final dynamicNotifier = EccoNotifier<dynamic>(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Ecco Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // expect_lint: missing_ecco_provider
          EccoBuilder<AnotherModel>(
            builder: (context, state) {
              return Text('Another count: ${state.count}');
            },
          ),
          EccoConsumer<CounterModel, CounterViewModel>(
            builder: (context, state, viewModel) {
              return Text('Count: ${state.count}');
            },
          ),
          ElevatedButton(
            onPressed: () {
              final viewModel = context.ecco<CounterViewModel>();
              // expect_lint: invalid_ripple_usage
              viewModel.ripple(viewModel.state);
            },
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}

class AnotherModel {
  final int count;
  AnotherModel(this.count);
}
