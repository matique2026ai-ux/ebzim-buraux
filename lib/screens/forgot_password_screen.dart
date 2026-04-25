import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .forgotPassword(_emailController.text);
      if (mounted) {
        setState(() => _isSubmitted = true);
        // We delay the navigation to OTP to show the success state briefly
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.push(
              '/auth/forgot-password/otp',
              extra: _emailController.text,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: Colors.white70,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: Stack(
          children: [
            // Ambient Floating Icons
            ...List.generate(
              3,
              (index) => Positioned(
                bottom: (index * 250.0) % size.height,
                left: (index * 100.0) % size.width,
                child:
                    Icon(
                          Icons.security_rounded,
                          color: AppTheme.accentColor.withValues(alpha: 0.04),
                          size: 40 + (index * 10.0),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 4.seconds)
                        .moveY(
                          begin: 0,
                          end: 30,
                          duration: (5 + index).seconds,
                        ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      // ── Header Icon ──
                      _buildHeaderIcon(),

                      const SizedBox(height: 40),

                      // ── Main Card ──
                      _buildRecoveryCard(loc, authState, isAr),

                      const SizedBox(height: 40),

                      // ── Footer ──
                      _buildFooter(loc),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
              duration: 3.seconds,
            ),

        Icon(
          _isSubmitted
              ? Icons.mark_email_read_rounded
              : Icons.lock_reset_rounded,
          color: AppTheme.accentColor,
          size: 44,
        ).animate(target: _isSubmitted ? 1 : 0).shimmer(duration: 2.seconds),
      ],
    ).animate().fadeIn(duration: 800.ms).scale();
  }

  Widget _buildRecoveryCard(
    AppLocalizations loc,
    AuthState authState,
    bool isAr,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
          ),
          child: _isSubmitted
              ? _buildSuccessState(loc)
              : _buildFormState(loc, authState, isAr),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildFormState(AppLocalizations loc, AuthState authState, bool isAr) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.authForgotPasswordTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            loc.authForgotPasswordDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // Email Input
          Text(
            loc.regEmail,
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              validator: (val) {
                if (val == null || val.isEmpty) return loc.valRequired;
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))
                  return loc.valEmail;
                return null;
              },
              decoration: InputDecoration(
                hintText: loc.regEmailHint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.2),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          if (authState.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                authState.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),

          _buildSubmitButton(loc, authState),
        ],
      ),
    );
  }

  Widget _buildSuccessState(AppLocalizations loc) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppTheme.accentColor,
          size: 60,
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        Text(
          loc.authEmailSent,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          loc.authEmailSentDesc,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(fontSize: 14, color: Colors.white60),
        ),
        const SizedBox(height: 32),
        const CircularProgressIndicator(
          color: AppTheme.accentColor,
          strokeWidth: 2,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations loc, AuthState authState) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor,
            AppTheme.accentColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                loc.langContinue.toUpperCase(),
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations loc) {
    return TextButton(
      onPressed: () => context.pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_back_rounded, size: 16, color: Colors.white38),
          const SizedBox(width: 8),
          Text(
            loc.regLogin,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}
