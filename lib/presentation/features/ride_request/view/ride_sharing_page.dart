import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- RideRequest Model ---
class RideRequest {
  final String requesterName;
  final String requestedBy;
  final String requesterImageUrl;
  final String eventTitle;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String status; // e.g., "Pending Response", "Accepted"

  const RideRequest({
    required this.requesterName,
    required this.requestedBy,
    required this.requesterImageUrl,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.status,
  });
}


class RideSharingPage extends StatefulWidget {
  const RideSharingPage({super.key});

  @override
  State<RideSharingPage> createState() => _RideSharingPageState();
}

class _RideSharingPageState extends State<RideSharingPage> {
  int _selectedIndex = 0; // Default selected index for bottom nav bar

  final List<RideRequest> rideRequests = [
    RideRequest(
      requesterName: 'Ella needs a ride',
      requestedBy: 'Peter',
      requesterImageUrl: AppAssets.ellaProfile, // Placeholder for Ella's image
      eventTitle: 'Sarah\'s Birthday Party',
      eventDate: 'Saturday, July 20th',
      eventTime: '2:00 PM - 5:00 PM',
      eventLocation: '123 Oak Street, Springfield',
      status: 'Pending Response',
    ),
    RideRequest(
      requesterName: 'Jenny needs a ride home',
      requestedBy: 'Lisa',
      requesterImageUrl: AppAssets.jennyProfile, // Placeholder for Jenny's image
      eventTitle: 'Soccer Practice',
      eventDate: 'Today',
      eventTime: '4:00 PM',
      eventLocation: 'City Sports Complex',
      status: 'Accepted',
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Ride Sharing',
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
          children: rideRequests.map((request) => _buildRideRequestCard(request)).toList(),
        ),
      ),
    );
  }

  Widget _buildRideRequestCard(RideRequest request) {
    Color statusBackgroundColor;
    Color statusTextColor;
    Widget? actionButton;

    if (request.status == 'Pending Response') {
      statusBackgroundColor = Color(0xFFFFF8E1);
      statusTextColor = Color(0xCC1B1D2A);
      actionButton = null; // No button for pending
    } else if (request.status == 'Accepted') {
      statusBackgroundColor = Color(0x6636D399);
      statusTextColor = Color(0xCC1B1D2A);
      actionButton = ElevatedButton.icon(
        onPressed: () {
          context.push('/one-to-one-conversation');
          // Handle chat action for accepted ride
        },
        icon: Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF5A8DEE)),
        label: Text(
          'Chat',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1B1D2A),
            fontFamily: 'Poppins',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD8ECFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
      );
    } else {
      statusBackgroundColor = Colors.grey[200]!;
      statusTextColor = Colors.grey[700]!;
      actionButton = null;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: Image.asset(
                    request.requesterImageUrl,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
                  ).image,
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.requesterName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xE51B1D2A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Requested by ${request.requestedBy}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0x991B1D2A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(color: Colors.blue, thickness: 1), // Divider
            const SizedBox(height: 16.0),
            Text(
              request.eventTitle,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Color(0xE51B1D2A),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.calendar_month,  request.eventDate, iconColor: Color(0xFF5A8DEE)),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.access_time, request.eventTime, iconColor: Color(0xFFFFE082)),
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.location_on, request.eventLocation, iconColor: Color(0xFFF87171)),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: statusTextColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                if (actionButton != null) actionButton,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12.0,
            color: Color(0xB21B1D2A),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
