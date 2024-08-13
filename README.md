# Ecco

A simple, MVVM-focused state management solution for Flutter.

## Features

- Lightweight and easy to understand
- Built with MVVM (Model-View-ViewModel) pattern in mind
- Efficient rebuilds with fine-grained reactivity
- Debug overlay for easy state visualization
- Supports Equatable for efficient state comparisons

## Installation

Add `ecco` to your `pubspec.yaml` file:

```yaml
dependencies:
  ecco: ^0.0.1+1
```

Then run:

```
flutter pub get
```

## Usage

### Basic Setup

1. Create your model and viewmodel classes:

```dart
class CounterModel {
  final int count;
  CounterModel({this.count = 0});
}

class CounterViewModel extends EccoNotifier<CounterModel> {
  CounterViewModel() : super(CounterModel());

  void increment() {
    ripple(CounterModel(count: state.count + 1));
  }
}
```

2. Wrap your app with EccoProvider:

```dart
EccoProvider<CounterModel>(
  notifier: CounterViewModel(),
  child: MyApp(),
)
```

### Using EccoBuilder

Use `EccoBuilder` to rebuild parts of your UI when the state changes:

```dart
EccoBuilder<CounterModel>(
  builder: (context, model) {
    return Text('Count: ${model.count}');
  },
)
```

### Using EccoConsumer

Use `EccoConsumer` to access both model and viewmodel in a widget:

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

### Debug Overlay

To enable the debug overlay for state visualization, wrap your app with `EccoDebugOverlay`:

```dart
EccoDebugOverlay(
  child: MyApp(),
)
```

## Advanced Usage

### Using Equatable

Ecco supports the use of `Equatable` for efficient state comparisons:

```dart
class User with Equatable {
  final String name;
  final int age;

  User(this.name, this.age);

  @override
  List<Object> get props => [name, age];
}
```

### Logging

Ecco provides built-in logging functionality:

```dart
// Enable logging
Eccoes.enable();

// Set log level
Eccoes.setLogLevel(EccoesLogLevel.debug);

// Log a message
Eccoes.log('This is a debug message', level: EccoesLogLevel.debug);
```

## Best Practices

1. Keep your models immutable
2. Put business logic in your models
3. Put presentation logic in your viewmodels
4. Use `EccoConsumer` when you need access to both model and viewmodel
5. Use `EccoBuilder` for simple state-dependent UI updates

## Contribution

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.