# Ecco

Ecco is a simple, MVVM-focused state management solution for Flutter. It provides an intuitive way to manage application state and rebuild UI components efficiently.

## Features

- Lightweight and easy to understand
- MVVM architecture support
- Efficient UI updates with fine-grained rebuilds
- Debug overlay for real-time state visualization (WIP)
- Customizable logging functionality
- Built-in support for `Equatable` for efficient state comparisons

## Installation

Add `ecco` to your `pubspec.yaml` file:

```yaml
dependencies:
  ecco: ^0.0.1+3
```

Then run:

```
flutter pub get
```

## Basic Usage

Here's a simple counter app example demonstrating the basic usage of Ecco:

```dart
import 'package:flutter/material.dart';
import 'package:ecco/ecco.dart';

void main() {
  Eccoes.enable();
  Eccoes.setLogLevel(EccoesLogLevel.debug);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

class CounterView extends StatelessWidget {
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
                ElevatedButton(
                  onPressed: context.ecco<CounterViewModel>().increment,
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 20),
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

class CounterModel {
  final int count;
  CounterModel({this.count = 0});
}

class CounterViewModel extends EccoNotifier<CounterModel> {
  CounterViewModel() : super(CounterModel());

  void increment() {
    ripple(CounterModel(count: state.count + 1));
  }

  void decrement() {
    ripple(CounterModel(count: state.count - 1));
  }
}
```

## Core Concepts

### EccoNotifier

`EccoNotifier` is the base class for managing state. It extends `ChangeNotifier` and provides methods to update state and notify listeners.

```dart
class CounterViewModel extends EccoNotifier<CounterModel> {
  CounterViewModel() : super(CounterModel());

  void increment() {
    ripple(CounterModel(count: state.count + 1));
  }
}
```

### EccoProvider

`EccoProvider` makes an `EccoNotifier` available to its descendants in the widget tree.

```dart
EccoProvider<CounterModel>(
  notifier: CounterViewModel(),
  child: const CounterView(),
)
```

### EccoBuilder

`EccoBuilder` rebuilds its child widget when the state of an `EccoNotifier` changes.

```dart
EccoBuilder<CounterModel>(
  builder: (context, model) {
    return Text('Count: ${model.count}');
  },
)
```

### EccoConsumer

`EccoConsumer` provides access to both the state and the notifier in its builder function.

```dart
EccoConsumer<CounterModel, CounterViewModel>(
  builder: (context, model, viewModel) {
    return ElevatedButton(
      onPressed: viewModel.increment,
      child: Text('Increment'),
    );
  },
)
```

### Extension Method: ecco<T>

Ecco provides a convenient extension method on `BuildContext` to easily access notifiers:

```dart
ElevatedButton(
  onPressed: context.ecco<CounterViewModel>().increment,
  child: const Text('Increment'),
),
```

This extension method retrieves the `EccoNotifier` of type `T` from the widget tree, allowing for a more concise syntax when accessing notifiers.

## Debug Overlay

Ecco includes a debug overlay to visualize the state of all registered notifiers in real-time. To use it, wrap your app's root widget with `EccoDebugOverlay`:

```dart
EccoDebugOverlay(
  child: YourApp(),
)
```

## Logging

Ecco provides customizable logging functionality. Enable logging and set the desired log level in your app's main function:

```dart
void main() {
  Eccoes.enable();
  Eccoes.setLogLevel(EccoesLogLevel.debug);
  runApp(const MyApp());
}
```

## Best Practices

1. Keep your models immutable and use the `Equatable` mixin for efficient comparisons.
2. Use `EccoBuilder` for widgets that only need to read the state.
3. Use `EccoConsumer` when you need access to both the state and the notifier.
4. Leverage the `ecco<T>()` extension method for concise notifier access.
5. Use the debug overlay during development to visualize state changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.