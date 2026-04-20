import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/services/storage_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedIdentity();
  }

  Future<void> _loadSavedIdentity() async {
    final storage = ref.read(storageServiceProvider);
    final lastIdentity = await storage.getLastIdentity();
    if (lastIdentity != null && mounted) {
      _emailController.text = lastIdentity;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Explicitly tell the browser to finish autofill and potentially save credentials
      TextInput.finishAutofillContext();
      
      ref.read(authProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final size = MediaQuery.of(context).size;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        final role = next.user?.membershipLevel ?? 'USER';
        if (role == 'ADMIN' || role == 'SUPER_ADMIN') {
          context.go('/admin');
        } else {
          context.go('/home');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: Stack(
          children: [
            // ── Ambient Floating Particles (Consistency with Splash) ──
            ...List.generate(4, (index) => Positioned(
              top: (index * 200.0) % size.height,
              right: (index * 150.0) % size.width,
              child: Icon(
                Icons.auto_awesome, 
                color: AppTheme.accentColor.withOpacity(0.05), 
                size: 15 + (index * 5.0)
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(duration: 3.seconds)
                .moveY(begin: 0, end: -20, duration: (4 + index).seconds),
            )),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    children: [
                      // ── Branding Section (The "Masterpiece" Logo) ──
                      _buildLogoHeader(loc, isAr),
                      
                      const SizedBox(height: 50),

                      // ── Crystalline Login Card ──
                      _buildLoginCard(loc, authState, theme, isAr),
                      
                      const SizedBox(height: 40),

                      // ── Footer Navigation ──
                      _buildFooterLinks(loc, theme),

                      const SizedBox(height: 20),
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

  Widget _buildLogoHeader(AppLocalizations loc, bool isAr) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Pulsing Glow
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.15),
                    blurRadius: 50,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2.seconds),

            // Logo Container
            Container(
              height: 110, width: 110,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0A140F).withOpacity(0.6),
                border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 1.5),
              ),
              child: Image.asset(
                'assets/images/logo.png', 
                fit: BoxFit.contain,
                color: AppTheme.accentColor.withOpacity(0.9),
              ),
            ),

            // Algerian Symbols (Star & Crescent)
            Positioned(
              top: 10,
              right: 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 18)
                    .animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: Icon(Icons.nightlight_round, color: AppTheme.accentColor.withOpacity(0.8), size: 14)
                      .animate(onPlay: (c) => c.repeat(reverse: true)).moveX(begin: -1, end: 1),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 1.seconds).scale(curve: Curves.easeOutBack),

        const SizedBox(height: 24),

        Text(
          loc.authAssocName,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.accentColor,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildLoginCard(AppLocalizations loc, AuthState authState, ThemeData theme, bool isAr) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20)),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.authWelcome,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),

                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputField(
                        controller: _emailController,
                        label: loc.authIdentity,
                        hint: loc.authIdentityHint,
                        icon: Icons.alternate_email_rounded,
                        autofocus: true,
                        autofillHints: const [AutofillHints.email, AutofillHints.username],
                        validator: (val) => val!.isEmpty ? loc.valRequired : null,
                      ),
                      
                      const SizedBox(height: 20),
                
                      _buildInputField(
                        controller: _passwordController,
                        label: loc.authSecret,
                        hint: '••••••••',
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        autofillHints: const [AutofillHints.password],
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        validator: (val) => val!.isEmpty ? loc.valRequired : null,
                      ),
                    ],
                  ),
                ),
                
                Align(
                  alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.push('/auth/forgot-password'),
                    child: Text(
                      loc.authLostCredentials,
                      style: TextStyle(color: AppTheme.accentColor.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                if (authState.error != null)
                  _buildErrorBanner(loc, authState.error!),

                const SizedBox(height: 12),
                
                _buildSubmitButton(loc, authState),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).moveY(begin: 30, end: 0, duration: 800.ms, curve: Curves.easeOut);
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    bool autofocus = false,
    Iterable<String>? autofillHints,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            autofocus: autofocus,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            validator: validator,
            autofillHints: autofillHints,
            keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 14),
              prefixIcon: Icon(icon, color: AppTheme.accentColor, size: 20),
              suffixIcon: isPassword ? IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white30, size: 18),
                onPressed: onTogglePassword,
              ) : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
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
          colors: [AppTheme.accentColor, AppTheme.accentColor.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(color: AppTheme.accentColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: authState.isLoading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(loc.authAccessButton, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildErrorBanner(AppLocalizations loc, String error) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error == 'authErrorInvalid' ? loc.authErrorInvalid : loc.authErrorUnknown,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(AppLocalizations loc, ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(loc.authNewHere, style: const TextStyle(color: Colors.white38, fontSize: 14)),
            TextButton(
              onPressed: () => context.go('/register'),
              child: Text(
                loc.authCreateAccount,
                style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ],
        ),
        
        TextButton(
          onPressed: () => context.go('/home'),
          child: Text(
            loc.authGuestBrowse,
            style: const TextStyle(color: Colors.white24, fontSize: 12, letterSpacing: 1),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegalLink(loc.authPrivacyTitle, () => context.push('/auth/privacy')),
            const Text('  •  ', style: TextStyle(color: Colors.white10)),
            _buildLegalLink(loc.authTermsTitle, () => context.push('/auth/terms')),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildLegalLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white24, fontSize: 11, decoration: TextDecoration.underline),
      ),
    );
  }
}
