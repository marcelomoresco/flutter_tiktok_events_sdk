import 'package:flutter/foundation.dart';

class CounterModel extends ChangeNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}
