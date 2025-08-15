import 'dart:convert';

import 'package:circleslate/core/network/endpoints.dart';
import 'package:circleslate/presentation/features/event_management/models/eventsModels.dart';
import 'package:circleslate/presentation/features/ride_request/view/ride_sharing_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/eventManagementControllers.dart';

// --- AppColors (Copied for self-containment) ---
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
  static const Color toggleButtonActiveBg = Color(0xFF4285F4);
  static const Color toggleButtonActiveText = Colors.white;
  static const Color toggleButtonInactiveBg = Colors.white;
  static const Color toggleButtonInactiveText = Color(0xFF4285F4);
  static const Color toggleButtonBorder = Color(0xFFE0E0E0);
  static const Color goingButtonColor = Color(0xFF4CAF50); // Green for "Going"
  static const Color notGoingButtonColor = Color(
    0xFFF44336,
  ); // Red for "Not Going"
  static const Color chatButtonColor = Color(
    0xFFE3F2FD,
  ); // Light blue for chat button background
  static const Color chatButtonTextColor = Color(
    0xFF4285F4,
  ); // Blue for chat button text
  static const Color requestRideButtonColor = Color(
    0xFF5A8DEE,
  ); // Accent blue for Request Ride
  static const Color requestRideButtonTextColor = Colors.white;
  static const Color rideRequestCardBackground = Color(
    0xFFE3F2FD,
  ); // Light blue for ride request card
  static const Color rideRequestCardBorder = Color(
    0xFF90CAF9,
  ); // Slightly darker blue for card border
}

// --- CustomBottomNavigationBar (Copied for self-containment) ---
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note_outlined),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Availability',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed, // Ensures all labels are visible
      backgroundColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

// --- Participant Model ---
// class Participant {
//   final String name;
//   final String? description; // e.g., "Emma's Mom", "Emma (10 years old)"
//   final String status; // "Going", "Not Going", "Host"
//   final String? imageUrl; // Path to profile picture asset

//   const Participant({
//     required this.name,
//     this.description,
//     required this.status,
//     this.imageUrl,
//   });
// }

class EventDetailsPage extends StatefulWidget {
  final String eventId;
  const EventDetailsPage({super.key, required this.eventId});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int _selectedIndex = 1; // Assuming Events tab is selected
  bool _isJoining = true; // State for "I'm Joining" / "Decline" buttons
  String? _responseStatus;

  late Future<Event> _eventDetails;

  @override
  void initState() {
    super.initState();
    _eventDetails = EventService.fetchEventDetails(widget.eventId);
  }

  void _handleResponse(String responseType) {
    EventService.sendResponse(widget.eventId, responseType)
        .then((_) {
          setState(() {
            _isJoining = responseType == 'going';
          });

          // Fetch the updated event details after the response is sent
          _refreshEventDetails();
        })
        .catchError((error) {
          print('Error submitting response: $error');
          // Handle error (show message or alert to the user)
        });
  }

  void _refreshEventDetails() {
    setState(() {
      _eventDetails = EventService.fetchEventDetails(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define base font scale factors for different text types
    final double titleFontSize = screenWidth * 0.055; // For main event title
    final double appBarTitleFontSize = screenWidth * 0.05; // For app bar title
    final double subtitleFontSize =
        screenWidth * 0.04; // For section headers, participant name
    final double bodyFontSize =
        screenWidth * 0.035; // For date/time, general text, buttons
    final double smallFontSize =
        screenWidth * 0.03; // For descriptions, status tags

    // Define responsive icon sizes
    final double generalIconSize =
        screenWidth * 0.04; // For calendar, time, location
    final double sectionIconSize = screenWidth * 0.06; // For people, car icons

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarTitleFontSize, // Responsive App Bar title font size
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Event>(
        future: _eventDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final event = snapshot.data!;
          final host = event.host;
          final Response = event.responses;
          final bool isRideNeeded = event.rideNeededForEvent;
          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Header Card
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: screenWidth * 0.03,
                          runSpacing: screenWidth * 0.015,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: screenWidth * 0.04,
                                  color: AppColors.primaryBlue,
                                ),
                                SizedBox(width: screenWidth * 0.015),
                                Text(
                                  event.date,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: AppColors.primaryBlue,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: screenWidth * 0.04,
                                  color: AppColors.primaryBlue,
                                ),
                                SizedBox(width: screenWidth * 0.015),
                                Text(
                                  '${event.startTime} - ${event.endTime}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: AppColors.primaryBlue,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: screenWidth * 0.04,
                              color: const Color(0xFFF87171),
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Text(
                              event.location,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: AppColors.textMedium,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.04), // Responsive spacing
                // Host Information Card
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(
                      screenWidth * 0.04,
                    ), // Responsive card padding
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.06, // Adjust size
                              backgroundImage: NetworkImage(
                                host.profilePhotoUrl,
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                // Handle error if image doesn't load
                              },
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ), // Responsive spacing
                            Expanded(
                              // Host name and description should take remaining space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    host.fullName,
                                    style: TextStyle(
                                      fontSize:
                                          subtitleFontSize, // Responsive font size
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (host.childrenNames.isNotEmpty)
                                    Text(
                                      '${host.childrenNames.join(", ")}\'s Parents',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        color: AppColors.textMedium,
                                        fontFamily: 'Poppins',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  // Text(
                                  //   'Host • Emma’s Mom',
                                  //   style: TextStyle(
                                  //     fontSize:
                                  //         smallFontSize, // Responsive font size
                                  //     color: AppColors.textMedium,
                                  //     fontFamily: 'Poppins',
                                  //   ),
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenWidth * 0.04,
                        ), // Responsive spacing
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isJoining =
                                        true; // User selected "I'm Joining"
                                  });
                                  // Call the API to send the response
                                  _handleResponse('going');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isJoining
                                      ? AppColors.primaryBlue
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                      color: _isJoining
                                          ? AppColors.primaryBlue
                                          : AppColors.inputOutline,
                                    ),
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.03,
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'I\'m Joining',
                                    style: TextStyle(
                                      fontSize: bodyFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: _isJoining
                                          ? Colors.white
                                          : AppColors.textDark,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isJoining =
                                        false; // User selected "Decline"
                                  });
                                  // Call the API to send the response
                                  _handleResponse('not_going');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_isJoining
                                      ? AppColors.notGoingButtonColor
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                      color: !_isJoining
                                          ? AppColors.notGoingButtonColor
                                          : AppColors.inputOutline,
                                    ),
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.03,
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(
                                      fontSize: bodyFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: !_isJoining
                                          ? Colors.white
                                          : const Color(0xFFF87171),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.04), // Responsive spacing
                // Who's Joining Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.02,
                  ), // Responsive padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // This section for "Who's Joining" and count
                      Flexible(
                        flex: 3, // Give more flexibility to this side
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people,
                              size: generalIconSize,
                              color: const Color(0xFF5A8DEE),
                            ), // Responsive icon size
                            SizedBox(
                              width: screenWidth * 0.01,
                            ), // Responsive spacing
                            Flexible(
                              // Ensure "Who's Joining" text can shrink
                              child: Text(
                                'Who\'s Joining',
                                style: TextStyle(
                                  fontSize:
                                      subtitleFontSize, // Responsive font size
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ), // Responsive spacing
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.015,
                                vertical: screenWidth * 0.008,
                              ), // Responsive padding
                              decoration: BoxDecoration(
                                color: AppColors.lightBlueBackground,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '${event.goingCount} Going',
                                style: TextStyle(
                                  fontSize:
                                      smallFontSize, // Responsive font size
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryBlue,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.02,
                      ), // Small space before chat button
                      // Chat button
                      Flexible(
                        flex:
                            2, // Give less flexibility to chat button, allowing it to maintain size better
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle chat action
                          },
                          icon: Icon(
                            Icons.chat,
                            size: screenWidth * 0.045,
                            color: AppColors.chatButtonTextColor,
                          ), // Responsive icon size
                          label: Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: bodyFontSize, // Consistent font size
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.chatButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.025,
                              vertical: screenWidth * 0.015,
                            ), // Responsive padding
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Response.length,
                  itemBuilder: (context, index) {
                    return _buildParticipantTile(
                      context,
                      Response[index],
                      host,
                    ); // Pass context
                  },
                ),
                SizedBox(height: screenWidth * 0.04), // Responsive spacing
                // Ride Requests Section
                if (isRideNeeded) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.02,
                    ), // Responsive padding
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: sectionIconSize,
                          color: AppColors.primaryBlue,
                        ), // Responsive icon size
                        SizedBox(
                          width: screenWidth * 0.02,
                        ), // Responsive spacing
                        Expanded(
                          // Make text responsive
                          child: Text(
                            'Ride Requests',
                            style: TextStyle(
                              fontSize:
                                  subtitleFontSize, // Responsive font size
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: AppColors.rideRequestCardBorder,
                        width: 1,
                      ),
                    ),
                    elevation: 0,
                    color: AppColors.rideRequestCardBackground,
                    child: Padding(
                      padding: EdgeInsets.all(
                        screenWidth * 0.04,
                      ), // Responsive card padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: const AssetImage(
                                  'assets/images/3d-house.png',
                                ),
                                height: screenWidth * 0.05,
                                width: screenWidth * 0.05,
                              ), // Responsive image size
                              SizedBox(
                                width: screenWidth * 0.02,
                              ), // Responsive spacing
                              Expanded(
                                // Make text responsive
                                child: Text(
                                  'Available for ride home',
                                  style: TextStyle(
                                    fontSize:
                                        bodyFontSize, // Responsive font size
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenWidth * 0.02,
                          ), // Responsive spacing
                          // Text(
                          //   'Mike Wilson + Can drop off anyone near downtown area',
                          //   style: TextStyle(
                          //     fontSize: smallFontSize, // Responsive font size
                          //     color: AppColors.textMedium,
                          //     fontFamily: 'Poppins',
                          //   ),
                          //   maxLines: 2, // Allow to wrap for description
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          SizedBox(
                            height: screenWidth * 0.04,
                          ), // Responsive spacing
                          SizedBox(
                            width: double.infinity,
                            height:
                                screenWidth *
                                0.1, // Responsive height for button
                            child: ElevatedButton(
                              onPressed: () {
                                sendRideRequest(
                                  event.id, // Event ID
                                  'lol', // Pickup location (replace with user input)
                                  'string', // Special instructions (replace with user input)
                                  context, // Pass BuildContext for SnackBar
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.requestRideButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ), // Responsive horizontal padding
                              ),
                              child: FittedBox(
                                // Use FittedBox for button text
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Send Request Ride',
                                  style: TextStyle(
                                    fontSize:
                                        bodyFontSize, // Consistent font size
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.requestRideButtonTextColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenWidth * 0.02),
                          SizedBox(
                            width: double.infinity,
                            height:
                                screenWidth *
                                0.1, // Responsive height for button
                            child: ElevatedButton(
                              onPressed: () {
                                print(event.id);
                                // Example of navigation from EventDetailsPage to RideSharingPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RideSharingPage(
                                      eventId: event.id,
                                      eventdate: event.date,
                                      eventstartTime: event.startTime,
                                      eventendTime: event.endTime,
                                      eventlocation: event.location,
                                    ),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.requestRideButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                ), // Responsive horizontal padding
                              ),
                              child: FittedBox(
                                // Use FittedBox for button text
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Request Ride List',
                                  style: TextStyle(
                                    fontSize:
                                        bodyFontSize, // Consistent font size
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.requestRideButtonTextColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(
                  height: screenWidth * 0.05,
                ), // Spacing for bottom nav bar
              ],
            ),
          );
        },
      ),
    );
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    print("🔑 _getToken returned: $token");
    return token;
  }

  Future<void> sendRideRequest(
    String eventId,
    String pickupLocation,
    String specialInstructions,
    BuildContext context,
  ) async {
    final token = await _getToken();
    // API endpoint
    final String apiUrl = '${Urls.baseUrl}/event/events/$eventId/request_ride/';

    // Authorization header
    final headers = {
      'Authorization': 'Bearer $token', // Replace with actual token
      'Content-Type': 'application/json',
    };

    // Request body
    final body = jsonEncode({
      'pickup_location': pickupLocation,
      'special_instructions': specialInstructions,
    });

    // Print out the API endpoint, request body, and headers for debugging
    print('API URL: $apiUrl');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Print response details for debugging
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        // Successful request
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ride request sent: ${responseData['status_display']}',
            ),
          ),
        );
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  // Passing BuildContext to _buildParticipantTile for responsive sizing
  Widget _buildParticipantTile(
    BuildContext context,
    Response response,
    Host host,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double participantAvatarRadius = screenWidth * 0.05;
    final double participantNameFontSize = screenWidth * 0.038;
    final double participantDescFontSize = screenWidth * 0.03;
    final double statusTagFontSize = screenWidth * 0.03;

    String participantStatus = response.responseDisplay;
    if (response.userId == host.id) {
      participantStatus = 'Host'; // Mark the first participant as Host
    }

    Color statusColor;
    Color statusTestColor;
    switch (participantStatus) {
      case 'Going':
        statusColor = const Color(0x8036D399);
        statusTestColor = const Color(0xCC1B1D2A);
        break;
      case 'Not Going':
        statusColor = const Color(0x80F87171);
        statusTestColor = const Color(0xCC1B1D2A);
        break;
      case 'Host': // Marking as Host
      default:
        statusColor = const Color(0xFF36D399);
        statusTestColor = const Color(0xFF1B1D2A);
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.01,
      ), // Responsive vertical margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
        child: Row(
          children: [
            CircleAvatar(
              radius: participantAvatarRadius,
              backgroundImage: response.profilePhotoUrl.isNotEmpty
                  ? NetworkImage(response.profilePhotoUrl)
                  : AssetImage(
                      'assets/images/default_profile_picture.png',
                    ), // Fallback image
            ),

            SizedBox(width: screenWidth * 0.03), // Responsive spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response.username,
                    style: TextStyle(
                      fontSize: participantNameFontSize, // Responsive font size
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (response.childrenNames.isNotEmpty)
                    Text(
                      response.childrenNames.join(", ") + "'s Parents",
                      style: TextStyle(
                        fontSize: participantDescFontSize,
                        color: AppColors.textMedium,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenWidth * 0.01,
              ), // Responsive padding
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                participantStatus,
                style: TextStyle(
                  fontSize: statusTagFontSize, // Responsive font size
                  fontWeight: FontWeight.w500,
                  color: statusTestColor,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
