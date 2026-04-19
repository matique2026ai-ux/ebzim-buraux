import 'package:flutter/material.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class MembershipSuccessScreen extends StatelessWidget {
  const MembershipSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                ),
                child: const Icon(Icons.verified, size: 64, color: AppTheme.secondaryColor),
              ),
              const SizedBox(height: 32),
              Text(
                loc.memSuccessTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.memSuccessSub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
                child: Text(loc.memSuccessHome.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
