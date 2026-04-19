import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:ebzim_app/screens/admin_cms_manage_screen.dart';
import 'package:ebzim_app/screens/news_screen.dart';
import 'package:ebzim_app/screens/membership_discover_screen.dart';
import 'package:ebzim_app/screens/help_support_screen.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/screens/heritage_projects_screen.dart';
import 'package:ebzim_app/screens/heritage_map_screen.dart';
import 'package:ebzim_app/screens/civic_report_screen.dart';
import 'package:ebzim_app/screens/statute_screen.dart';
import 'package:ebzim_app/screens/digital_library_screen.dart';
import 'package:ebzim_app/screens/contributions_screen.dart';
import 'package:ebzim_app/screens/news_detail_screen.dart';
import 'package:ebzim_app/screens/edit_profile_screen.dart';
import 'package:ebzim_app/screens/project_details_screen.dart';

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

final appRouterProvider = Provider((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthStateNotifier(ref),
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isInitializing = authState.isInitializing;
      
      final loc = state.matchedLocation;
      final isLoggingIn = loc == '/login';
      final isRegistering = loc == '/register';
      final isAuthFlow = loc.startsWith('/auth/');
      
      // Routes accessible without authentication
      final publicRoutes = [
        '/splash', '/language', '/onboarding', '/home', '/about', 
        '/activities', '/news', '/heritage', '/leadership', 
        '/statute', '/library', '/heritage-map'
      ];
      
      final isPublicBase = publicRoutes.contains(loc);
      final isPublicDetail = loc.startsWith('/news/') || loc.startsWith('/project/') || loc.startsWith('/event/');
      final isAllowedUnauthenticated = isLoggingIn || isRegistering || isAuthFlow || isPublicBase || isPublicDetail;

      if (isInitializing) return null;

      if (!isAuthenticated && !isAllowedUnauthenticated) {
        return '/login';
      }

      // If authenticated and trying to go to login/register, go to home/admin
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        final role = authState.user?.membershipLevel ?? 'USER';
        return (role == 'ADMIN' || role == 'SUPER_ADMIN') ? '/admin' : '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/splash',
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
        path: '/auth/verify-email/otp',
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';
          return _slideHoriz(state, OtpVerificationScreen(email: email, isRegistration: true));
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
      ShellRoute(
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => _fadePage(state, const HomeScreen()),
          ),
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
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) => _slidePage(state, const EditProfileScreen()),
              ),
            ],
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
          if (state.extra is NewsPost) {
            return _slidePage(state, AdminCreateNewsScreen(existingPost: state.extra as NewsPost));
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            return _slidePage(state, AdminCreateNewsScreen(
              existingPost: map['existingPost'] as NewsPost?,
              initialCategory: map['initialCategory'] as String?,
            ));
          }
          return _slidePage(state, const AdminCreateNewsScreen());
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
        path: '/admin/cms/:type',
        pageBuilder: (context, state) {
          final type = state.pathParameters['type'] ?? 'hero';
          return _slidePage(state, AdminCmsManageScreen(contentType: type));
        },
      ),
      GoRoute(
        path: '/heritage',
        pageBuilder: (context, state) => _slidePage(state, const HeritageProjectsScreen()),
      ),
      GoRoute(
        path: '/heritage-map',
        pageBuilder: (context, state) => _slidePage(state, const HeritageMapScreen()),
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
      GoRoute(
        path: '/project/:id',
        pageBuilder: (context, state) {
          final project = state.extra as NewsPost?;
          final id = state.pathParameters['id']!;
          
          if (project != null) {
            return _slidePage(state, ProjectDetailsScreen(project: project));
          }

          // Fallback for direct links / deep links
          return CustomTransitionPage(
            child: Consumer(
              builder: (context, ref, _) {
                final postAsync = ref.watch(postDetailsProvider(id));
                return postAsync.when(
                  data: (p) => p != null ? ProjectDetailsScreen(project: p) : const Scaffold(body: Center(child: Text('Project not found'))),
                  loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const Scaffold(body: Center(child: Text('Error loading project'))),
                );
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      GoRoute(
        path: '/news/:id',
        pageBuilder: (context, state) {
          final post = state.extra as NewsPost?;
          final id = state.pathParameters['id']!;
          return _slidePage(state, NewsDetailWrapper(initialPost: post, postId: id));
        },
      ),
    ],
  );
});

/// A notifier that forces GoRouter to refresh when auth state changes.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
