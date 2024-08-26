# Ecco Example

This example demonstrates how to use the Ecco package for state management in a Flutter application, following the MVVM (Model-View-ViewModel) pattern.

## Prerequisites

- Flutter SDK version 3.4.4 or higher
- Ecco package added to your `pubspec.yaml`

## Running the Example

1. Clone the Ecco repository
2. Navigate to the example directory
3. Run `flutter pub get`
4. Run `flutter run`

## What This Example Demonstrates

This example shows how to:

1. Create `EccoNotifier`s to manage state for both models and viewmodels
2. Use `EccoProvider` to make the state available to the widget tree
3. Use `EccoBuilder` to rebuild parts of the UI when state changes
4. Use `EccoConsumer` to access both model and viewmodel in a widget

## Key Code Snippets

### Creating EccoNotifiers for Model and ViewModel

```dart
final counterModel = EccoNotifier<int>(0);
final counterViewModel = EccoNotifier<CounterViewModel>(CounterViewModel());
```

### Using EccoProvider

```dart
EccoProvider<int>(
  notifier: counterModel,
  child: EccoProvider<CounterViewModel>(
    notifier: counterViewModel,
    child: MyApp(),
  ),
)
```

### Using EccoBuilder

```dart
EccoBuilder<int>(
  builder: (context, count) {
    return Text('Count: $count');
  },
)
```

### Using EccoConsumer

```dart
EccoConsumer<int, CounterViewModel>(
  builder: (context, count, viewModel) {
    return ElevatedButton(
      onPressed: () => viewModel.increment(),
      child: Text('Increment'),
    );
  },
)
```

## MVVM Pattern with Ecco

Ecco encourages the use of the MVVM pattern:

- **Model**: Represents the data and business logic. In this example, it's a simple `int` for the counter.
- **ViewModel**: Contains the presentation logic and commands that the view can use. It's represented by the `CounterViewModel` class.
- **View**: The UI components that display the data and interact with the user. In Flutter, these are your widgets.

The `EccoConsumer` allows you to easily connect your View with both the Model and ViewModel, promoting a clean separation of concerns.

## Additional Resources

- [Ecco Package Documentation](https://pub.dev/packages/ecco)
- [Flutter State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [MVVM Pattern in Flutter](https://medium.com/flutter-community/flutter-mvvm-architecture-f8bed2521958)

Feel free to explore and modify this example to better understand how Ecco works with the MVVM pattern.