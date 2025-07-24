import 'package:circleslate/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:circleslate/core/constants/app_strings.dart';
import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/presentation/routes/app_routes_names.dart';
import 'package:flutter/material.dart';

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
  static const Color headerBackground = Color(0xFF4285F4); // Blue background for header
  static const Color availableGreen = Color(0xFF4CAF50); // Green for available dates
  static const Color unavailableRed = Color(0xFFF44336); // Red for unavailable dates
  static const Color dateBackground = Color(0xFFE0E0E0); // Light gray for inactive dates
  static const Color dateText = Color(0xFF616161); // Darker gray for date text
  static const Color quickActionCardBackground = Color(0xFFE3F2FD); // Light blue for quick action cards
  static const Color quickActionCardBorder = Color(0xFF90CAF9); // Slightly darker blue for card border
}


// Reusable AuthInputField (copied for self-containment)
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textColorSecondary, fontSize: 11.0, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: AppColors.inputHintColor, fontSize: 10),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textColorSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon,
      ),
    );
  }
}

// Reusable Bottom Navigation Bar Component
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Assuming 'Poppins' is available
      ),
      home: HomePage(),
    );
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

  // State for Calendar dates: 0 = unavailable, 1 = available, 2 = default/inactive
  final Map<int, int> _calendarDateStates = {
    1: 2, 2: 2, 3: 2, 4: 2, 5: 2, 6: 2, 7: 2, 8: 2, 9: 2, 10: 2, 11: 2, 12: 2, 13: 2,
    14: 2, 15: 2, 16: 2, 17: 2, 18: 2, 19: 2, 20: 2, 21: 2, 22: 2, 23: 2, 24: 2,
    25: 2, 26: 2, 27: 2, 28: 2, 29: 2, 30: 2, 31: 2, 32: 2, 33: 2, // For next month's initial days
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter for navigation
      if (index == 0) {
        context.go('/home');
      } else if (index == 1) {
        context.go('/up_coming_events');
      }else if (index == 2) {
        context.go('/groups');
      }else if (index == 3) {
        context.go('/availability');
      }else if (index == 4) {
        context.go('/settings');
      }
      // Add more cases for other tabs as needed
    });
  }

  void _addChildField() {
    setState(() {
      _childNameControllers.add(TextEditingController());
      _childAgeControllers.add(TextEditingController());
    });
  }

  void _toggleDateState(int date) {
    setState(() {
      if (_calendarDateStates[date] == 2) { // If currently default, make it available
        _calendarDateStates[date] = 1;
      } else if (_calendarDateStates[date] == 1) { // If available, make it unavailable
        _calendarDateStates[date] = 0;
      } else { // If unavailable, make it default
        _calendarDateStates[date] = 2;
      }
    });
  }

  Color _getDateColor(int date) {
    switch (_calendarDateStates[date]) {
      case 0:
        return AppColors.unavailableRed; // Unavailable
      case 1:
        return AppColors.availableGreen; // Available
      case 2:
      default:
        return AppColors.dateBackground; // Default/Inactive
    }
  }

  Color _getDateTextColor(int date) {
    switch (_calendarDateStates[date]) {
      case 0:
      case 1:
        return Colors.white; // White text for colored dates
      case 2:
      default:
        return AppColors.dateText; // Darker gray for default dates
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 20.0), // Adjusted padding
            decoration: const BoxDecoration(
              color: AppColors.headerBackground,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Profile Picture
                      // Profile Picture Container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          // The image itself will now be clipped by ClipOval
                        ),
                        child: ClipOval( // Added ClipOval here
                          child: Image.asset(
                            AppAssets.profilePicture, // This should be your profile picture asset
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback for Image.asset if the asset is not found
                              return const Icon(
                                Icons.person,
                                size: 40.0,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 0.0),
                          const Text(
                            'Hello, Peter!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 0.0),
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
                      Icon(Icons.circle, size: 12, color: AppColors.availableGreen),
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
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Image.asset('assets/images/plus.png', width: 25, height: 25,),
                          title: 'Add Event',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add Event Tapped')),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Image.asset('assets/images/event_calendar.png', width: 25, height: 25,),
                          title: 'View Events',
                          onTap: () {
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
                      color: Color(0x26D8ECFF),
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
                                color: AppColors.textDark,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: _addChildField,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(0xFFD8ECFF),
                                ),
                                child: Text(
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
                                            suffixIcon: const Icon(Icons.arrow_drop_down, size: 18),
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
                                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 10),
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
                      ],
                    ),
                  ),
                  // const SizedBox(height: 30.0),

                  // Join Groups Section
                  Text(
                    'Join Groups *',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Select one or more groups you'd like to join",
                    style: TextStyle(
                      fontSize: 8.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0x991B1D2A),
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
                  // const SizedBox(height: 30.0),

                  // Calendar Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'July 2025',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textMedium),
                            onPressed: () {
                              // Handle previous month
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMedium),
                            onPressed: () {
                              // Handle next month
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  //const SizedBox(height: 16.0),
                  _buildCalendarGrid(),
                  // const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 12, color: AppColors.availableGreen),
                      SizedBox(width: 8),
                      Text('Available', style: TextStyle(color: AppColors.textMedium)),
                      SizedBox(width: 20),
                      Icon(Icons.circle, size: 12, color: AppColors.unavailableRed),
                      SizedBox(width: 8),
                      Text('Unavailable', style: TextStyle(color: AppColors.textMedium)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
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
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
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
            fontSize: 14.0,
            color: _groupSelections[title]! ? AppColors.primaryBlue : AppColors.textDark,
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

  Widget _buildCalendarGrid() {
    final List<String> weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final List<DateTime> calendarDates = [];

    DateTime startDate = DateTime(2025, 6, 29);
    for (int i = 0; i < 35; i++) {
      calendarDates.add(startDate.add(Duration(days: i)));
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: calendarDates.length,
          itemBuilder: (context, index) {
            final date = calendarDates[index];
            final state = _calendarDateStates[date.day] ?? 2;

            Color bgColor = Colors.transparent;
            Color borderColor = Colors.transparent;
            Color textColor = AppColors.dateText;

            switch (state) {
              case 0:
                borderColor = AppColors.unavailableRed;
                textColor = AppColors.unavailableRed;
                break;
              case 1:
                borderColor = AppColors.availableGreen;
                textColor = AppColors.availableGreen;
                break;
              case 2:
              default:
                bgColor = AppColors.dateBackground;
                break;
            }

            return GestureDetector(
              onTap: state == 2
                  ? null
                  : () {
                setState(() {
                  _calendarDateStates.updateAll((key, _) => _calendarDateStates[key] == 3 ? 1 : _calendarDateStates[key]!);
                  _calendarDateStates[date.day] = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: borderColor, width: state == 3 ? 0 : 1.5),
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
