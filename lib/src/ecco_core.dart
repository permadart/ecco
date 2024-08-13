import 'package:flutter/widgets.dart';

import 'package:ecco/ecco.dart';

enum EccoesLogLevel { debug, info, warning, error }

class EccoNotifier<T> extends ChangeNotifier {
  T _state;
  bool _disposed = false;
  final String _id = UniqueKey().toString();

  EccoNotifier(this._state) {
    if (isDebugMode()) {
      EccoDebug.instance._registerNotifier(
        this,
      );
    }
  }

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
        EccoDebug.instance._notifyStateChange(
          this,
        );
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (isDebugMode()) {
      EccoDebug.instance._unregisterNotifier(
        this,
      );
    }
    super.dispose();
  }

  bool _equals(T a, T b) {
    if (a is Equatable && b is Equatable) {
      return a == b;
    }
    return identical(a, b) || a == b;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'type': T.toString(),
      'state': state.toString(),
    };
  }
}

class EccoProvider<T> extends InheritedNotifier<EccoNotifier<T>> {
  const EccoProvider({
    super.key,
    required EccoNotifier<T> super.notifier,
    required super.child,
  });

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

class EccoBuilder<T> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    T state,
  ) builder;

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
        return builder(
          context,
          notifier.state,
        );
      },
    );
  }
}

class EccoConsumer<T, VM extends EccoNotifier<T>> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    T state,
    VM notifier,
  ) builder;

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
        return builder(
          context,
          notifier.state,
          notifier,
        );
      },
    );
  }
}

class EccoDebug {
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

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void clearState() {
    _notifiers.clear();
    _listeners.clear();
    _notifyListeners();
  }

  List<Map<String, dynamic>> getNotifiersData() {
    return _notifiers.entries.expand((entry) {
      return entry.value.map((notifier) => notifier.toJson());
    }).toList();
  }
}

class Eccoes {
  static EccoesLogLevel _logLevel = EccoesLogLevel.info;
  static bool _enabled = false;
  static void Function(String)? _testLogCallback;

  static EccoesLogLevel get currentLogLevel => _logLevel;

  static void enable() {
    _enabled = true;
  }

  static void disable() {
    _enabled = false;
  }

  static void setLogLevel(EccoesLogLevel level) {
    _logLevel = level;
  }

  static void setTestLogCallback(void Function(String)? callback) {
    _testLogCallback = callback;
  }

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
