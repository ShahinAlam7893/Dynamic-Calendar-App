import 'package:circleslate/presentation/features/event_management/view/create_edit_event_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/event_details_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/ride_sharing_page.dart';
import 'package:circleslate/presentation/features/event_management/view/upcoming_events_page.dart';
import 'package:circleslate/presentation/routes/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your actual page files
import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:circleslate/presentation/features/authentication/view/forgot_password_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/login_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/otp_verification_page.dart';
import 'package:circleslate/presentation/features/authentication/view/pass_cng_success.dart';
import 'package:circleslate/presentation/features/authentication/view/reset_password_page.dart';
import 'package:circleslate/presentation/features/authentication/view/signup_screen.dart';
import 'package:circleslate/presentation/features/onboarding/view/onboarding_screen.dart';
import 'package:circleslate/presentation/features/home/view/home_screen.dart';


// Kept here for self-containment in Canvas. In your project, import this.
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
  // Added colors specific to the events page status tags
  static const Color openStatusColor = Color(0xFFE0F7FA); // Light cyan for 'Open' status
  static const Color openStatusText = Color(0xFF00BCD4); // Darker cyan for 'Open' text
  static const Color rideNeededStatusColor = Color(0xFFFFEBEE); // Light red for 'Ride Needed' status
  static const Color rideNeededStatusText = Color(0xFFF44336); // Darker red for 'Ride Needed' text
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

// --- AppAssets (Ideally from lib/core/constants/app_assets.dart) ---
// Defined here for self-containment in Canvas.
class AppAssets {
  static const String calendarIcon = 'assets/images/calendar_icon.png'; // Placeholder
  static const String profilePicture = 'assets/images/profile_picture.png'; // Placeholder for profile picture
  static const String emailIcon = 'assets/images/email_icon.png'; // Placeholder for email envelope icon
  static const String plusIcon = 'assets/images/plus.png'; // Assuming this asset exists
  static const String eventCalendarIcon = 'assets/images/event_calendar.png'; // Assuming this asset exists
  static const String sarahMartinez = 'assets/images/sarah_martinez.png'; // Placeholder for Sarah Martinez
  static const String peterJohnson = 'assets/images/peter_johnson.png'; // Placeholder for Peter Johnson
  static const String mikeWilson = 'assets/images/mike_wilson.png'; // Placeholder for Mike Wilson
  static const String jenniferDavis = 'assets/images/jennifer_davis.png'; // Placeholder for Jennifer Davis
}




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    initialLocation: RoutePaths.onboarding, // Start with onboarding
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(), // Login route
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const SignUpPage(), // Signup route
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(), // Your detailed Home page route
      ),
      GoRoute(
        path: RoutePaths.forgotpassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RoutePaths.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: RoutePaths.OtpVerificationPage,
        builder: (context, state) => const OtpVerificationPage(),
      ),
      GoRoute(
        path: RoutePaths.resetPasswordPage,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: RoutePaths.passwordResetSuccessPage,
        builder: (context, state) => const PasswordResetSuccessPage(),
      ),
      GoRoute(
        path: RoutePaths.upcomingeventspage, // Route for UpcomingEventsPage
        builder: (context, state) => const UpcomingEventsPage(),
      ),
      GoRoute(
        path: RoutePaths.createeventspage, // New route for CreateEventPage
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: RoutePaths.eventDetails, // New route for EventDetailsPage
        builder: (context, state) => const EventDetailsPage(),
      ),
      GoRoute(
        path: RoutePaths.ridesharingpage, // New route for EventDetailsPage
        builder: (context, state) => const RideSharingPage(),
      ),
      // GoRoute(
      //   path: RoutePaths.groups, // New route for GroupsPage
      //   builder: (context, state) => const GroupsPage(),
      // ),
      // GoRoute(
      //   path: RoutePaths.availability, // New route for AvailabilityPage
      //   builder: (context, state) => const AvailabilityPage(),
      // ),
      // GoRoute(
      //   path: RoutePaths.settings, // New route for SettingsPage
      //   builder: (context, state) => const SettingsPage(),
      // ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'CircleSlate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
