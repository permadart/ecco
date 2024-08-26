import 'package:flutter/widgets.dart';

import 'package:ecco/ecco.dart';

/// Defines the log levels used by Eccoes for debugging and logging purposes.
enum EccoesLogLevel {
  /// Fine-grained information events, typically used for debugging.
  debug,

  /// General information about system operation.
  info,

  /// Potentially harmful situations that might lead to issues.
  warning,

  /// Error events that might still allow the application to continue running.
  error
}

/// A generic notifier class that manages state and notifies listeners of changes.
///
/// [T] is the type of state managed by this notifier.
class EccoNotifier<T> extends ChangeNotifier {
  T _state;
  bool _disposed = false;
  final String _id = UniqueKey().toString();

  /// Creates a new [EccoNotifier] with the given initial state.
  ///
  /// In debug mode, it registers itself with [EccoDebug].
  EccoNotifier(this._state) {
    if (isDebugMode()) {
      EccoDebug.instance._registerNotifier(this);
    }
  }

  /// Gets the current state.
  ///
  /// Throws a [StateError] if accessed after disposal.
  T get state {
    if (_disposed) {
      if (isDebugMode()) {
        Eccoes.log('EccoNotifier<$T>: Attempted to access disposed notifier');
      }
      throw StateError(
        'EccoNotifier<$T>: Cannot access state of a disposed EccoNotifier.',
      );
    }
    return _state;
  }

  /// Updates the state and notifies listeners if the new state is different.
  ///
  /// Throws a [StateError] if called after disposal.
  void ripple(T newState) {
    if (_disposed) {
      if (isDebugMode()) {
        Eccoes.log('EccoNotifier<$T>: Attempted to update disposed notifier');
      }
      throw StateError(
        'EccoNotifier<$T>: Cannot update state of a disposed EccoNotifier.',
      );
    }

    if (!_equals(_state, newState)) {
      _state = newState;

      notifyListeners();
      if (isDebugMode()) {
        Eccoes.log('EccoNotifier<$T>: State updated');
        EccoDebug.instance._notifyStateChange(this);
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (isDebugMode()) {
      EccoDebug.instance._unregisterNotifier(this);
    }
    super.dispose();
  }

  bool _equals(T a, T b) {
    if (a is Equatable && b is Equatable) {
      return a == b;
    }
    return identical(a, b) || a == b;
  }

  /// Converts the notifier's state to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'type': T.toString(),
      'state': state.toString(),
    };
  }
}

/// A widget that provides an [EccoNotifier] to its descendants.
///
/// Use [EccoProvider.of] to access the notifier from descendant widgets.
class EccoProvider<T> extends InheritedNotifier<EccoNotifier<T>> {
  /// Creates an [EccoProvider].
  ///
  /// The [notifier] and [child] arguments must not be null.
  const EccoProvider({
    super.key,
    required EccoNotifier<T> super.notifier,
    required super.child,
  });

  /// Retrieves the [EccoNotifier] of type [T] from the widget tree.
  ///
  /// Throws a [FlutterError] if the provider is not found in the widget tree.
  static EccoNotifier<T> of<T>(BuildContext context) {
    final dependOn = context.dependOnInheritedWidgetOfExactType;

    final provider = dependOn<EccoProvider<T>>();

    if (provider == null) {
      throw FlutterError(
        'EccoProvider<$T> not found in the widget tree.\n'
        'Make sure there is an EccoProvider<$T> above the current widget in the widget tree.\n'
        'For more information, see: https://pub.dev/packages/ecco',
      );
    }

    return provider.notifier!;
  }
}

/// A widget that rebuilds when the state of an [EccoNotifier] changes.
///
/// The [builder] function is called with the current context and state.
class EccoBuilder<T> extends StatelessWidget {
  /// The function used to build the widget tree based on the current state.
  final Widget Function(BuildContext context, T state) builder;

  /// Creates an [EccoBuilder].
  ///
  /// The [builder] argument must not be null.
  const EccoBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = EccoProvider.of<T>(context);

    return AnimatedBuilder(
      animation: notifier,
      builder: (context, _) {
        if (isDebugMode()) {
          Eccoes.log('EccoBuilder<$T>: Rebuilding');
        }
        return builder(context, notifier.state);
      },
    );
  }
}

/// A widget that rebuilds when the state of an [EccoNotifier] changes, providing both state and notifier.
///
/// The [builder] function is called with the current context, state, and notifier.
class EccoConsumer<T, VM extends EccoNotifier<T>> extends StatelessWidget {
  /// The function used to build the widget tree based on the current state and notifier.
  final Widget Function(BuildContext context, T state, VM notifier) builder;

  /// Creates an [EccoConsumer].
  ///
  /// The [builder] argument must not be null.
  const EccoConsumer({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = EccoProvider.of<T>(context) as VM;

    return AnimatedBuilder(
      animation: notifier,
      builder: (context, _) {
        if (isDebugMode()) {
          Eccoes.log('EccoConsumer<$T>: Rebuilding');
        }
        return builder(context, notifier.state, notifier);
      },
    );
  }
}

/// A singleton class for debugging Ecco notifiers.
///
/// Tracks registered notifiers and notifies listeners of changes.
class EccoDebug {
  /// The singleton instance of [EccoDebug].
  static final EccoDebug instance = EccoDebug._();

  EccoDebug._();

  final _notifiers = <Type, Set<EccoNotifier<dynamic>>>{};
  final _listeners = <VoidCallback>[];

  void _registerNotifier<T>(EccoNotifier<T> notifier) {
    _notifiers.putIfAbsent(T, () => <EccoNotifier<T>>{}).add(notifier);
    _notifyListeners();
  }

  void _unregisterNotifier<T>(EccoNotifier<T> notifier) {
    final typeSet = _notifiers[T];
    if (typeSet != null) {
      typeSet.remove(notifier);
      if (typeSet.isEmpty) {
        _notifiers.remove(T);
      }
    }
    _notifyListeners();
  }

  void _notifyStateChange<T>(EccoNotifier<T> notifier) {
    _notifyListeners();
  }

  /// Adds a listener to be notified of changes in the debug state.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Removes a previously added listener.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Clears all registered notifiers and listeners.
  void clearState() {
    _notifiers.clear();
    _listeners.clear();
    _notifyListeners();
  }

  /// Returns a list of all registered notifiers' data.
  List<Map<String, dynamic>> getNotifiersData() {
    return _notifiers.entries.expand((entry) {
      return entry.value.map((notifier) => notifier.toJson());
    }).toList();
  }
}

/// A utility class for logging and debugging in Ecco.
class Eccoes {
  static EccoesLogLevel _logLevel = EccoesLogLevel.info;
  static bool _enabled = false;
  static void Function(String)? _testLogCallback;

  /// Gets the current log level.
  static EccoesLogLevel get currentLogLevel => _logLevel;

  /// Enables logging.
  static void enable() {
    _enabled = true;
  }

  /// Disables logging.
  static void disable() {
    _enabled = false;
  }

  /// Sets the minimum log level for messages to be displayed.
  static void setLogLevel(EccoesLogLevel level) {
    _logLevel = level;
  }

  /// Sets a callback function for capturing log messages in tests.
  static void setTestLogCallback(void Function(String)? callback) {
    _testLogCallback = callback;
  }

  /// Logs a message if logging is enabled and the message's level is at or above the current log level.
  static void log(
    String message, {
    EccoesLogLevel level = EccoesLogLevel.info,
  }) {
    if (level.index >= _logLevel.index && _enabled) {
      final logMessage = 'Ecco [${level.name.toUpperCase()}]: $message';
      if (_testLogCallback != null) {
        _testLogCallback!(logMessage);
      } else {
        debugPrint(logMessage);
      }
    }
  }
}

/// Extension on [BuildContext] that provides convenient access to Ecco notifiers.
///
/// This extension allows for easy retrieval of ViewModel instances from the widget tree
/// without explicitly specifying the associated Model type.
extension EccoExtension on BuildContext {
  /// Retrieves the nearest [EccoNotifier] of type [VM] from the widget tree.
  ///
  /// This method searches up the widget tree for the nearest [EccoProvider] that
  /// contains a notifier of the specified ViewModel type [VM]. It allows for
  /// accessing the ViewModel without needing to know the associated Model type.
  ///
  /// Example usage:
  /// ```dart
  /// final viewModel = context.ecco<MyViewModel>();
  /// viewModel.someMethod();
  /// ```
  ///
  /// Throws a [FlutterError] if no matching [EccoProvider] is found in the widget tree.
  ///
  /// Type parameters:
  ///   [VM]: The type of the ViewModel to retrieve. Must extend [EccoNotifier].
  ///
  /// Returns:
  ///   The nearest [EccoNotifier] of type [VM] found in the widget tree.
  VM ecco<VM extends EccoNotifier>() {
    EccoProvider? provider;
    bool foundProvider = false;

    visitAncestorElements((element) {
      if (element.widget is EccoProvider) {
        provider = element.widget as EccoProvider;
        if (provider!.notifier is VM) {
          foundProvider = true;
          return false;
        }
      }
      return true;
    });

    if (foundProvider && provider != null) {
      return provider!.notifier as VM;
    }

    throw FlutterError(
      'No EccoProvider with a notifier of type $VM found in the widget tree.\n'
      'Make sure there is an EccoProvider with a $VM notifier above the current widget in the widget tree.\n'
      'For more information, see: https://pub.dev/packages/ecco',
    );
  }
}
