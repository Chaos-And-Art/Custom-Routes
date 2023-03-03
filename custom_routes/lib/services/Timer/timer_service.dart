import 'dart:async';
import 'package:flutter/material.dart';

class TimerService with ChangeNotifier {
  int _selectedTimeInSeconds = 5 * 60; //5 Minutes
  Timer? _timer;
  int _counter = 0;
  bool _isRunning = false;
  int _timeToEnd = 8 * 60 * 60; // 8 hours

  TimerService() {
    _counter = _selectedTimeInSeconds;
  }

  int get selectedTimeInSeconds => _selectedTimeInSeconds;

  set selectedTimeInSeconds(int value) {
    _selectedTimeInSeconds = value;
    _counter = value;
    notifyListeners();
  }

  int get counter => _counter;

  bool get isRunning => _isRunning;

  void startTimer({Function()? timerFinished}) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        _counter--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        if (timerFinished != null) {
          timerFinished();
        }
        _counter = _selectedTimeInSeconds;
        if (_timeToEnd > 0) {
          _timeToEnd -= _selectedTimeInSeconds;
          startTimer(timerFinished: timerFinished);
        }
      }
    });
    _isRunning = true;
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _counter = _selectedTimeInSeconds;
    _isRunning = false;
    notifyListeners();
  }
}
