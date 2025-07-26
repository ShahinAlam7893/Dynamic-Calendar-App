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
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
            // Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              context.push('/chat');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centered all content
                  children: [
                    const Text(
                      'Birthday Party at Sarah\'s',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center, // Ensure text is centered
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                      children: [
                        // Date
                        Icon(Icons.calendar_month, size: 16, color: AppColors.primaryBlue),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Saturday, March 15, 2025', // Corrected date as per image
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.primaryBlue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // Time
                        Icon(Icons.access_time, size: 16, color: AppColors.primaryBlue),
                        const SizedBox(width: 8.0),
                        const Text(
                          '3:00 PM - 6:00 PM',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.primaryBlue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                      children: [
                        Icon(Icons.location_on, size: 16, color: Color(0xFFF87171)),
                        const SizedBox(width: 8.0),
                        const Text(
                          '123 Oak Street, Springfield',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: AppColors.textMedium,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Host Information Card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: Image.asset(
                            AppAssets.sarahMartinezMom, // Host image
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                          ).image,
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Sarah Martinez',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Host • Emma’s Mom',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textMedium,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
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
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            child: Text(
                              'I\'m Joining',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: _isJoining ? Colors.white : AppColors.textDark,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
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
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: !_isJoining ? Colors.white : Color(0xFFF87171),
                                fontFamily: 'Poppins',
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
            const SizedBox(height: 16.0),

            // Who's Joining Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Color(0xFF5A8DEE)),
                      const Text(
                        'Who\'s Joining',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '${participants.where((p) => p.status == 'Going').length} Going',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBlue,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle chat action
                    },
                    icon: Icon(Icons.chat, size: 18, color: AppColors.chatButtonTextColor),
                    label: Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chatButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                return _buildParticipantTile(participants[index]);
              },
            ),
            const SizedBox(height: 16.0),

            // Ride Requests Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.directions_car_outlined, size: 24, color: AppColors.primaryBlue),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Ride Requests',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.home, size: 20, color: AppColors.goingButtonColor),
                        Image(image: AssetImage('assets/images/3d-house.png',),height: 20, width: 20,),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Available for ride home',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Mike Wilson + Can drop off anyone near downtown area',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textMedium,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
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
                        ),
                        child: const Text(
                          'Request Ride',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.requestRideButtonTextColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Spacing for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(Participant participant) {
    Color statusColor;
    Color statusTestColor;
    switch (participant.status) {
      case 'Going':
        statusColor = Color(0x8036D399);
        statusTestColor = Color(0xCC1B1D2A);
        break;
      case 'Not Going':
        statusColor = Color(0x80F87171);
        statusTestColor = Color(0xCC1B1D2A);
        break;
      case 'Host':
      default:
        statusColor = Color(0xFF36D399);
        statusTestColor = Color(0xFF1B1D2A);
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: Image.asset(
                participant.imageUrl ?? AppAssets.profilePicture,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
              ).image,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (participant.description != null)
                    Text(
                      participant.description!,
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: AppColors.textMedium,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                participant.status,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: statusTestColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
