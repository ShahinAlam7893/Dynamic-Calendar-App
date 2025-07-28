import 'package:circleslate/main.dart';
import 'package:circleslate/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router for navigation

// --- AppColors (Ideally from lib/core/constants/app_colors.dart) ---
// Defined here for self-containment in Canvas.
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0xFF333333);
  static const Color inputHintColor = Colors.grey;
  static const Color lightBlueBackground = Color(0x1AD8ECFF);
  static const Color textDark = Color(0xE51B1D2A);
  static const Color textMedium = Color(0x991B1D2A);
  static const Color textLight = Color(0xB21B1D2A);
  static const Color accentBlue = Color(0xFF5A8DEE);
  static const Color inputOutline = Color(0x1A101010);
  static const Color emailIconBackground = Color(0x1AD8ECFF);
  static const Color otpInputFill = Color(0xFFF9FAFB);
  static const Color successIconBackground = Color(0x1AD8ECFF);
  static const Color successIconColor = Color(0xFF4CAF50);
  static const Color headerBackground = Color(0xFF4285F4);
  static const Color availableGreen = Color(0xFF4CAF50);
  static const Color unavailableRed = Color(0xFFF44336);
  static const Color dateBackground = Color(0xFFE0E0E0);
  static const Color dateText = Color(0xFF616161);
  static const Color quickActionCardBackground = Color(0xFFE3F2FD);
  static const Color quickActionCardBorder = Color(0xFF90CAF9);
  static const Color openStatusColor = Color(0xFFD8ECFF);
  static const Color openStatusText = Color(0xA636D399);
  static const Color rideNeededStatusColor = Color(0x1AF87171);
  static const Color rideNeededStatusText = Color(0xFFF87171);
}

// --- Event Model ---
class Event {
  final String title;
  final String date;
  final String time;
  final String location;
  final String status; // e.g., "Open", "Ride Needed"

  // Marked the constructor as const
  const Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
  });
}


class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

  // Sample event data (increased to demonstrate "View More")
  final List<Event> upcomingEvents = const [
    Event(
      title: 'Soccer Practice & Fun',
      date: 'Today',
      time: '4:00 PM',
      location: 'City Sports Complex',
      status: 'Open',
    ),
    Event(
      title: 'Emma\'s 10th Birthday Party',
      date: 'Saturday, July 19, 2025',
      time: '3:00 PM - 6:00 PM',
      location: '123 Oak Street, Springfield',
      status: 'Ride Needed',
    ),
    Event(
      title: 'Science Museum Adventure',
      date: 'Saturday, July 26, 2025',
      time: '10:00 AM - 2:00 PM',
      location: 'Downtown Science Museum',
      status: 'Open',
    ),
    Event(
      title: 'Pool Party & Swimming',
      date: 'Friday, July 25, 2025',
      time: '4:00 PM - 7:00 PM',
      location: 'Community Pool Center',
      status: 'Open',
    ),
    // Added more events to trigger "View More" button
    Event(
      title: 'Book Club Meeting',
      date: 'Monday, July 28, 2025',
      time: '7:00 PM',
      location: 'Local Library',
      status: 'Open',
    ),
    Event(
      title: 'Art Workshop',
      date: 'Tuesday, July 29, 2025',
      time: '2:00 PM - 4:00 PM',
      location: 'Art Studio Downtown',
      status: 'Open',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine how many items to show initially
    final int itemsToShow = upcomingEvents.length > 4 ? 4 : upcomingEvents.length;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          // Reload Button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Implement reload logic here, e.g., refetch data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reloading Events...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              context.push('/chat');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itemsToShow, // Show only `itemsToShow` events initially
                itemBuilder: (context, index) {
                  return _buildEventCard(context, upcomingEvents[index]); // Pass context
                },
              ),
            ),
            // "View More" button and "+" icon, conditionally displayed
            if (upcomingEvents.length > 4)
              _buildViewMoreAndAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) { // Added BuildContext context
    Color statusBackgroundColor;
    Color statusTextColor;

    if (event.status == 'Open') {
      statusBackgroundColor = AppColors.openStatusColor;
      statusTextColor = AppColors.openStatusText;
    } else if (event.status == 'Ride Needed') {
      statusBackgroundColor = AppColors.rideNeededStatusColor;
      statusTextColor = AppColors.rideNeededStatusText;
    } else {
      statusBackgroundColor = Colors.grey[200]!;
      statusTextColor = Colors.grey[700]!;
    }

    return GestureDetector( // Wrap with GestureDetector for tap detection
      onTap: () {
        context.push(RoutePaths.eventDetails, extra: event); // Pass the event data
        // context.go(RoutePaths.eventDetails); // Navigate to EventDetailsPage
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        elevation: 0,
        color: Colors.white,
        shadowColor: Color(0x14000000),// No shadow for the card itself
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: statusBackgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      event.status,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: statusTextColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              _buildInfoRow(Icons.calendar_month ,event.date, iconColor: Color(0xFF5A8DEE)),
              const SizedBox(height: 8.0),
              _buildInfoRow(Icons.access_time, event.time, iconColor: Color(0xFFFFE082)),
              const SizedBox(height: 8.0),
              _buildInfoRow(Icons.location_on_outlined, event.location, iconColor: Color(0xFFF87171)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor), // Icon color changed to accentBlue
        const SizedBox(width: 8.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12.0, // Font size changed to 12.0
            fontWeight: FontWeight.w400, // Font weight changed to w400
            color: AppColors.textMedium,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreAndAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to start, Expanded will push
        children: [
          Expanded( // Expanded to take available space and allow centering
            child: Center( // Center the ElevatedButton within the Expanded space
              child: SizedBox( // Wrap with SizedBox for fixed dimensions
                width: 72.0, // Set width as requested
                height: 32.0, // Set height as requested
                child: ElevatedButton(
                  onPressed: () {
                    // Handle "View More" action - in a real app, this would load more events
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loading more events...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.zero, // Remove default padding if using SizedBox for size
                  ),
                  child: const Text(
                    'View More',
                    style: TextStyle(
                      fontSize: 10.0, // Keep the requested font size
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 0.0), // Spacing between the centered button and the right-aligned button
          Center(
            child: SizedBox( // This will naturally be on the right after the Expanded
              width: 40,
              height: 40,
              child: FloatingActionButton(
                heroTag: "addEventFab", // Unique tag for hero animation
                onPressed: () {
                  // Navigate to CreateEventPage
                  context.push(RoutePaths.createeventspage);
                  // context.go(RoutePaths.createeventspage);
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(Icons.add, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

