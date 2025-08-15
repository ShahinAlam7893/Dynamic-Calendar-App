import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiEndpoints {
  static const String getAvailability =
      '/calendar/availability/'; // Adjust this to match your actual endpoint
}

class AvailabilityProvider extends ChangeNotifier {
  // API endpoint
  static const String _apiUrl =
      "http://10.10.13.27:8000/api/calendar/availability/";

  Map<int, Map<String, dynamic>> apiAvailability = {};
  bool isLoading = false;
  String? errorMessage;

  // Calendar date states: 0 = Unavailable, 1 = Available, 2 = Tentative
  final Map<int, int> _calendarDateStates = {
    for (int i = 1; i <= 31; i++) i: 2,
  };

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Weekly availability: DateTime.sunday = 7 ... saturday = 6
  final Map<int, int> _weeklyAvailability = {
    DateTime.sunday: 2,
    DateTime.monday: 2,
    DateTime.tuesday: 2,
    DateTime.wednesday: 2,
    DateTime.thursday: 2,
    DateTime.friday: 2,
    DateTime.saturday: 2,
  };

  // Time ranges for each day
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

  /// Updates a specific date's state
  void updateDateState(int date, int newState) {
    if (_calendarDateStates.containsKey(date)) {
      _calendarDateStates[date] = newState;
      notifyListeners();
    }
  }

  /// Toggles a date's availability state
  void toggleDateState(int date) {
    if (_calendarDateStates.containsKey(date)) {
      int currentState = _calendarDateStates[date]!;
      int newState;
      if (currentState == 2) {
        newState = 1;
      } else if (currentState == 1) {
        newState = 0;
      } else {
        newState = 2;
      }
      _calendarDateStates[date] = newState;
      notifyListeners();
    }
  }

  /// Sets multiple dates to a specific status
  void setAvailabilityForDates(List<int> dates, int status) {
    for (int date in dates) {
      if (_calendarDateStates.containsKey(date)) {
        _calendarDateStates[date] = status;
      }
    }
    notifyListeners();
  }

  /// Set availability for a specific day of week
  void setDayOfWeekAvailability(int dayOfWeek, int status, String timeRange) {
    if (_weeklyAvailability.containsKey(dayOfWeek)) {
      _weeklyAvailability[dayOfWeek] = status;
      _weeklyTimeRanges[dayOfWeek] = timeRange;
      notifyListeners();
    }
  }

  /// Reset all weekly availability
  void resetWeeklyAvailability() {
    _weeklyAvailability.updateAll((key, value) => 2);
    _weeklyTimeRanges.updateAll((key, value) => 'Not Set');
    notifyListeners();
  }

  /// Convert status code to string for API
  String _statusToString(int status) {
    switch (status) {
      case 1:
        return "available"; // lowercase
      case 0:
        return "busy";
      case 2:
        return "maybe";
      default:
        return "busy";
    }
  }

  /// Convert repeat option index to API string
  String _repeatOptionToString(int option) {
    switch (option) {
      case 0:
        return "once";
      case 1:
        return "weekly";
      case 2:
        return "monthly";
      default:
        return "once";
    }
  }

  /// Save availability to API
  Future<bool> saveAvailabilityToAPI({
    required int selectedStatus,
    required int selectedTimeSlotIndex,
    required int selectedRepeatOption,
    required String startDate,
    String? endDate,
    String? notes,
    required token,
  }) async {
    final token = await _getToken(); // 🔹 Get token from SharedPreferences

    if (token == null) {
      print("❌ No token found, user not logged in");
      return false;
    }

    bool morningAvailable = selectedTimeSlotIndex == 0;
    bool afternoonAvailable = selectedTimeSlotIndex == 1;
    bool eveningAvailable = selectedTimeSlotIndex == 2;
    bool nightAvailable = selectedTimeSlotIndex == 3;

    String statusStr = _statusToString(selectedStatus);

    final body = {
      "morning_available": morningAvailable,
      "morning_status": statusStr,
      "afternoon_available": afternoonAvailable,
      "afternoon_status": statusStr,
      "evening_available": eveningAvailable,
      "evening_status": statusStr,
      "night_available": nightAvailable,
      "night_status": statusStr,
      "repeat_schedule": _repeatOptionToString(selectedRepeatOption),
      "start_date": startDate,
      "end_date": endDate ?? "",
      "notes": notes ?? "",
    };

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token", // 🔹 Send token
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Availability saved: ${response.body}");
        return true;
      } else {
        print("❌ Failed to save: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("🔥 Error saving availability: $e");
      return false;
    }
  }

  // -------------------- Fetch Availability from API --------------------
  Future<void> fetchAvailabilityFromAPI(String token) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(Uri.parse(_apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        apiAvailability = _mapApiData(data);

        print("Mapped Availability: $apiAvailability");

        notifyListeners();
      } else {
        print("❌ Failed to fetch: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("🔥 Error fetching availability: $e");
    }
  }

  // Put this helper method inside the class (or just below it)
  Map<int, Map<String, dynamic>> _mapApiData(List<dynamic> apiResponse) {
    final Map<int, Map<String, dynamic>> mapped = {};

    for (final item in apiResponse) {
      final date = DateTime.parse(item["start_date"]);
      final weekday = date.weekday;

      final slots = item["all_time_slots_with_status"] as Map<String, dynamic>;

      String selectedTimeRange = "Not Set";
      String statusDisplay = "Tentative";

      for (var slot in slots.values) {
        if (slot is Map && slot.containsKey("status_display")) {
          selectedTimeRange = slot["time"] ?? "Not Set";
          statusDisplay = slot["status_display"] ?? "Tentative";
          break;
        }
      }

      mapped[weekday] = {
        "status": _statusStringToCode(statusDisplay),
        "timeRange": selectedTimeRange,
      };
    }

    return mapped;
  }

  // Helper method to convert status string to code
  int _statusStringToCode(String status) {
    switch (status.toLowerCase()) {
      case "busy":
        return 0;
      case "available":
        return 1;
      case "maybe":
        return 2;
      default:
        return 2;
    }
  }

  // -------------------- Fetches availability for the current month --------------------
  Future<void> fetchMonthAvailabilityFromAPI(int year, int month) async {
    final token = await _getToken();
    if (token == null) {
      print("❌ No token found.");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      // Get total days in month
      final daysInMonth = DateTime(year, month + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        final dateString =
            "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

        final response = await http.get(
          Uri.parse(
            "http://10.10.13.27:8000/api/calendar/day/?date=$dateString",
          ),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final timeSlots = data["time_slots"] ?? [];

          // Default = 2 (Tentative)
          int statusCode = 2;

          if (timeSlots.isNotEmpty) {
            final status = timeSlots.first["status"]?.toLowerCase() ?? "maybe";
            if (status == "busy") statusCode = 0;
            if (status == "available") statusCode = 1;
            if (status == "maybe") statusCode = 2;
          }

          _calendarDateStates[day] = statusCode;
        } else {
          _calendarDateStates[day] = 2; // Tentative if no data
        }
      }

      print("📅 Calendar data updated for $month/$year: $_calendarDateStates");
    } catch (e) {
      print("🔥 Error fetching month availability: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
