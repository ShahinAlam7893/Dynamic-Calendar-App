import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:circleslate/presentation/features/authentication/view/forgot_password_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/login_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/otp_verification_page.dart';
import 'package:circleslate/presentation/features/authentication/view/pass_cng_success.dart';
import 'package:circleslate/presentation/features/authentication/view/reset_password_page.dart';
import 'package:circleslate/presentation/features/authentication/view/signup_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/create_edit_event_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/event_details_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/upcoming_events_page.dart';
import 'package:circleslate/presentation/features/home/view/home_screen.dart';
import 'package:circleslate/presentation/routes/app_routes_names.dart';
import 'package:flutter/material.dart'; // For GlobalKey, NavigatorState, BuildContext
import 'package:go_router/go_router.dart'; // For GoRouter

import '../features/onboarding/view/splash_screen.dart';
import '../features/onboarding/view/onboarding_screen.dart';

import 'app_routes_names.dart';
import 'route_paths.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutePaths.splash,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    // Minimal redirect for now:
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingToLoginOrSignup =
          state.uri.path == RoutePaths.login ||
          state.uri.path == RoutePaths.signup;
      final isOnSplashOrOnboarding =
          state.uri.path == RoutePaths.splash ||
          state.uri.path == RoutePaths.onboarding;

      return null;
    },

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
        builder: (context, state) => const HomePage(), // Home page route
      ),
      GoRoute(
        path: RoutePaths.forgotpassword,
        builder: (context, state) =>
            const ForgotPasswordPage(), // Home page route
      ),
      GoRoute(
        path: RoutePaths.emailVerification,
        builder: (context, state) =>
            const EmailVerificationPage(), // Home page route
      ),
      GoRoute(
        path: RoutePaths.resetPasswordPage,
        builder: (context, state) =>
        const ResetPasswordPage(), // Home page route
      ),
      GoRoute(path: RoutePaths.passwordResetSuccessPage,
      builder: (context, state)=>
      const PasswordResetSuccessPage(),
      ),

      GoRoute(path: RoutePaths.upcomingeventspage,
        builder: (context, state)=>
        const UpcomingEventsPage(),
      ),
      // GoRoute(path: RoutePaths.createeventspage,
      //   builder: (context, state)=>
      //   const CreateEventPage(),
      // ),
      //
      // GoRoute(path: RoutePaths.eventdetailspage,
      //   builder: (context, state)=>
      //   const EventDetailsPage(),
      // ),

    ],
  );
}
