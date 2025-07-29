import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/shared_utilities.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';

// PlaceholderScreen for other routes, kept here for self-containment
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.buttonPrimary,
      ),
      body: Center(
        child: Text(
          'Welcome to the $title Page!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    // FIX: Use routerDelegate.currentConfiguration.uri.toString() to get the current location
    final String location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    if (location == '/home') return 0;
    if (location == '/up_coming_events') return 1;
    if (location == '/group_chat') return 2;
    if (location == '/availability') return 3;
    if (location == '/settings') return 4;
    return 0; // Default
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // For the bottom navigation bar

  // Controllers for Child Information
  final List<TextEditingController> _childNameControllers = [TextEditingController()];
  final List<TextEditingController> _childAgeControllers = [TextEditingController()];

  // State for Join Groups checkboxes
  final Map<String, bool> _groupSelections = {
    'Kindergarten': false,
    '1st Grade': false,
    '2nd Grade': false,
    '3rd Grade': false,
    '4th Grade': false,
    'Soccer Team': false,
    'Moms Group': false,
    'Dads Group': false,
    'Basketball': false,
    'Art Class': false,
  };

  @override
  void dispose() {
    for (var controller in _childNameControllers) {
      controller.dispose();
    }
    for (var controller in _childAgeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  void _addChildField() {
    setState(() {
      _childNameControllers.add(TextEditingController());
      _childAgeControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the AvailabilityProvider for changes
    final availabilityProvider = Provider.of<AvailabilityProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 20.0), // Adjusted padding
            decoration: const BoxDecoration(
              color: AppColors.buttonPrimary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push('/profile'); // Replace with your actual profile route
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              AppAssets.profilePicture,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 40.0,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12.0), // Added spacing
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          const Text(
                            'Hello, Peter!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const Text(
                            'Manage Ella’s activities',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xCCFFFFFF),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Available for playdates',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Image.asset(AppAssets.plusIcon, width: 25, height: 25, errorBuilder: (context, error, stackTrace) => const Icon(Icons.add_circle_outline, size: 25, color: AppColors.primaryBlue)),
                          title: 'Add Event',
                          onTap: () {
                            context.push('/create_event');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add Event Tapped')),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Image.asset(AppAssets.eventCalendarIcon, width: 25, height: 25, errorBuilder: (context, error, stackTrace) => const Icon(Icons.calendar_month, size: 25, color: AppColors.primaryBlue)),
                          title: 'View Events',
                          onTap: () {
                            context.push('/up_coming_events');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('View Events Tapped')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Child Information Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryBlue),
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0x26D8ECFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Child Information *',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColorPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: _addChildField,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFFD8ECFF),
                                ),
                                child: const Text(
                                  '+ Add Another Child',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryBlue,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _childNameControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: AppColors.primaryBlue),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: AuthInputField(
                                            controller: _childNameControllers[index],
                                            labelText: 'Child\'s Name',
                                            hintText: 'Child\'s name please..',
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          flex: 1,
                                          child: AuthInputField(
                                            controller: _childAgeControllers[index],
                                            labelText: 'Age',
                                            hintText: 'Age',
                                            keyboardType: TextInputType.number,
                                            // suffixIcon: const Icon(Icons.arrow_drop_down, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Child ${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index > 0)
                                    Positioned(
                                      top: -10,
                                      right: 2,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 2,
                                            )
                                          ],
                                        ),
                                        child: IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(4),
                                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 12),
                                          onPressed: () {
                                            setState(() {
                                              _childNameControllers[index].dispose();
                                              _childAgeControllers[index].dispose();
                                              _childNameControllers.removeAt(index);
                                              _childAgeControllers.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),

                                    ),
                                ],
                              ),

                            );
                          },
                        ),
                        Center(
                          child: ElevatedButton(onPressed: (){
                            // context.push('');
                          },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Color(0x1A000000),
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            child:  const Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0), // Added spacing

                  // Join Groups Section
                  Text(
                    'Join Groups *',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Select one or more groups you'd like to join",
                    style: TextStyle(
                      fontSize: 8.0,
                      fontWeight: FontWeight.w400,
                      color: const Color(0x991B1D2A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: _groupSelections.length,
                    itemBuilder: (context, index) {
                      String groupName = _groupSelections.keys.elementAt(index);
                      return _buildCheckboxTile(groupName);
                    },
                  ),
                  const SizedBox(height: 20.0), // Added spacing

                  // Calendar Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'July 2025',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textColorSecondary),
                            onPressed: () {
                              // Handle previous month
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textColorSecondary),
                            onPressed: () {
                              // Handle next month
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Pass the calendarDateStates from the provider to the calendar grid
                  _buildCalendarGrid(availabilityProvider.calendarDateStates),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 12, color: AppColors.availableGreen),
                      SizedBox(width: 8),
                      Text('Available', style: TextStyle(color: AppColors.textLight)),
                      SizedBox(width: 20),
                      Icon(Icons.circle, size: 12, color: AppColors.unavailableRed),
                      SizedBox(width: 8),
                      Text('Unavailable', style: TextStyle(color: AppColors.textColorSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickActionCard({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.quickActionCardBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.quickActionCardBorder, width: 1.0),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorPrimary,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: _groupSelections[title]! ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _groupSelections[title]! ? AppColors.primaryBlue : AppColors.inputOutline,
          width: 1.0,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: _groupSelections[title]! ? AppColors.primaryBlue : AppColors.textColorPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        value: _groupSelections[title],
        onChanged: (bool? newValue) {
          setState(() {
            _groupSelections[title] = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: AppColors.primaryBlue,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCalendarGrid(Map<int, int> calendarDateStates) {
    final List<String> weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final List<DateTime> calendarDates = [];

    DateTime startDate = DateTime(2025, 6, 29); // Start from the Sunday before July 1st

    for (int i = 0; i < 35; i++) { // Display 5 weeks (7 days * 5 rows = 35 days)
      calendarDates.add(startDate.add(Duration(days: i)));
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: weekdays.length,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                weekdays[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: calendarDates.length,
          itemBuilder: (context, index) {
            final date = calendarDates[index];
            final bool isCurrentMonth = date.month == 7 && date.year == 2025;

            final state = isCurrentMonth ? calendarDateStates[date.day] ?? 2 : 2;

            Color bgColor = Colors.transparent;
            Color borderColor = Colors.transparent;
            Color textColor = AppColors.dateText;

            if (isCurrentMonth) {
              switch (state) {
                case 0: // Unavailable
                  bgColor = AppColors.unavailableRed;
                  textColor = Colors.white;
                  break;
                case 1: // Available
                  bgColor = AppColors.availableGreen;
                  textColor = Colors.white;
                  break;
                case 2: // Default/Inactive
                default:
                  bgColor = AppColors.dateBackground;
                  textColor = AppColors.dateText;
                  break;
              }
            } else {
              bgColor = AppColors.dateBackground.withOpacity(0.5);
              textColor = AppColors.dateText.withOpacity(0.5);
            }


            return GestureDetector(
              onTap: isCurrentMonth
                  ? () {
                Provider.of<AvailabilityProvider>(context, listen: false).toggleDateState(date.day);
              }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: borderColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
