import 'package:circleslate/presentation/features/event_management/view/create_edit_event_screen.dart';
import 'package:circleslate/presentation/routes/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router for navigation
import 'package:intl/intl.dart'; // For date formatting

// --- AppColors ---
// Defined here for self-containment. In a real project, this would be a shared file.
class AppColors {
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color inputBorderColor = Colors.grey;
  static const Color textColorSecondary = Color(0xFF333333);
  static const Color inputHintColor = Colors.grey;
  static const Color lightBlueBackground = Color(0x1AD8ECFF); // Used for the checkbox container background
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
  static const Color openStatusText = Color(0xA636D399); // This color looks more green/teal in the image
  static const Color rideNeededStatusColor = Color(0x1AF87171); // Light red background
  static const Color rideNeededStatusText = Color(0xFFF87171); // Darker red text
  static const Color toggleButtonActiveBg = Color(0xFF4285F4); // Primary blue for active button background
  static const Color toggleButtonActiveText = Colors.white; // White text for active button
  static const Color toggleButtonInactiveBg = Colors.white; // White background for inactive button
  static const Color toggleButtonInactiveText = Color(0xFF4285F4); // Primary blue text for inactive button
  static const Color toggleButtonBorder = Color(0xFFE0E0E0); // Light grey border for inactive button
}



// --- AuthInputField ---
// Modified to have a static label above the text field
class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText; // This will now be the static title above the field
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.labelText, // Used for the static title
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText, // Static title above the text field
          style: const TextStyle(
            color: AppColors.textColorSecondary,
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8.0), // Spacing between title and text field
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            // Removed labelText from InputDecoration
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
            hintStyle: const TextStyle(color: AppColors.inputHintColor, fontSize: 10.0, fontWeight: FontWeight.w400),
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
        ),
      ],
    );
  }
}

// --- CustomBottomNavigationBar ---
// Defined here for self-containment. In a real project, this would be a shared widget.
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

// --- CreateEventPage ---
class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isOpenInvite = true;
  bool _rideNeeded = false;

  int _selectedIndex = 0; // For the bottom navigation bar

  @override
  void dispose() {
    _eventTitleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.textDark, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.textDark, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Use GoRouter for navigation
      if (index == 0) {
        context.go(RoutePaths.home);
      } else if (index == 1) {
        context.go(RoutePaths.upcomingeventspage);
      } else if (index == 2) {
        // context.go(RoutePaths.groups);
      } else if (index == 3) {
        // context.go(RoutePaths.availability);
      } else if (index == 4) {
        // context.go(RoutePaths.settings);
      }
    });
  }


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
          'Create Event',
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
              // Handle chat button tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            AuthInputField(
              controller: _eventTitleController,
              labelText: 'Event Title *', // This is now the static title
              hintText: 'Enter event title..',
            ),
            const SizedBox(height: 20.0),

            // Date and Time
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer( // Prevents direct text input
                      child: AuthInputField(
                        controller: _dateController,
                        labelText: 'Date *', // Static title
                        hintText: '07/15/2025',
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer( // Prevents direct text input
                      child: AuthInputField(
                        controller: _timeController,
                        labelText: 'Time *', // Static title
                        hintText: '11:02 AM',
                        suffixIcon: const Icon(Icons.access_time, size: 18),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Location
            AuthInputField(
              controller: _locationController,
              labelText: 'Location *', // Static title
              hintText: 'Enter location..',
            ),
            const SizedBox(height: 20.0),

            // Description (Optional)
            AuthInputField(
              controller: _descriptionController,
              labelText: 'Description (Optional)', // Static title
              hintText: 'Add event description..',
              maxLines: 4, // For multiline input
            ),
            const SizedBox(height: 30.0),

            // Invite Type
            const Text(
              'Invite Type *',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    text: 'Open Invite',
                    isSelected: _isOpenInvite,
                    onTap: () {
                      setState(() {
                        _isOpenInvite = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildToggleButton(
                    text: 'Direct Invite',
                    isSelected: !_isOpenInvite,
                    onTap: () {
                      setState(() {
                        _isOpenInvite = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Ride Needed Checkbox
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppColors.lightBlueBackground, // Light blue background for the container
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                border: Border.all(color: AppColors.toggleButtonBorder, width: 1.0), // Light grey border
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.0, // Standard checkbox size
                    height: 24.0,
                    child: Checkbox(
                      value: _rideNeeded,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _rideNeeded = newValue!;
                        });
                      },
                      activeColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      side: BorderSide(
                        color: AppColors.inputOutline,
                        width: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Ride needed for this event',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Create Event Button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/up_coming_events');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create Event Tapped!')),
                  );
                  // You would typically send data to a backend here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Spacing for bottom nav bar
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.toggleButtonActiveBg : AppColors.toggleButtonInactiveBg,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? AppColors.toggleButtonActiveBg : AppColors.toggleButtonBorder,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.toggleButtonActiveText : AppColors.toggleButtonInactiveText,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
