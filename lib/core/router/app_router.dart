import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/screens/splash_screen.dart';
import 'package:ebzim_app/screens/language_selection_screen.dart';
import 'package:ebzim_app/screens/onboarding_slider_screen.dart';
import 'package:ebzim_app/screens/login_screen.dart';
import 'package:ebzim_app/screens/register_screen.dart';
import 'package:ebzim_app/screens/home_screen.dart';
import 'package:ebzim_app/screens/event_details_screen.dart';
import 'package:ebzim_app/screens/about_screen.dart';
import 'package:ebzim_app/screens/activities_screen.dart';
import 'package:ebzim_app/screens/leadership_screen.dart';
import 'package:ebzim_app/screens/membership_flow_screen.dart';
import 'package:ebzim_app/screens/membership_success_screen.dart';
import 'package:ebzim_app/core/widgets/main_shell_screen.dart';
import 'package:ebzim_app/screens/dashboard_screen.dart';
import 'package:ebzim_app/screens/profile_screen.dart';
import 'package:ebzim_app/screens/notifications_screen.dart';
import 'package:ebzim_app/screens/settings_screen.dart';
import 'package:ebzim_app/screens/membership_review_screen.dart';
import 'package:ebzim_app/screens/legal_content_screen.dart';
import 'package:ebzim_app/screens/forgot_password_screen.dart';
import 'package:ebzim_app/screens/otp_verification_screen.dart';
import 'package:ebzim_app/screens/reset_password_screen.dart';
import 'package:ebzim_app/screens/admin_dashboard_screen.dart';
import 'package:ebzim_app/screens/admin_create_news_screen.dart';
import 'package:ebzim_app/screens/admin_create_event_screen.dart';
import 'package:ebzim_app/screens/news_screen.dart';
import 'package:ebzim_app/screens/membership_discover_screen.dart';
import 'package:ebzim_app/screens/help_support_screen.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/screens/heritage_projects_screen.dart';
import 'package:ebzim_app/screens/civic_report_screen.dart';
import 'package:ebzim_app/screens/statute_screen.dart';
import 'package:ebzim_app/screens/digital_library_screen.dart';
import 'package:ebzim_app/screens/contributions_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Premium Page Transition Builders
// ─────────────────────────────────────────────────────────────────────────────

/// Slide up + fade — for pushed detail screens
CustomTransitionPage<T> _slidePage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final reverseCurve = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(curve),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.85).animate(reverseCurve),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Horizontal slide — for lateral navigation (e.g., auth flows)
CustomTransitionPage<T> _slideHoriz<T>(GoRouterState state, Widget child, {bool rtl = false}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, widget) {
      final isAr = Directionality.of(context) == TextDirection.rtl;
      final dir = (isAr || rtl) ? -1.0 : 1.0;
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: Offset(0.06 * dir, 0), end: Offset.zero).animate(curve),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curve),
          child: widget,
        ),
      );
    },
  );
}

/// Pure fade — for tab switches and overlays
CustomTransitionPage<T> _fadePage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, widget) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: widget,
      );
    },
  );
}

/// Scale + fade — for modals / membership success
CustomTransitionPage<T> _scalePage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, widget) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(curve),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: widget,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, _) => '/splash',
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _slidePage(state, const LoginScreen()),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      pageBuilder: (context, state) => _slideHoriz(state, const ForgotPasswordScreen()),
    ),
    GoRoute(
      path: '/auth/forgot-password/otp',
      pageBuilder: (context, state) {
        final email = state.extra as String? ?? '';
        return _slideHoriz(state, OtpVerificationScreen(email: email));
      },
    ),
    GoRoute(
      path: '/auth/reset-password',
      pageBuilder: (context, state) {
        final token = state.extra as String? ?? '';
        return _slideHoriz(state, ResetPasswordScreen(token: token));
      },
    ),
    GoRoute(
      path: '/auth/privacy',
      pageBuilder: (context, state) => _slidePage(state, const LegalContentScreen(type: 'privacy')),
    ),
    GoRoute(
      path: '/auth/terms',
      pageBuilder: (context, state) => _slidePage(state, const LegalContentScreen(type: 'terms')),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _slideHoriz(state, const RegisterScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _fadePage(state, const HomeScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => _fadePage(state, const DashboardScreen()),
        ),
        GoRoute(
          path: '/leadership',
          pageBuilder: (context, state) => _fadePage(state, const LeadershipScreen()),
        ),
        GoRoute(
          path: '/activities',
          pageBuilder: (context, state) => _fadePage(state, const ActivitiesScreen()),
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => _fadePage(state, const AboutScreen()),
        ),
        GoRoute(
          path: '/news',
          pageBuilder: (context, state) => _fadePage(state, const NewsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _fadePage(state, const ProfileScreen()),
        ),
      ]
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => _slidePage(state, const SettingsScreen()),
    ),
    GoRoute(
      path: '/support',
      pageBuilder: (context, state) => _slidePage(state, const HelpSupportScreen()),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => _slidePage(state, const NotificationsScreen()),
    ),
    GoRoute(
      path: '/membership/discover',
      pageBuilder: (context, state) => _slidePage(state, const MembershipDiscoverScreen()),
    ),
    GoRoute(
      path: '/membership/apply',
      pageBuilder: (context, state) => _slidePage(state, const MembershipFlowScreen()),
    ),
    GoRoute(
      path: '/membership/success',
      pageBuilder: (context, state) => _scalePage(state, const MembershipSuccessScreen()),
    ),
    GoRoute(
      path: '/membership/review',
      pageBuilder: (context, state) => _slidePage(state, const MembershipReviewScreen()),
    ),
    GoRoute(
      path: '/event/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _slidePage(state, EventDetailsScreen(eventId: id));
      },
    ),
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) => _slidePage(state, const AdminDashboardScreen()),
    ),
    GoRoute(
      path: '/admin/news/create',
      pageBuilder: (context, state) {
        final existingPost = state.extra as NewsPost?;
        return _slidePage(state, AdminCreateNewsScreen(existingPost: existingPost));
      },
    ),
    GoRoute(
      path: '/admin/events/create',
      pageBuilder: (context, state) {
        final existingEvent = state.extra as ActivityEvent?;
        return _slidePage(state, AdminCreateEventScreen(existingEvent: existingEvent));
      },
    ),
    GoRoute(
      path: '/heritage',
      pageBuilder: (context, state) => _slidePage(state, const HeritageProjectsScreen()),
    ),
    GoRoute(
      path: '/report',
      pageBuilder: (context, state) => _slidePage(state, const CivicReportScreen()),
    ),
    GoRoute(
      path: '/statute',
      pageBuilder: (context, state) => _slidePage(state, const StatuteScreen()),
    ),
    GoRoute(
      path: '/library',
      pageBuilder: (context, state) => _fadePage(state, const DigitalLibraryScreen()),
    ),
    GoRoute(
      path: '/contributions',
      pageBuilder: (context, state) => _slidePage(state, const ContributionsScreen()),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) => _fadePage(state, const LanguageSelectionScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _fadePage(state, const OnboardingSliderScreen()),
    ),
  ],
);
