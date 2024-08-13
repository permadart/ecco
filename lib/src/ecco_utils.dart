import 'package:flutter/foundation.dart';

@pragma('vm:prefer-inline')
bool isDebugMode() {
  return !kReleaseMode;
}

mixin Equatable {
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
