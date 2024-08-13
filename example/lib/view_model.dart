import 'package:ecco/ecco.dart';

import 'model.dart';

class CounterViewModel extends EccoNotifier<CounterModel> {
  CounterViewModel() : super(CounterModel());

  void increment() {
    ripple(CounterModel(count: state.count + 1));
  }

  void decrement() {
    ripple(CounterModel(count: state.count - 1));
  }
}
