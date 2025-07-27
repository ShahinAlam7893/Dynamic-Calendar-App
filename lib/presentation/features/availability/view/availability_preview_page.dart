import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/shared_utilities.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:circleslate/core/constants/app_colors.dart'; // Import AppColors

class AvailabilityPreviewPage extends StatelessWidget {
  const AvailabilityPreviewPage({super.key});

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Busy';
      case 1:
        return 'Available';
      case 2:
      default:
        return 'Tentative';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return AppColors.unavailableRed;
      case 1:
        return AppColors.availableGreen;
      case 2:
      default:
        return AppColors.primaryBlue; // Using primaryBlue for Tentative
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the AvailabilityProvider for changes
    final availabilityProvider = Provider.of<AvailabilityProvider>(context);

    // Get today's weekday to highlight "Today"
    final int todayWeekday = DateTime.now().weekday; // 1=Monday, ..., 7=Sunday

    // Map DateTime.weekday to a displayable string and an index for _weeklyAvailability
    final List<Map<String, dynamic>> weekDaysData = [
      {'name': 'Sunday', 'weekday': DateTime.sunday},
      {'name': 'Monday', 'weekday': DateTime.monday},
      {'name': 'Tuesday', 'weekday': DateTime.tuesday},
      {'name': 'Wednesday', 'weekday': DateTime.wednesday},
      {'name': 'Thursday', 'weekday': DateTime.thursday},
      {'name': 'Friday', 'weekday': DateTime.friday},
      {'name': 'Saturday', 'weekday': DateTime.saturday},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.buttonPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              // Handle chat action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week\'s Availability',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weekDaysData.length,
                itemBuilder: (context, index) {
                  final dayName = weekDaysData[index]['name'];
                  final dayWeekday = weekDaysData[index]['weekday'];
                  final isToday = dayWeekday == todayWeekday;

                  // Get status and time range from the provider's weekly data
                  final int status = availabilityProvider.weeklyAvailability[dayWeekday] ?? 2; // Default to Tentative
                  final String timeRange = availabilityProvider.weeklyTimeRanges[dayWeekday] ?? 'Not Set';

                  final String statusText = _getStatusText(status);
                  final Color statusColor = _getStatusColor(status);


                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isToday ? '$dayName (Today)' : dayName,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: AppColors.textColorPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: statusColor, width: 1.0),
                          ),
                          child: Text(
                            '$statusText $timeRange',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to the availability settings page to edit
                  context.push('/availability');
                },
                backgroundColor: AppColors.primaryBlue,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/up_coming_events');
          } else if (index == 2) {
            context.go('/group_chat');
          } else if (index == 3) {
            context.go('/availability'); // Navigate to Availability Settings
          } else if (index == 4) {
            context.go('/settings');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    if (location == '/home') return 0;
    if (location == '/up_coming_events') return 1;
    if (location == '/group_chat') return 2;
    if (location == '/availability' || location == '/availability_preview') return 3; // Both availability pages fall under this tab
    if (location == '/settings') return 4;
    return 0; // Default
  }
}
