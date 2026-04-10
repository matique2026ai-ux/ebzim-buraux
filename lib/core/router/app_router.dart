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
import 'package:ebzim_app/screens/news_screen.dart';
import 'package:ebzim_app/screens/membership_discover_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, _) => '/splash',
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: '/auth/forgot-password/otp',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return OtpVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) {
        final token = state.extra as String? ?? '';
        return ResetPasswordScreen(token: token);
      },
    ),
    GoRoute(
      path: '/auth/privacy',
      builder: (context, state) => const LegalContentScreen(type: 'privacy'),
    ),
    GoRoute(
      path: '/auth/terms',
      builder: (context, state) => const LegalContentScreen(type: 'terms'),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/leadership',
          builder: (context, state) => const LeadershipScreen(),
        ),
        GoRoute(
          path: '/activities',
          builder: (context, state) => const ActivitiesScreen(),
        ),
        GoRoute(
          path: '/news',
          builder: (context, state) => const NewsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ]
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/membership/discover',
      builder: (context, state) => const MembershipDiscoverScreen(),
    ),
    GoRoute(
      path: '/membership/apply',
      builder: (context, state) => const MembershipFlowScreen(),
    ),
    GoRoute(
      path: '/membership/success',
      builder: (context, state) => const MembershipSuccessScreen(),
    ),
    GoRoute(
      path: '/membership/review', 
      builder: (context, state) => const MembershipReviewScreen(),
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EventDetailsScreen(eventId: id);
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LanguageSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeInCirc)), 
            child: child
          );
        },
      ),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingSliderScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
