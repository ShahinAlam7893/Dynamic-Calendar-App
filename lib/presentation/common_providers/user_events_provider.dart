import 'package:circleslate/presentation/common_providers/auth_provider.dart';
import 'package:circleslate/presentation/features/event_management/controllers/eventManagementControllers.dart';
import 'package:circleslate/presentation/features/event_management/models/eventsModels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventsProvider extends ChangeNotifier {
  Set<String> _goingEventDates = {}; // Store dates as 'yyyy-MM-dd'

  Set<String> get goingEventDates => _goingEventDates;

  // Fetch all events where user is "going" using context to get userId from AuthProvider
  Future<void> fetchGoingEvents(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userProfile?['id']?.toString();
    if (userId == null) {
      print("No userId found in AuthProvider.userProfile");
      return; // Return empty if no userId
    }

    List<Event> events = await EventService.fetchEvents(); // Fetch all/upcoming events
    final goingEvents = events
        .where((event) => event.responses.any((resp) => resp.userId == userId && resp.responseDisplay == 'Going'))
        .toList();

    _goingEventDates = goingEvents.map((event) => event.date).toSet();
    notifyListeners();
  }

  // Add a date when user marks "going"
  void addGoingDate(String date) {
    _goingEventDates.add(date);
    notifyListeners();
  }

  // Remove a date when user marks "not_going"
  void removeGoingDate(String date) {
    _goingEventDates.remove(date);
    notifyListeners();
  }
}