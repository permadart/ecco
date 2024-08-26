import 'package:flutter/foundation.dart';

/// Determines if the application is running in debug mode.
///
/// This function is marked for inline optimization to improve performance
/// in release builds.
///
/// Returns `true` if the app is running in debug mode, `false` otherwise.
@pragma('vm:prefer-inline')
bool isDebugMode() {
  return !kReleaseMode;
}

/// A mixin that provides value equality for objects.
///
/// Classes that mix in `Equatable` should override [props] to provide a list
/// of object properties to be used for equality comparisons and hash code generation.
mixin Equatable {
  /// The list of properties that will be used to determine whether two instances are equal.
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            listEquals(props, other.props);
  }

  @override
  int get hashCode => Object.hashAll(props);
}
