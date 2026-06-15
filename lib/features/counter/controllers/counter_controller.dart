import 'package:flutter/material.dart';
import '../models/counter_model.dart';

class CounterController extends ChangeNotifier {
  CounterModel _model = const CounterModel(0);

  int get count => _model.count;

  void increment() {
    _model = CounterModel(_model.count + 1);
    notifyListeners();
  }
}
