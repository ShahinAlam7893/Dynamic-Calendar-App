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
      GoRoute(
        path: RoutePaths.onetooneconversationpage, // New route for EventDetailsPage
        builder: (context, state) => const OneToOneConversationPage(),
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
