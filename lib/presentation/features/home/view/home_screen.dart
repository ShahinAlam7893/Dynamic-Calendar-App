import 'package:circleslate/core/constants/app_assets.dart';
import 'package:circleslate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:circleslate/core/constants/shared_utilities.dart';
import 'package:circleslate/presentation/common_providers/availability_provider.dart';
import 'package:intl/intl.dart'; // For date formatting

// --- AuthInputField --- (Copied from previous response for self-containment)
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final double labelFontSize = screenWidth * 0.032;
    final double hintFontSize = screenWidth * 0.03;
    final double inputContentPaddingVertical = screenWidth * 0.035;
    final double inputContentPaddingHorizontal = screenWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: AppColors.textColorSecondary,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.01),
              borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.01),
              borderSide: const BorderSide(color: AppColors.inputOutline, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.01),
              borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            ),
            hintStyle: TextStyle(color: AppColors.inputHintColor, fontSize: hintFontSize, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: inputContentPaddingVertical, horizontal: inputContentPaddingHorizontal),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textColorSecondary,
                size: screenWidth * 0.05,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : (widget.suffixIcon != null
                ? SizedBox(
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: widget.suffixIcon,
              ),
            )
                : null),
          ),
        ),
      ],
    );
  }
}
// --- PlaceholderScreen for other routes, kept here for self-containment
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

  // FIX: Use routerDelegate.currentConfiguration.uri.toString() to get the current location
  // This method should ideally be in a utility or a top-level widget that manages navigation state
  int _getCurrentIndex(BuildContext context) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height; // Not directly used here, but good for context

    // Responsive font sizes
    final double headerNameFontSize = screenWidth * 0.055;
    final double headerSubtitleFontSize = screenWidth * 0.035;
    final double availabilityTextFontSize = screenWidth * 0.032;
    final double quickActionTitleFontSize = screenWidth * 0.045;
    final double sectionTitleFontSize = screenWidth * 0.04;
    final double childInfoAddChildFontSize = screenWidth * 0.03;
    final double childInfoChildNumFontSize = screenWidth * 0.035;
    final double groupSelectionHintFontSize = screenWidth * 0.025;
    final double groupNameFontSize = screenWidth * 0.038;
    final double calendarMonthFontSize = screenWidth * 0.05;
    final double weekdayFontSize = screenWidth * 0.038;
    final double calendarDateFontSize = screenWidth * 0.04;
    final double legendFontSize = screenWidth * 0.032;
    final double saveButtonFontSize = screenWidth * 0.04;


    // Responsive spacing
    final double largeSpacing = screenWidth * 0.05;
    final double mediumSpacing = screenWidth * 0.04;
    final double smallSpacing = screenWidth * 0.03;
    final double extraSmallSpacing = screenWidth * 0.02;

    // Watch the AvailabilityProvider for changes
    final availabilityProvider = Provider.of<AvailabilityProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Header Section
          Container(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.06, screenHeight * 0.05, screenWidth * 0.06, screenHeight * 0.03), // Responsive padding
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(screenWidth * 0.05)), // Responsive border radius
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to spaceBetween
                    children: [
                      // This inner Row groups the profile picture and text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Keep this inner row content aligned to start
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push('/profile'); // Replace with your actual profile route
                            },
                            child: Container(
                              width: screenWidth * 0.12, // Responsive profile picture size
                              height: screenWidth * 0.12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: screenWidth * 0.005), // Responsive border width
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  AppAssets.profilePicture,
                                  width: screenWidth * 0.12,
                                  height: screenWidth * 0.12,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: screenWidth * 0.09, // Responsive icon size
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: screenWidth * 0.03), // Responsive spacing
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, Peter!',
                                style: TextStyle(
                                  fontSize: headerNameFontSize, // Responsive font size
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                'Manage Ella’s activities',
                                style: TextStyle(
                                  fontSize: headerSubtitleFontSize, // Responsive font size
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xCCFFFFFF),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Notification Bell Icon (New addition)
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: screenWidth * 0.07, // Responsive icon size
                        ),
                        onPressed: () {
                          // Action when notification button is pressed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notification button pressed!')),
                          );
                          // You can add navigation here:
                          context.push('/notifications'); // Example navigation to a notifications page
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: largeSpacing), // Responsive spacing
                  Row(
                    children: [
                      Icon(Icons.circle, size: screenWidth * 0.03, color: Colors.green), // Responsive icon size
                      SizedBox(width: extraSmallSpacing), // Responsive spacing
                      Text(
                        'Available for playdates',
                        style: TextStyle(
                          fontSize: availabilityTextFontSize, // Responsive font size
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: mediumSpacing), // Responsive padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: quickActionTitleFontSize, // Responsive font size
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: smallSpacing), // Responsive spacing
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context, // Pass context
                          icon: Image.asset(AppAssets.plusIcon, width: screenWidth * 0.06, height: screenWidth * 0.06, errorBuilder: (context, error, stackTrace) => Icon(Icons.add_circle_outline, size: screenWidth * 0.06, color: AppColors.primaryBlue)), // Responsive icon size
                          title: 'Add Event',
                          onTap: () {
                            context.push('/create_event');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add Event Tapped')),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: smallSpacing), // Responsive spacing
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context, // Pass context
                          icon: Image.asset(AppAssets.eventCalendarIcon, width: screenWidth * 0.06, height: screenWidth * 0.06, errorBuilder: (context, error, stackTrace) => Icon(Icons.calendar_month, size: screenWidth * 0.06, color: AppColors.primaryBlue)), // Responsive icon size
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
                  SizedBox(height: mediumSpacing), // Responsive spacing

                  // Child Information Section
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryBlue),
                      borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
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
                            Text(
                              'Child Information *',
                              style: TextStyle(
                                fontSize: sectionTitleFontSize, // Responsive font size
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColorPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: _addChildField,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenWidth * 0.01), // Responsive padding
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.015), // Responsive border radius
                                  color: const Color(0xFFD8ECFF),
                                ),
                                child: Text(
                                  '+ Add Another Child',
                                  style: TextStyle(
                                    fontSize: childInfoAddChildFontSize, // Responsive font size
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryBlue,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: smallSpacing), // Responsive spacing
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _childNameControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: screenWidth * 0.04), // Responsive padding
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
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
                                        SizedBox(width: screenWidth * 0.03), // Responsive spacing
                                        Expanded(
                                          flex: 1,
                                          child: AuthInputField(
                                            controller: _childAgeControllers[index],
                                            labelText: 'Age',
                                            hintText: 'Age',
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -screenWidth * 0.025, // Responsive position
                                    left: screenWidth * 0.04, // Responsive position
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenWidth * 0.01), // Responsive padding
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue,
                                        borderRadius: BorderRadius.circular(screenWidth * 0.05), // Responsive border radius
                                      ),
                                      child: Text(
                                        'Child ${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: childInfoChildNumFontSize, // Responsive font size
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index > 0)
                                    Positioned(
                                      top: -screenWidth * 0.025, // Responsive position
                                      right: screenWidth * 0.005, // Responsive position
                                      child: Container(
                                        height: screenWidth * 0.05, // Responsive size
                                        width: screenWidth * 0.05,
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
                                          padding: EdgeInsets.all(screenWidth * 0.01), // Responsive padding
                                          icon: Icon(Icons.close_rounded, color: Colors.white, size: screenWidth * 0.03), // Responsive icon size
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
                              shadowColor: const Color(0x1A000000),
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)), // Responsive border radius
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025, horizontal: screenWidth * 0.1), // Responsive padding
                            ),
                            child:  Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontSize: saveButtonFontSize), // Responsive font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediumSpacing), // Responsive spacing

                  // Join Groups Section
                  Text(
                    'Join Groups *',
                    style: TextStyle(
                      fontSize: sectionTitleFontSize, // Responsive font size
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Select one or more groups you'd like to join",
                    style: TextStyle(
                      fontSize: groupSelectionHintFontSize, // Responsive font size
                      fontWeight: FontWeight.w400,
                      color: const Color(0x991B1D2A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: extraSmallSpacing), // Responsive spacing
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: screenWidth / (screenWidth * 0.3), // Responsive aspect ratio
                      crossAxisSpacing: screenWidth * 0.025, // Responsive spacing
                      mainAxisSpacing: screenWidth * 0.025, // Responsive spacing
                    ),
                    itemCount: _groupSelections.length,
                    itemBuilder: (context, index) {
                      String groupName = _groupSelections.keys.elementAt(index);
                      return _buildCheckboxTile(context, groupName); // Pass context
                    },
                  ),
                  SizedBox(height: mediumSpacing), // Responsive spacing

                  // Calendar Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'July 2025',
                        style: TextStyle(
                          fontSize: calendarMonthFontSize, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: screenWidth * 0.04), // Responsive icon size
                            onPressed: () {
                              // Handle previous month
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04), // Responsive icon size
                            onPressed: () {
                              // Handle next month
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: smallSpacing), // Responsive spacing
                  // Pass the calendarDateStates from the provider to the calendar grid
                  _buildCalendarGrid(context, availabilityProvider.calendarDateStates), // **FIXED LINE**
                  SizedBox(height: mediumSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: screenWidth * 0.03, color: AppColors.availableGreen), // Responsive icon size
                      SizedBox(width: extraSmallSpacing),
                      Text('Available', style: TextStyle(color: AppColors.textLight, fontSize: legendFontSize)), // Responsive font size
                      SizedBox(width: smallSpacing),
                      Icon(Icons.circle, size: screenWidth * 0.03, color: AppColors.unavailableRed), // Responsive icon size
                      SizedBox(width: extraSmallSpacing),
                      Text('Unavailable', style: TextStyle(color: AppColors.textColorSecondary, fontSize: legendFontSize)), // Responsive font size
                    ],
                  ),
                  SizedBox(height: largeSpacing), // Added spacing for bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQuickActionCard({
    required BuildContext context, // Added context
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardPadding = screenWidth * 0.05; // Responsive padding
    final double iconTextSpacing = screenWidth * 0.025; // Responsive spacing
    final double titleFontSize = screenWidth * 0.04; // Responsive font size

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding), // Responsive padding
        decoration: BoxDecoration(
          color: AppColors.quickActionCardBackground,
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsive border radius
          border: Border.all(color: AppColors.quickActionCardBorder, width: 1.0),
        ),
        child: Column(
          children: [
            icon,
            SizedBox(height: iconTextSpacing), // Responsive spacing
            Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize, // Responsive font size
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

  Widget _buildCheckboxTile(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth * 0.038; // Responsive font size

    return Container(
      decoration: BoxDecoration(
        color: _groupSelections[title]! ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.02), // Responsive border radius
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
            fontSize: titleFontSize, // Responsive font size
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
        contentPadding: EdgeInsets.zero, // Keep zero for tight fit inside the container
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, Map<int, int> calendarDateStates) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double weekdayFontSize = screenWidth * 0.035; // Responsive weekday font size
    final double dateNumberFontSize = screenWidth * 0.04; // Responsive date number font size
    final double cellSpacing = screenWidth * 0.01; // Responsive spacing between cells
    final double borderRadius = screenWidth * 0.02; // Responsive border radius for date cells

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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: cellSpacing, // Responsive spacing
            mainAxisSpacing: cellSpacing, // Responsive spacing
          ),
          itemCount: weekdays.length,
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                weekdays[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: weekdayFontSize, // Responsive font size
                  color: AppColors.textColorPrimary,
                ),
              ),
            );
          },
        ),
        SizedBox(height: screenWidth * 0.02), // Responsive spacing
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            crossAxisSpacing: cellSpacing, // Responsive spacing
            mainAxisSpacing: cellSpacing, // Responsive spacing
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
                  borderRadius: BorderRadius.circular(borderRadius), // Responsive border radius
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: dateNumberFontSize, // Responsive font size
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