import 'package:flutter/material.dart';

class AvailabilityProvider extends ChangeNotifier {
  // State for Calendar dates (day of month):
  // 0 = Unavailable (Busy)
  // 1 = Available
  // 2 = Tentative (Maybe Available from settings, or default/inactive)
  final Map<int, int> _calendarDateStates = {
    1: 2, 2: 2, 3: 2, 4: 2, 5: 2, 6: 2, 7: 2, 8: 2, 9: 2, 10: 2, 11: 2, 12: 2, 13: 2,
    14: 2, 15: 2, 16: 2, 17: 2, 18: 2, 19: 2, 20: 2, 21: 2, 22: 2, 23: 2, 24: 2,
    25: 2, 26: 2, 27: 2, 28: 2, 29: 2, 30: 2, 31: 2,
  };

  // Stores availability status for each day of the week (DateTime.sunday=7, DateTime.monday=1, ..., DateTime.saturday=6)
  // Value: 0=Unavailable, 1=Available, 2=Tentative
  final Map<int, int> _weeklyAvailability = {
    DateTime.sunday: 2, // 7
    DateTime.monday: 2, // 1
    DateTime.tuesday: 2, // 2
    DateTime.wednesday: 2, // 3
    DateTime.thursday: 2, // 4
    DateTime.friday: 2, // 5
    DateTime.saturday: 2, // 6
  };

  // Stores the specific time range for each day of the week
  final Map<int, String> _weeklyTimeRanges = {
    DateTime.sunday: 'Not Set',
    DateTime.monday: 'Not Set',
    DateTime.tuesday: 'Not Set',
    DateTime.wednesday: 'Not Set',
    DateTime.thursday: 'Not Set',
    DateTime.friday: 'Not Set',
    DateTime.saturday: 'Not Set',
  };

  Map<int, int> get calendarDateStates => _calendarDateStates;
  Map<int, int> get weeklyAvailability => _weeklyAvailability;
  Map<int, String> get weeklyTimeRanges => _weeklyTimeRanges;


  // Updates the state of a specific date (day of month) and notifies listeners.
  void updateDateState(int date, int newState) {
    if (_calendarDateStates.containsKey(date)) {
      _calendarDateStates[date] = newState;
      notifyListeners();
    }
  }

  // Toggles the state of a date (day of month) (default -> available -> unavailable -> default)
  void toggleDateState(int date) {
    if (_calendarDateStates.containsKey(date)) {
      int currentState = _calendarDateStates[date]!;
      int newState;
      if (currentState == 2) { // If currently default/tentative, make it available
        newState = 1;
      } else if (currentState == 1) { // If available, make it unavailable
        newState = 0;
      } else { // If unavailable, make it tentative
        newState = 2;
      }
      _calendarDateStates[date] = newState;
      notifyListeners();
    }
  }

  // Sets the availability for a list of dates (day of month) to a specific status
  void setAvailabilityForDates(List<int> dates, int status) {
    for (int date in dates) {
      if (_calendarDateStates.containsKey(date)) {
        _calendarDateStates[date] = status;
      }
    }
    notifyListeners();
  }

  // New method to set availability for a single day of the week with a specific time range
  void setDayOfWeekAvailability(int dayOfWeek, int status, String timeRange) {
    if (_weeklyAvailability.containsKey(dayOfWeek)) {
      _weeklyAvailability[dayOfWeek] = status;
      _weeklyTimeRanges[dayOfWeek] = timeRange;
      notifyListeners();
    }
  }

  // Method to reset all weekly availability to default/tentative
  void resetWeeklyAvailability() {
    _weeklyAvailability.updateAll((key, value) => 2); // Set all to tentative
    _weeklyTimeRanges.updateAll((key, value) => 'Not Set'); // Reset time ranges
    notifyListeners();
  }
}
