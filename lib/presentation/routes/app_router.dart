import 'package:circleslate/presentation/features/availability/view/availability_preview_page.dart';
import 'package:circleslate/presentation/features/availability/view/create_edit_availability_screen.dart';
import 'package:circleslate/presentation/features/chat/view/chat_list_screen.dart';
import 'package:circleslate/presentation/features/chat/view/chat_screen.dart';
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
import 'package:circleslate/presentation/features/settings/view/profile_page.dart'
    hide EditProfilePage;
import 'package:circleslate/presentation/features/settings/view/terms_and_conditions_page.dart';
import 'package:circleslate/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:circleslate/presentation/features/authentication/view/EmailVerificationPage.dart';
import 'package:circleslate/presentation/features/authentication/view/forgot_password_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/login_screen.dart';
import 'package:circleslate/presentation/features/authentication/view/otp_verification_page.dart';
import 'package:circleslate/presentation/features/authentication/view/pass_cng_success.dart';
import 'package:circleslate/presentation/features/authentication/view/reset_password_page.dart';
import 'package:circleslate/presentation/features/authentication/view/signup_screen.dart';
import 'package:circleslate/presentation/features/onboarding/view/splash_screen.dart';
import 'package:circleslate/presentation/features/onboarding/view/onboarding_screen.dart';
import '../../core/services/group/group_conversation_manager.dart';
import '../features/chat/group/view/create_group_page.dart';
import '../features/chat/group/view/group_conversation_page.dart';
import '../features/notification/notification_page.dart';
import 'package:circleslate/presentation/routes/route_observer.dart';

// --- RoutePaths Class ---
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
<<<<<<< HEAD
  static const String upcomingeventspage =
      '/up_coming_events'; // Your original name
  static const String createeventspage = '/create_event'; // Your original name
=======
  static const String upcomingeventspage = '/up_coming_events';
  static const String createeventspage = '/create_event';
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
  static const String eventDetails = '/event-details';
  static var ridesharingpage = '/ride_share';
  static const String onetooneconversationpage = '/one-to-one-conversation';
  static const String chatlistpage = '/chat';
<<<<<<< HEAD
  static const String creategrouppage = '/group_chat'; // Your original name
  static const String groupConversationPage =
      '/group_conversation'; // New route for Group Conversation
=======
  static const String creategrouppage = '/group_chat';
  static const String groupConversationPage = '/group_conversation';
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
  static const String groupManagement = '/group-management';
  static const String addmemberpage = '/add_member';
  static const String directInvite = '/direct-invite';
  static const String openInvite = '/open-invite';
  static const String availability = '/availability'; // keep only once
  static const String availabilitypreview = '/availability_preview';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
<<<<<<< HEAD
  static const String changePassword =
      '/change-password'; // New route for Change Password
  static const String privacyControls =
      '/privacy-controls'; // New route for Privacy Controls
  static const String privacyPolicy =
      '/privacy-policy'; // New route for Privacy Policy
  static const String termsAndConditions =
      '/terms-and-conditions'; // New route for Terms & Conditions
  static const String deleteAccount = '/delete-account';
  static const String notification =
      '/notifications'; // New route for Notifications
=======
  static const String changePassword = '/change-password';
  static const String privacyControls = '/privacy-controls';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String deleteAccount = '/delete-account';
  static const String notification = '/notifications';
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
}

// --- AppRoutes Class ---
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
<<<<<<< HEAD
  static const String upcomingeventspage =
      'upcomingeventspage'; // Your original name
  static const String createeventpage = 'createeventpage';
  static const String chatlistpage = 'chatlistpage'; // Your original names
  static const String eventdetailspage = 'eventdetailspage';
  static const String ridesharingpage = 'ridesharingpage';
  static const String onetooneconversationpage = 'onetooneconversationpage';
  static const String groupConversationPage =
      'groupConversationPage'; // New route for Group Conversation
  static const String creategrouppage = 'creategrouppage'; // Your original name
  static const String addmemberpage = 'addmemberpage'; // Your original name
=======
  static const String upcomingeventspage = 'upcomingeventspage';
  static const String createeventpage = 'createeventpage';
  static const String chatlistpage = 'chatlistpage';
  static const String eventdetailspage = 'eventdetailspage';
  static const String ridesharingpage = 'ridesharingpage';
  static const String onetooneconversationpage = 'onetooneconversationpage';
  static const String groupConversationPage = 'groupConversationPage';
  static const String creategrouppage = 'creategrouppage';
  static const String addmemberpage = 'addmemberpage';
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
  static const String directInvite = 'directInvite';
  static const String openInvite = 'openInvite';
  static const String availability = 'availability';
  static const String availabilitypreview = 'availabilitypreview';
  static const String settings = 'settings';
  static const String privacyPolicy = 'privacyPolicy';
  static const String privacyControls = 'privacyControls';
  static const String termsAndConditions = 'termsAndConditions';
  static const String deleteAccount = 'deleteAccount';
<<<<<<< HEAD
  static const String notification =
      'notification'; // New route for Notifications
=======
  static const String notification = 'notification';
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutePaths.splash,
    navigatorKey: _rootNavigatorKey,
<<<<<<< HEAD
    debugLogDiagnostics: true, // Enable for helpful debug logs
    // Redirection logic (can be expanded for authentication, etc.)
=======
    debugLogDiagnostics: true,
    observers: [routeObserver], // <-- Add routeObserver here

>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
    redirect: (BuildContext context, GoRouterState state) {
      // You can add auth redirects here if needed
      return null;
    },

    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
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
        builder: (context, state) => const ForgotPasswordPage(isLoggedIn: false),
      ),
      GoRoute(
        path: RoutePaths.emailVerification,
        builder: (context, state) {
          final String? userEmail = state.extra as String?;
          if (userEmail != null) {
            return EmailVerificationPage(userEmail: userEmail);
          }
          return const ForgotPasswordPage(isLoggedIn: false);
        },
      ),
      GoRoute(
        path: RoutePaths.OtpVerificationPage,
<<<<<<< HEAD
        builder: (BuildContext context, GoRouterState state) {
=======
        builder: (context, state) {
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
          final String? userEmail = state.extra as String?;
          if (userEmail != null) {
            return OtpVerificationPage(userEmail: userEmail);
          }
          return const ForgotPasswordPage(isLoggedIn: false);
        },
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
        path: RoutePaths.home,
        name: AppRoutes.home,
        builder: (context, state) =>
            const SmoothNavigationWrapper(initialIndex: 0),
      ),
      GoRoute(
        path: RoutePaths.upcomingeventspage,
        name: AppRoutes.upcomingeventspage,
        builder: (context, state) =>
            const SmoothNavigationWrapper(initialIndex: 1),
      ),
      GoRoute(
        path: RoutePaths.chatlistpage,
        name: AppRoutes.chatlistpage,
        builder: (context, state) =>
            const SmoothNavigationWrapper(initialIndex: 2),
      ),
      GoRoute(
        path: RoutePaths.availability,
        name: AppRoutes.availability,
        builder: (context, state) =>
            const SmoothNavigationWrapper(initialIndex: 3),
      ),
      GoRoute(
        path: RoutePaths.settings,
        name: AppRoutes.settings,
        builder: (context, state) =>
            const SmoothNavigationWrapper(initialIndex: 4),
      ),
      GoRoute(
        path: RoutePaths.createeventspage,
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: '${RoutePaths.eventDetails}/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id'] ?? '';
          return EventDetailsPage(eventId: eventId);
        },
      ),

      GoRoute(
        path: RoutePaths.ridesharingpage,
        builder: (context, state) => const RideSharingPage(),
      ),
      GoRoute(
        path: RoutePaths.onetooneconversationpage,
        builder: (context, state) {
<<<<<<< HEAD
          // Extract parameters from the extra Map
          final Map<String, dynamic>? extraData =
              state.extra as Map<String, dynamic>?;

          final String chatPartnerName =
              extraData?['chatPartnerName'] as String? ??
              'Unknown Chat Partner';
          final String currentUserId =
              extraData?['currentUserId'] as String? ?? '';
          final String chatPartnerId =
              extraData?['chatPartnerId'] as String? ?? '';
          final bool isGroupChat = extraData?['isGroupChat'] as bool? ?? false;
          final bool isCurrentUserAdminInGroup =
              extraData?['isCurrentUserAdminInGroup'] as bool? ?? false;
=======
          final Map<String, dynamic>? extraData = state.extra as Map<String, dynamic>?;

          final String chatPartnerName = extraData?['chatPartnerName'] ?? 'Unknown Chat Partner';
          final String currentUserId = extraData?['currentUserId'] ?? '';
          final String chatPartnerId = extraData?['chatPartnerId'] ?? '';
          final bool isGroupChat = extraData?['isGroupChat'] ?? false;
          final bool isCurrentUserAdminInGroup = extraData?['isCurrentUserAdminInGroup'] ?? false;
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f

          return OneToOneConversationPage(
            chatPartnerName: chatPartnerName,
            currentUserId: currentUserId,
            chatPartnerId: chatPartnerId,
            conversationId: '',
          );
        },
      ),
<<<<<<< HEAD

      // GoRoute(
      //   path: RoutePaths.onetooneconversationpage,
      //   builder: (context, state) {
      //     final chatPartnerName = state.extra as String?;
      //     return OneToOneConversationPage(
      //       chatPartnerName: chatPartnerName ?? 'Unknown',
      //     );
      //   },
      // ),
=======
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
      GoRoute(
        path: RoutePaths.groupManagement,
        builder: (context, state) => const GroupManagementPage(),
      ),
      GoRoute(
        path: '/group_chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final currentUserId = extra['currentUserId'] ?? '';
          return CreateGroupPage(currentUserId: currentUserId);
        },
      ),
      GoRoute(
        path: RoutePaths.groupConversationPage,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
<<<<<<< HEAD
          final currentUserId = extra['currentUserId'] as String? ?? '';
          final conversationId = extra['conversationId'] as String? ?? '';
          final isGroupChat = extra['isGroupChat'] as bool? ?? true;
          final isCurrentUserAdminInGroup =
              extra['isCurrentUserAdminInGroup'] as bool? ?? true;

          return GroupConversationPage(
            // <- use your group chat page here
=======
          final currentUserId = extra['currentUserId'] ?? '';
          final conversationId = extra['conversationId'] ?? '';
          final isGroupChat = extra['isGroupChat'] ?? true;
          final isCurrentUserAdminInGroup = extra['isCurrentUserAdminInGroup'] ?? true;

          return GroupConversationPage(
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
            groupId: conversationId,
            currentUserId: currentUserId,
            groupName: extra['groupName'] ?? '',
          );
        },
      ),
<<<<<<< HEAD

=======
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
      GoRoute(
        path: RoutePaths.addmemberpage,
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
        path: RoutePaths.availabilitypreview,
        builder: (context, state) => const AvailabilityPreviewPage(),
      ),
      GoRoute(
        path: RoutePaths.notification,
        builder: (context, state) => const NotificationPage(),
      ),
<<<<<<< HEAD

=======
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) {
          final Map<String, dynamic> extraData =
              state.extra as Map<String, dynamic>;
          return EditProfilePage(
<<<<<<< HEAD
            initialFullName: extraData['fullName'] as String,
            initialEmail: extraData['email'] as String,
            initialMobile: extraData['mobile'] as String,
            initialChildren: List<Map<String, String>>.from(
              extraData['children'],
            ),
            initialProfileImageUrl: extraData['profileImageUrl'] as String,
=======
            initialFullName: extraData['fullName'],
            initialEmail: extraData['email'],
            initialMobile: extraData['mobile'],
            initialChildren: List<Map<String, String>>.from(extraData['children']),
            initialProfileImageUrl: extraData['profileImageUrl'],
>>>>>>> eb0b0963131fea06fd0fcb1233936db3498e3a6f
          );
        },
      ),
    ],
  );
}
