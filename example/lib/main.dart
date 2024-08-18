import 'package:flutter/material.dart';
import 'package:ecco/ecco.dart';

/// The entry point of the application.
///
/// Enables Ecco logging and sets the log level to debug before running the app.
void main() {
  Eccoes.enable();
  Eccoes.setLogLevel(EccoesLogLevel.debug);
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// Sets up the MaterialApp and provides the CounterViewModel to its descendants.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecco MVVM Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EccoDebugOverlay(
        child: EccoProvider<CounterModel>(
          notifier: CounterViewModel(),
          child: const CounterView(),
        ),
      ),
    );
  }
}

/// The main view of the counter application.
///
/// Displays the current count and buttons to increment it.
class CounterView extends StatelessWidget {
  /// Creates a [CounterView] widget.
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ecco MVVM Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EccoBuilder<CounterModel>(
              builder: (context, model) {
                return Text(
                  'Count: ${model.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Finds the notifier given by the closest EccoProvider<T>
                ElevatedButton(
                  onPressed: context.ecco<CounterViewModel>().decrement,
                  child: const Text('Decrement'),
                ),
                const SizedBox(width: 20),
                // Has a reference to both the Model and the ViewModel
                EccoConsumer<CounterModel, CounterViewModel>(
                  builder: (context, model, viewModel) {
                    return ElevatedButton(
                      onPressed: viewModel.increment,
                      child: const Text('Increment'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The data model for the counter.
///
/// Contains the current count value.
class CounterModel {
  /// The current count value.
  final int count;

  /// Creates a [CounterModel] with the given count.
  ///
  /// If no count is provided, it defaults to 0.
  CounterModel({this.count = 0});
}

/// The view model for the counter.
///
/// Manages the state of the [CounterModel] and provides methods to modify it.
class CounterViewModel extends EccoNotifier<CounterModel> {
  /// Creates a [CounterViewModel] with an initial [CounterModel].
  CounterViewModel() : super(CounterModel());

  /// Increments the count by 1.
  void increment() {
    ripple(CounterModel(count: state.count + 1));
  }

  /// Decrements the count by 1.
  void decrement() {
    ripple(CounterModel(count: state.count - 1));
  }
}
