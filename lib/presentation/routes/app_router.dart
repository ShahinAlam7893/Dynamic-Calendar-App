import 'package:circleslate/presentation/features/availability/view/availability_preview_page.dart';
import 'package:circleslate/presentation/features/availability/view/create_edit_availability_screen.dart';
import 'package:circleslate/presentation/features/chat/view/chat_list_screen.dart';
import 'package:circleslate/presentation/features/chat/view/chat_screen.dart';
import 'package:circleslate/presentation/features/chat/view/create_group.dart';
import 'package:circleslate/presentation/features/event_management/view/create_edit_event_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/direct_invite_page.dart';
import 'package:circleslate/presentation/features/event_management/view/event_details_screen.dart';
import 'package:circleslate/presentation/features/event_management/view/open_invite_page.dart';
import 'package:circleslate/presentation/features/group_management/view/add_member_page.dart';
import 'package:circleslate/presentation/features/group_management/view/group_management_page.dart';
import 'package:circleslate/presentation/features/ride_request/view/ride_sharing_page.dart';
import 'package:circleslate/presentation/features/settings/view/delete_account_screen.dart';
import 'package:circleslate/presentation/features/settings/view/edit_profile_page.dart';
import 'package:circleslate/presentation/features/settings/view/privacy_controls_page.dart';
import 'package:circleslate/presentation/features/settings/view/privacy_policy_page.dart';
import 'package:circleslate/presentation/features/settings/view/profile_page.dart';
import 'package:circleslate/presentation/features/settings/view/terms_and_conditions_page.dart';
import 'package:circleslate/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart'; // For GlobalKey, NavigatorState, BuildContext
import 'package:go_router/go_router.dart'; // For GoRouter
import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:circleslate/presentation/features/authentication/view/forgot_password_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/login_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/otp_verification_page.dart';
import 'package:circleslate/presentation/features/authentication/view/pass_cng_success.dart';
import 'package:circleslate/presentation/features/authentication/view/reset_password_page.dart';
import 'package:circleslate/presentation/features/authentication/view/signup_screen.dart';
import 'package:circleslate/presentation/features/onboarding/view/splash_screen.dart';
import 'package:circleslate/presentation/features/onboarding/view/onboarding_screen.dart';


// --- RoutePaths Class (Restored to your original structure) ---
class RoutePaths {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String forgotpassword = '/forgot-password';
  static const String emailVerification = '/emailVerification';
  static const String OtpVerificationPage = '/otp_page';
  static const String resetPasswordPage = '/password_reset';
  static const String passwordResetSuccessPage = '/pass_cng_succussful';
  static const String upcomingeventspage = '/up_coming_events'; // Your original name
  static const String createeventspage = '/create_event'; // Your original name
  static const String eventDetails = '/event-details';
  static var ridesharingpage = '/ride_share';
  static const String onetooneconversationpage = '/one-to-one-conversation';
  static const String chatlistpage = '/chat';
  static const String creategrouppage = '/group_chat'; // Your original name
  static const String groupManagement = '/group-management';
  static const String addmemberpage = '/add_member'; // Your original name
  static const String directInvite = '/direct-invite';
  static const String openInvite = '/open-invite';
  // Added these as they are part of your navbar, assuming they are intended routes
  static const String availability = '/availability';
  static const String availabilitypreview = '/availability_preview';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password'; // New route for Change Password
  static const String privacyControls = '/privacy-controls'; // New route for Privacy Controls
  static const String privacyPolicy = '/privacy-policy'; // New route for Privacy Policy
  static const String termsAndConditions = '/terms-and-conditions'; // New route for Terms & Conditions
  static const String deleteAccount = '/delete-account';

}

// --- AppRoutes Class (Restored to your original structure) ---
class AppRoutes {
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String home = 'home';
  static const String forgotpassword = 'forgotpassword';
  static const String emailVerification = 'emailVerification';
  static const String resetPasswordPage = 'resetPasswordPage';
  static const String passwordResetSuccessPage = 'passwordResetSuccessPage';
  static const String upcomingeventspage = 'upcomingeventspage'; // Your original name
  static const String createeventpage = 'createeventpage'; // Your original name
  static const String eventdetailspage = 'eventdetailspage';
  static const String ridesharingpage = 'ridesharingpage';
  static const String onetooneconversationpage = 'onetooneconversationpage';
  static const String creategrouppage = 'creategrouppage'; // Your original name
  static const String addmemberpage = 'addmemberpage'; // Your original name
  static const String directInvite = 'directInvite';
  static const String openInvite = 'openInvite';
  static const String availability = 'availability';
  static const String availabilitypreview = 'availabilitypreview';
  static const String settings = 'settings';
  static const String privacyPolicy = 'privacyPolicy';
  static const String privacyControls = 'privacyControls';
  static const String termsAndConditions = 'termsAndConditions';
  static const String deleteAccount = 'deleteAccount';

}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// --- AppRouter Class ---
// This configures the GoRouter instance for your application.
class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutePaths.splash, // Starting point of your app
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true, // Enable for helpful debug logs

    // Redirection logic (can be expanded for authentication, etc.)
    redirect: (BuildContext context, GoRouterState state) {
      return null;
    },

    routes: [
      // Splash Screen
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const SignUpPage(),
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
        path: RoutePaths.OtpVerificationPage, // Your original route name
        builder: (context, state) => const OtpVerificationPage(),
      ),
      GoRoute(
        path: RoutePaths.resetPasswordPage, // Your original route name
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: RoutePaths.passwordResetSuccessPage, // Your original route name
        builder: (context, state) => const PasswordResetSuccessPage(),
      ),

      // Main Application Tabs (handled by SmoothNavigationWrapper)
      // Each of your main tab routes now points to the SmoothNavigationWrapper
      // with the corresponding initialIndex.
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const SmoothNavigationWrapper(initialIndex: 0),
      ),
      GoRoute(
        path: RoutePaths.upcomingeventspage, // Your original route name
        builder: (context, state) => const SmoothNavigationWrapper(initialIndex: 1),
      ),
      GoRoute(
        path: RoutePaths.chatlistpage, // Your original route name
        builder: (context, state) => const SmoothNavigationWrapper(initialIndex: 2),
      ),
      GoRoute(
        path: RoutePaths.availability, // Your original route name
        builder: (context, state) => const SmoothNavigationWrapper(initialIndex: 3),
      ),
      GoRoute(
        path: RoutePaths.settings, // Your original route name
        builder: (context, state) => const SmoothNavigationWrapper(initialIndex: 4),
      ),

      // Other Feature-specific Routes (not part of the main bottom navigation)
      GoRoute(
        path: RoutePaths.createeventspage, // Your original route name
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: RoutePaths.eventDetails,
        builder: (context, state) => const EventDetailsPage(),
      ),
      GoRoute(
        path: RoutePaths.ridesharingpage,
        builder: (context, state) => const RideSharingPage(),
      ),
      GoRoute(
        path: RoutePaths.onetooneconversationpage,
        builder: (context, state) {
          // Correctly extract the parameters from the 'extra' Map
          final Map<String, dynamic>? extraData = state.extra as Map<String, dynamic>?;

          final String chatPartnerName = extraData?['chatPartnerName'] as String? ?? 'Unknown Chat Partner';
          final bool isGroupChat = extraData?['isGroupChat'] as bool? ?? false;
          final bool isCurrentUserAdminInGroup = extraData?['isCurrentUserAdminInGroup'] as bool? ?? false;

          return OneToOneConversationPage(
            chatPartnerName: chatPartnerName,
            isGroupChat: isGroupChat,
            isCurrentUserAdminInGroup: isCurrentUserAdminInGroup,
          );
        },
      ),
      // GoRoute(
      //   path: RoutePaths.onetooneconversationpage,
      //   builder: (context, state) {
      //     final chatPartnerName = state.extra as String?;
      //     return OneToOneConversationPage(
      //       chatPartnerName: chatPartnerName ?? 'Unknown',
      //     );
      //   },
      // ),
      GoRoute(
        path: RoutePaths.groupManagement, // Your original route name
        builder: (context, state) => const GroupManagementPage(),
      ),
      GoRoute(
        path: RoutePaths.creategrouppage, // Your original route name
        builder: (context, state) => const CreateGroupPage(),
      ),
      GoRoute(
        path: RoutePaths.addmemberpage, // Your original route name
        builder: (context, state) => const AddMemberPage(),
      ),
      GoRoute(
        path: RoutePaths.directInvite,
        builder: (context, state) => const DirectInvitePage(),
      ),
      GoRoute(
        path: RoutePaths.openInvite,
        builder: (context, state) => const OpenInvitePage(),
      ),
      GoRoute(
        path: RoutePaths.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: RoutePaths.privacyControls,
        builder: (context, state) => const PrivacyControlsPage(),
      ),
      GoRoute(
        path: RoutePaths.termsAndConditions,
        builder: (context, state) => const TermsAndConditionsPage(),
      ),
      GoRoute(
        path: RoutePaths.deleteAccount,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RoutePaths.availability,
        builder: (context, state) => const AvailabilityPage(),
      ),
      GoRoute(
        path: RoutePaths.availabilitypreview,
        builder: (context, state) => const AvailabilityPreviewPage(),
      ),


      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) {
          final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
          return EditProfilePage(
            initialFullName: extraData['fullName'] as String,
            initialEmail: extraData['email'] as String,
            initialMobile: extraData['mobile'] as String,
            initialChildren: List<Map<String, String>>.from(extraData['children']),
            initialProfileImageUrl: extraData['profileImageUrl'] as String,
          );
        },
      ),
    ],
  );
}
