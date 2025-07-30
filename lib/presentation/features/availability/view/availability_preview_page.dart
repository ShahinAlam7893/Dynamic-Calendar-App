import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/shared_utilities.dart'; // Assuming this has AuthInputField or other common widgets
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    final double appBarTitleFontSize = screenWidth * 0.045;
    final double sectionTitleFontSize = screenWidth * 0.04;
    final double dayNameFontSize = screenWidth * 0.038;
    final double statusTextFontSize = screenWidth * 0.032;

    // Responsive spacing
    final double mainPadding = screenWidth * 0.06;
    final double sectionSpacing = screenWidth * 0.04;
    final double itemVerticalPadding = screenWidth * 0.02;
    final double statusPaddingHorizontal = screenWidth * 0.025;
    final double statusPaddingVertical = screenWidth * 0.012;
    final double borderRadiusSmall = screenWidth * 0.03;
    final double borderRadiusMedium = screenWidth * 0.05;
    final double fabSize = screenWidth * 0.14; // Adjust as needed for FAB size
    final double fabIconSize = screenWidth * 0.07; // Adjust as needed for FAB icon size


    // Watch the AvailabilityProvider for changes
    final availabilityProvider = Provider.of<AvailabilityProvider>(context);

    // Get today's weekday to highlight "Today"
    final int todayWeekday = DateTime.now().weekday; // 1=Monday, ..., 7=Sunday

    // Map DateTime.weekday to a displayable string and an index for _weeklyAvailability
    // Ensure that DateTime.sunday is handled correctly as 7 or 0 depending on usage if not standard
    // Flutter's DateTime.sunday is 7, Monday is 1.
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
          icon: Icon(Icons.arrow_back, color: Colors.white, size: screenWidth * 0.06), // Responsive icon size
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarTitleFontSize, // Responsive font size
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mainPadding), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week\'s Availability',
              style: TextStyle(
                fontSize: sectionTitleFontSize, // Responsive font size
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: sectionSpacing), // Responsive spacing
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadiusSmall), // Responsive border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6, // Blur radius can often remain fixed or scale minimally
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
                  // Make sure your AvailabilityProvider has _weeklyAvailability and _weeklyTimeRanges maps
                  final int status = availabilityProvider.weeklyAvailability[dayWeekday] ?? 2; // Default to Tentative
                  final String timeRange = availabilityProvider.weeklyTimeRanges[dayWeekday] ?? 'Not Set';

                  final String statusText = _getStatusText(status);
                  final Color statusColor = _getStatusColor(status);

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: itemVerticalPadding), // Responsive padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isToday ? '$dayName (Today)' : dayName,
                          style: TextStyle(
                            fontSize: dayNameFontSize, // Responsive font size
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: AppColors.textColorPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: statusPaddingHorizontal, vertical: statusPaddingVertical), // Responsive padding
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(borderRadiusMedium), // Responsive border radius
                            border: Border.all(color: statusColor, width: 1.0), // Border width can remain fixed or scale slightly
                          ),
                          child: Text(
                            '$statusText ${timeRange}',
                            style: TextStyle(
                              fontSize: statusTextFontSize, // Responsive font size
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
            SizedBox(height: screenWidth * 0.07), // Responsive spacing before FAB
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: fabSize, // Responsive FAB size
                height: fabSize, // Responsive FAB size
                child: FloatingActionButton(
                  onPressed: () {
                    // Navigate to the availability settings page to edit
                    context.push('/availability');
                  },
                  backgroundColor: AppColors.primaryBlue,
                  shape: const CircleBorder(), // Ensure it remains circular
                  child: Icon(Icons.add, color: Colors.white, size: fabIconSize), // Responsive icon size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This method is for determining the selected index of a bottom navigation bar,
  // which is typically part of a Scaffold with a BottomNavigationBar, not this standalone page.
  // It's fine to keep it here if it's reused, but it won't directly affect this page's UI.
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