import 'package:circleslate/main.dart' hide AppAssets;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:circleslate/core/constants/app_assets.dart';

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
  static const Color notGoingButtonColor = Color(0xFFF44336); // Red for "Not Going"
  static const Color chatButtonColor = Color(0xFFE3F2FD); // Light blue for chat button background
  static const Color chatButtonTextColor = Color(0xFF4285F4); // Blue for chat button text
  static const Color requestRideButtonColor = Color(0xFF5A8DEE); // Accent blue for Request Ride
  static const Color requestRideButtonTextColor = Colors.white;
  static const Color rideRequestCardBackground = Color(0xFFE3F2FD); // Light blue for ride request card
  static const Color rideRequestCardBorder = Color(0xFF90CAF9); // Slightly darker blue for card border
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
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
class Participant {
  final String name;
  final String? description; // e.g., "Emma's Mom", "Emma (10 years old)"
  final String status; // "Going", "Not Going", "Host"
  final String? imageUrl; // Path to profile picture asset

  const Participant({
    required this.name,
    this.description,
    required this.status,
    this.imageUrl,
  });
}


class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  int _selectedIndex = 1; // Assuming Events tab is selected
  bool _isJoining = true; // State for "I'm Joining" / "Decline" buttons

  final List<Participant> participants = [
    Participant(
      name: 'Sarah Martinez',
      description: 'Emma’s Mom',
      status: 'Host',
      imageUrl: AppAssets.sarahMartinezMom,
    ),
    const Participant(
      name: 'Peter Johnson',
      description: 'Ella (10 years old)',
      status: 'Going',
      imageUrl: AppAssets.peterJohnson, // Assuming asset path
    ),
    const Participant(
      name: 'Mike Wilson',
      description: 'Jake (9 years old)',
      status: 'Going',
      imageUrl: AppAssets.mikeWilson, // Assuming asset path
    ),
    const Participant(
      name: 'Sarah Martinez',
      description: 'Mia (10 years old)',
      status: 'Not Going',
      imageUrl: AppAssets.sarahMartinez, // Assuming asset path
    ),
    const Participant(
      name: 'Jennifer Davis',
      description: 'Sophia (9 years old)',
      status: 'Going',
      imageUrl: AppAssets.jenniferDavis, // Assuming asset path
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define base font scale factors for different text types
    final double titleFontSize = screenWidth * 0.055; // For main event title
    final double appBarTitleFontSize = screenWidth * 0.05; // For app bar title
    final double subtitleFontSize = screenWidth * 0.04; // For section headers, participant name
    final double bodyFontSize = screenWidth * 0.035; // For date/time, general text, buttons
    final double smallFontSize = screenWidth * 0.03; // For descriptions, status tags

    // Define responsive icon sizes
    final double generalIconSize = screenWidth * 0.04; // For calendar, time, location
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive overall padding
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
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive card padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Birthday Party at Sarah\'s',
                      style: TextStyle(
                        fontSize: titleFontSize, // Responsive font size
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenWidth * 0.02), // Responsive spacing
                    // Date and Time using Wrap for responsiveness
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: screenWidth * 0.03, // Horizontal spacing between items
                      runSpacing: screenWidth * 0.015, // Vertical spacing if items wrap
                      children: [
                        // Date
                        Row(
                          mainAxisSize: MainAxisSize.min, // Important for Wrap
                          children: [
                            Icon(Icons.calendar_month, size: generalIconSize, color: AppColors.primaryBlue), // Responsive icon size
                            SizedBox(width: screenWidth * 0.015), // Responsive spacing
                            Text(
                              'Saturday, March 15, 2025',
                              style: TextStyle(
                                fontSize: bodyFontSize, // Responsive font size
                                color: AppColors.primaryBlue,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Time
                        Row(
                          mainAxisSize: MainAxisSize.min, // Important for Wrap
                          children: [
                            Icon(Icons.access_time, size: generalIconSize, color: AppColors.primaryBlue), // Responsive icon size
                            SizedBox(width: screenWidth * 0.015), // Responsive spacing
                            Text(
                              '3:00 PM - 6:00 PM',
                              style: TextStyle(
                                fontSize: bodyFontSize, // Responsive font size
                                color: AppColors.primaryBlue,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.02), // Responsive spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: generalIconSize, color: const Color(0xFFF87171)), // Responsive icon size
                        SizedBox(width: screenWidth * 0.015), // Responsive spacing
                        Expanded( // Ensure location text expands
                          child: Text(
                            '123 Oak Street, Springfield',
                            style: TextStyle(
                              fontSize: bodyFontSize, // Responsive font size
                              color: AppColors.textMedium,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
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
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive card padding
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.06, // Responsive avatar size
                          backgroundImage: Image.asset(
                            AppAssets.sarahMartinezMom, // Host image
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                          ).image,
                        ),
                        SizedBox(width: screenWidth * 0.03), // Responsive spacing
                        Expanded( // Host name and description should take remaining space
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Martinez',
                                style: TextStyle(
                                  fontSize: subtitleFontSize, // Responsive font size
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Host • Emma’s Mom',
                                style: TextStyle(
                                  fontSize: smallFontSize, // Responsive font size
                                  color: AppColors.textMedium,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.04), // Responsive spacing
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isJoining = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isJoining ? AppColors.primaryBlue : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: _isJoining ? AppColors.primaryBlue : AppColors.inputOutline),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03), // Responsive vertical padding
                            ),
                            child: FittedBox( // Use FittedBox to ensure text fits on very small buttons
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'I\'m Joining',
                                style: TextStyle(
                                  fontSize: bodyFontSize, // Responsive font size
                                  fontWeight: FontWeight.w500,
                                  color: _isJoining ? Colors.white : AppColors.textDark,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03), // Responsive spacing
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isJoining = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isJoining ? AppColors.notGoingButtonColor : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: !_isJoining ? AppColors.notGoingButtonColor : AppColors.inputOutline),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03), // Responsive vertical padding
                            ),
                            child: FittedBox( // Use FittedBox to ensure text fits
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                  fontSize: bodyFontSize, // Responsive font size
                                  fontWeight: FontWeight.w500,
                                  color: !_isJoining ? Colors.white : const Color(0xFFF87171),
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
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02), // Responsive padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // This section for "Who's Joining" and count
                  Flexible(
                    flex: 3, // Give more flexibility to this side
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, size: generalIconSize, color: const Color(0xFF5A8DEE)), // Responsive icon size
                        SizedBox(width: screenWidth * 0.01), // Responsive spacing
                        Flexible( // Ensure "Who's Joining" text can shrink
                          child: Text(
                            'Who\'s Joining',
                            style: TextStyle(
                              fontSize: subtitleFontSize, // Responsive font size
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02), // Responsive spacing
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015, vertical: screenWidth * 0.008), // Responsive padding
                          decoration: BoxDecoration(
                            color: AppColors.lightBlueBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '${participants.where((p) => p.status == 'Going').length} Going',
                            style: TextStyle(
                              fontSize: smallFontSize, // Responsive font size
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
                  SizedBox(width: screenWidth * 0.02), // Small space before chat button
                  // Chat button
                  Flexible(
                    flex: 2, // Give less flexibility to chat button, allowing it to maintain size better
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle chat action
                      },
                      icon: Icon(Icons.chat, size: screenWidth * 0.045, color: AppColors.chatButtonTextColor), // Responsive icon size
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
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenWidth * 0.015), // Responsive padding
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              itemBuilder: (context, index) {
                return _buildParticipantTile(context, participants[index]); // Pass context
              },
            ),
            SizedBox(height: screenWidth * 0.04), // Responsive spacing

            // Ride Requests Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02), // Responsive padding
              child: Row(
                children: [
                  Icon(Icons.directions_car_outlined, size: sectionIconSize, color: AppColors.primaryBlue), // Responsive icon size
                  SizedBox(width: screenWidth * 0.02), // Responsive spacing
                  Expanded( // Make text responsive
                    child: Text(
                      'Ride Requests',
                      style: TextStyle(
                        fontSize: subtitleFontSize, // Responsive font size
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
                side: BorderSide(color: AppColors.rideRequestCardBorder, width: 1),
              ),
              elevation: 0,
              color: AppColors.rideRequestCardBackground,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // Responsive card padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image(image: const AssetImage('assets/images/3d-house.png',),height: screenWidth * 0.05, width: screenWidth * 0.05,), // Responsive image size
                        SizedBox(width: screenWidth * 0.02), // Responsive spacing
                        Expanded( // Make text responsive
                          child: Text(
                            'Available for ride home',
                            style: TextStyle(
                              fontSize: bodyFontSize, // Responsive font size
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
                    SizedBox(height: screenWidth * 0.02), // Responsive spacing
                    Text(
                      'Mike Wilson + Can drop off anyone near downtown area',
                      style: TextStyle(
                        fontSize: smallFontSize, // Responsive font size
                        color: AppColors.textMedium,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2, // Allow to wrap for description
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenWidth * 0.04), // Responsive spacing
                    SizedBox(
                      width: double.infinity,
                      height: screenWidth * 0.1, // Responsive height for button
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/ride_share');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.requestRideButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Responsive horizontal padding
                        ),
                        child: FittedBox( // Use FittedBox for button text
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Request Ride',
                            style: TextStyle(
                              fontSize: bodyFontSize, // Consistent font size
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
            SizedBox(height: screenWidth * 0.05), // Spacing for bottom nav bar
          ],
        ),
      ),
    );
  }

  // Passing BuildContext to _buildParticipantTile for responsive sizing
  Widget _buildParticipantTile(BuildContext context, Participant participant) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double participantAvatarRadius = screenWidth * 0.05;
    final double participantNameFontSize = screenWidth * 0.038;
    final double participantDescFontSize = screenWidth * 0.03;
    final double statusTagFontSize = screenWidth * 0.03;

    Color statusColor;
    Color statusTestColor;
    switch (participant.status) {
      case 'Going':
        statusColor = const Color(0x8036D399);
        statusTestColor = const Color(0xCC1B1D2A);
        break;
      case 'Not Going':
        statusColor = const Color(0x80F87171);
        statusTestColor = const Color(0xCC1B1D2A);
        break;
      case 'Host':
      default:
        statusColor = const Color(0xFF36D399);
        statusTestColor = const Color(0xFF1B1D2A);
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.01), // Responsive vertical margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
        child: Row(
          children: [
            CircleAvatar(
              radius: participantAvatarRadius, // Responsive avatar size
              backgroundImage: Image.asset(
                participant.imageUrl ?? AppAssets.profilePicture,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
              ).image,
            ),
            SizedBox(width: screenWidth * 0.03), // Responsive spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.name,
                    style: TextStyle(
                      fontSize: participantNameFontSize, // Responsive font size
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (participant.description != null)
                    Text(
                      participant.description!,
                      style: TextStyle(
                        fontSize: participantDescFontSize, // Responsive font size
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenWidth * 0.01), // Responsive padding
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                participant.status,
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