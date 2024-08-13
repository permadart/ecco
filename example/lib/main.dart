import 'package:flutter/material.dart';

import 'package:ecco/ecco.dart';

import 'model.dart';
import 'view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecco MVVM Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EccoProvider<CounterModel>(
        notifier: CounterViewModel(),
        child: const CounterView(),
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ecco MVVM Counter')),
      body: Center(
        child: EccoConsumer<CounterModel, CounterViewModel>(
          builder: (context, model, viewModel) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count: ${model.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: viewModel.decrement,
                      child: const Text('Decrement'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: viewModel.increment,
                      child: const Text('Increment'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
