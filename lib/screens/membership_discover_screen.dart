import 'package:flutter/material.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:go_router/go_router.dart';

class MembershipDiscoverScreen extends StatelessWidget {
  const MembershipDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: const EbzimAppBar(
        backgroundColor: Colors.transparent,
        color: AppTheme.accentColor,
      ),
      body: EbzimBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium_outlined, color: AppTheme.accentColor, size: 80),
              const SizedBox(height: 24),
              Text(
                loc.dashMembershipInvite,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Aref Ruqaa', fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  loc.dashMembershipLearnMore,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white60, fontSize: 16),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => context.push('/membership/apply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(loc.dashJoinAction, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
