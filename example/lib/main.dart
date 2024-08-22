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
    return const MaterialApp(
      home: MyWidget(),
    );
  }
}

/// The main view of the app.
///
/// Displays mock data and a button to load it.
class MyWidget extends StatelessWidget {
  /// Creates a [MyWidget].
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EccoProvider<AppState>(
      notifier: AppViewModel(),
      child: EccoConsumer<AppState, AppViewModel>(
        builder: (context, state, notifier) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ecco MVVM Demo')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is InitialState)
                    const Text('Press the button to load data')
                  else if (state is LoadingState)
                    const CircularProgressIndicator()
                  else if (state is LoadedState)
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.data.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(state.data[index]),
                        ),
                      ),
                    )
                  else if (state is ErrorState)
                    Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is LoadingState ? null : notifier.loadData,
                    child: const Text('Load Data'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The base state class for the application.
///
/// All concrete state classes should extend this class and implement [props].
abstract class AppState with Equatable {
  /// Creates an [AppState].
  const AppState();
}

/// Represents the initial state of the application.
class InitialState extends AppState {
  /// Creates an [InitialState].
  const InitialState();

  @override
  List<Object?> get props => [];
}

/// Represents the loading state when data is being fetched.
class LoadingState extends AppState {
  /// Creates a [LoadingState].
  const LoadingState();

  @override
  List<Object?> get props => [];
}

/// Represents the loaded state when data has been successfully fetched.
class LoadedState extends AppState {
  /// The list of data items.
  final List<String> data;

  /// Creates a [LoadedState] with the given [data].
  const LoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

/// Represents the error state when data fetching has failed.
class ErrorState extends AppState {
  /// The error message.
  final String error;

  /// Creates an [ErrorState] with the given [error] message.
  const ErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

/// The view model for the app.
///
/// Manages the state of the [AppState] and provides methods to modify it.
class AppViewModel extends EccoNotifier<AppState> {
  AppViewModel() : super(const InitialState());

  /// Loads mock data asynchronously.
  ///
  /// Updates the state to [LoadingState] while loading, then either
  /// [LoadedState] with the loaded data or [ErrorState] if an error occurs.
  void loadData() async {
    ripple(const LoadingState());
    try {
      // Simulating an API call
      await Future.delayed(const Duration(seconds: 2));
      final data = ['Item 1', 'Item 2', 'Item 3'];
      ripple(LoadedState(data));
    } catch (e) {
      ripple(ErrorState(e.toString()));
    }
  }
}
