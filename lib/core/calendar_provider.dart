import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  final Map<String, int> _calendarDateStates = {
    for (int day = 1; day <= 31; day++)
      "07-${day.toString().padLeft(2, '0')}": 2 // default state = 2
  };

  Map<String, int> get calendarDateStates => _calendarDateStates;

  void updateCalendarDateState(DateTime date, int state) {
    final key =
        "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    _calendarDateStates[key] = state;
    notifyListeners();
  }

  int getStateForDate(DateTime date) {
    final key =
        "${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return _calendarDateStates[key] ?? 2; // default to 2 if not found
  }
}
