import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
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
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

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
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: Stack(
          children: [
            // Ambient Lighting
            Positioned(
              top: -150, left: -50,
              child: Container(
                width: 400, height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor.withValues(alpha: isDark ? 0.03 : 0.05),
                ),
              ),
            ),
            
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                  child: Column(
                    children: [
                      // Branding Section
                      Hero(
                        tag: 'app_logo',
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Luminous Halo
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppTheme.accentColor.withValues(alpha: isDark ? 0.3 : 0.4),
                                    AppTheme.accentColor.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 140, width: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                                border: Border.all(
                                  color: AppTheme.accentColor.withValues(alpha: 0.6),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentColor.withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Image.asset(
                                        'assets/images/logo.png', 
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.business, color: AppTheme.accentColor, size: 60),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                      
                      const SizedBox(height: 32),
                      Text(
                        loc.authAssocName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.accentColor,
                          letterSpacing: isRtl ? 0 : 2,
                          shadows: [
                            Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 60),

                      // Luminous Glass Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  isDark ? const Color(0xFFE2E9E5).withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.98),
                                  isDark ? const Color(0xFFC5D4CD).withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.90),
                                ],
                                stops: const [0.0, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.4),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.1),
                                  blurRadius: 50,
                                  spreadRadius: -5,
                                  offset: const Offset(0, 30),
                                ),
                                BoxShadow(
                                  color: AppTheme.accentColor.withValues(alpha: isDark ? 0.03 : 0),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -50, right: -50,
                                  child: Container(
                                    width: 150, height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.03),
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        loc.authWelcome,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          color: isDark ? Colors.white : AppTheme.primaryColor,
                                          letterSpacing: 1,
                                          shadows: [
                                            Shadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 40),

                                      _buildInputField(
                                        controller: _emailController,
                                        label: loc.authIdentity,
                                        hint: loc.authIdentityHint,
                                        icon: Icons.person_outline,
                                        validator: (val) => val!.isEmpty ? loc.valRequired : null,
                                      ),
                                      
                                      const SizedBox(height: 24),

                                      _buildInputField(
                                        controller: _passwordController,
                                        label: loc.authSecret,
                                        hint: '••••••••',
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                        isPasswordVisible: _isPasswordVisible,
                                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                        validator: (val) => val!.isEmpty ? loc.valRequired : null,
                                      ),
                                      
                                      const SizedBox(height: 12),
                                      
                                      Align(
                                        alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: () => context.push('/auth/forgot-password'),
                                          child: Text(
                                            loc.authLostCredentials,
                                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),

                                      if (authState.error != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF8B2F2F).withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(color: const Color(0xFF8B2F2F).withValues(alpha: 0.4), width: 1.5),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.gpp_bad_rounded, color: Color(0xFFE89A9A), size: 24),
                                                    const SizedBox(width: 14),
                                                    Expanded(
                                                      child: Text(
                                                        authState.error == 'authErrorInvalid' 
                                                          ? loc.authErrorInvalid 
                                                          : '${loc.authErrorUnknown}\n(${authState.error})',
                                                        style: theme.textTheme.bodyMedium?.copyWith(
                                                          color: Colors.white, 
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      const SizedBox(height: 8),
                                      
                                      Container(
                                        height: 56,
                                        margin: const EdgeInsets.only(top: 24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: AppTheme.accentColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.accentColor.withValues(alpha: isDark ? 0.15 : 0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 6),
                                            ),
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
                                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                            : Text(
                                                loc.authAccessButton,
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 48),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc.authNewHere, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 14)),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: Text(
                              loc.authCreateAccount,
                              style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(
                          loc.authGuestBrowse,
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/auth/privacy'),
                            child: Text(
                              loc.authPrivacyTitle,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6), 
                                fontSize: 11, 
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () => context.push('/auth/terms'),
                            child: Text(
                              loc.authTermsTitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.25), 
                                fontSize: 11, 
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            label, 
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white.withValues(alpha: 0.8) 
                  : AppTheme.primaryColor.withValues(alpha: 0.8), 
              fontWeight: FontWeight.bold, 
              letterSpacing: 0.5
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withValues(alpha: 0.06) 
                : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white.withValues(alpha: 0.08) 
                  : AppTheme.primaryColor.withValues(alpha: 0.1)
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.primaryColor, 
              fontWeight: FontWeight.w500
            ),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.25) 
                    : Colors.black.withValues(alpha: 0.3), 
              ),
              prefixIcon: Icon(
                icon, 
                color: AppTheme.accentColor.withValues(alpha: 0.8), 
                size: 22
              ),
              suffixIcon: isPassword ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                  color: AppTheme.accentColor.withValues(alpha: 0.6), 
                  size: 20
                ),
                onPressed: onTogglePassword,
              ) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), 
                borderSide: BorderSide(color: AppTheme.accentColor, width: 2)
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}
