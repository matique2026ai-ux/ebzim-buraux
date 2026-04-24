import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

# Admin Dashboard Modularization Checklist

- [ ] Extract `UsersTab`
    - [ ] Create `users_tab.dart`
    - [ ] Modernize UI with `AdminSharedComponents`
    - [ ] Integrate `AdminUserService`
- [ ] Extract `ProjectsTab`
    - [ ] Create `projects_tab.dart`
    - [ ] Integrate `EbzimImage` and `NewsService`
- [ ] Extract `NewsTab`
    - [ ] Create `news_tab.dart`
- [ ] Extract `FinancialsTab`
    - [ ] Create `financials_tab.dart`
    - [ ] Integrate `FinancialService`
- [ ] Extract `ReportsTab`
    - [ ] Create `reports_tab.dart`
    - [ ] Integrate `ReportService`
- [ ] Extract `CMSTab`
    - [ ] Create `cms_tab.dart`
    - [ ] Integrate `CMSContentService`
- [ ] Clean up `AdminDashboardScreen.dart`
    - [ ] Remove extracted classes
    - [ ] Remove redundant imports and utilities
- [ ] Final Verification
    - [ ] Flutter analyze
    - [ ] Hot restart and manual check

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF052011),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.tajawal(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

# Admin Dashboard Modularization Plan

Modularizing the `AdminDashboardScreen` monolith by extracting tabs into independent files.

## User Review Required

> [!IMPORTANT]
> The `AdminDashboardScreen` is currently ~4,353 lines. We will extract each tab iteratively. The user should verify navigation and data parity for each tab after extraction.

## Proposed Changes

### Admin Tabs (Modularization)

#### [NEW] [users_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/users_tab.dart)
Extracting user management logic, table, and dialogs.

#### [NEW] [projects_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/projects_tab.dart)
Extracting project management logic, using `EbzimImage`.

#### [NEW] [news_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/news_tab.dart)
Extracting news/announcements management.

#### [NEW] [financials_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/financials_tab.dart)
Extracting contribution and membership fee management.

#### [NEW] [reports_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/reports_tab.dart)
Extracting civic reports management.

#### [NEW] [cms_tab.dart](file:///c:/ebzim-buraux/lib/screens/admin/tabs/cms_tab.dart)
Extracting content management (Hero slides, Partners, Leadership).

#### [MODIFY] [admin_dashboard_screen.dart](file:///c:/ebzim-buraux/lib/screens/admin_dashboard_screen.dart)
Removing legacy code and importing modular tabs.

## Verification Plan

### Automated Tests
*   Run `flutter analyze` to ensure no broken references.

### Manual Verification
*   Verify each tab loads data correctly.
*   Verify action dialogs (edit, delete, status update) function as expected.
*   Verify Excel export parity.

class AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const AdminStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.tajawal(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminMiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const AdminMiniMetric({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 10,
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class AdminEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const AdminEmptyState({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class AdminLoadingShimmer extends StatelessWidget {
  const AdminLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminErrorState extends StatelessWidget {
  final String error;

  const AdminErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            Text(
              'حدث خطأ: $error',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminExportButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const AdminExportButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF052011),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(Icons.file_download_outlined, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'تصدير Excel',
              style: GoogleFonts.tajawal(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminStatusBadge extends StatelessWidget {
  final String status;

  const AdminStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status.toUpperCase()) {
      case 'APPROVED':
      case 'ACTIVE':
        color = const Color(0xFF15803D);
        text = status.toUpperCase() == 'APPROVED' ? 'مقبول' : 'نشط';
        break;
      case 'PENDING':
        color = const Color(0xFFB45309);
        text = 'قيد الانتظار';
        break;
      case 'REJECTED':
      case 'INACTIVE':
        color = const Color(0xFFB91C1C);
        text = status.toUpperCase() == 'REJECTED' ? 'مرفوض' : 'غير نشط';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.tajawal(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

SnackBar adminSuccessSnack(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentColor),
        const SizedBox(width: 12),
        Text(
          message,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    backgroundColor: const Color(0xFF052011),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

SnackBar adminErrorSnack(String message) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.red.shade900,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
