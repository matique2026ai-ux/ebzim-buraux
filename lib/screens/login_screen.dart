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
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        final role = next.user?.membershipLevel ?? 'USER';
        if (role == 'ADMIN') {
          context.go('/admin');
        } else {
          context.go('/dashboard');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
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
                  color: AppTheme.accentColor.withValues(alpha: 0.03),
                ),
              ),
            ),
            
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    children: [
                      // Branding Section
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          height: 120, width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 25, offset: const Offset(0, 10)),
                            ],
                          ),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Center(child: Image.asset('assets/images/logo.png', height: 70)),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                      
                      const SizedBox(height: 24),
                      Text(
                        loc.authAssocName,
                        style: TextStyle(
                          fontFamily: 'Aref Ruqaa',
                          color: AppTheme.accentColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: isRtl ? 0 : 2,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      
                      const SizedBox(height: 48),

                      // Glass Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 40, offset: const Offset(0, 15)),
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
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: isRtl ? 'Aref Ruqaa' : null,
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  // Identity Field
                                  _buildInputField(
                                    controller: _emailController,
                                    label: loc.authIdentity,
                                    hint: loc.authIdentityHint,
                                    icon: Icons.person_outline,
                                    validator: (val) => val!.isEmpty ? loc.valRequired : null,
                                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                                  
                                  const SizedBox(height: 24),

                                  // Secret Field
                                  _buildInputField(
                                    controller: _passwordController,
                                    label: loc.authSecret,
                                    hint: '••••••••',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    isPasswordVisible: _isPasswordVisible,
                                    onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                    validator: (val) => val!.isEmpty ? loc.valRequired : null,
                                  ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Forgot Password link
                                  Align(
                                    alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () => context.push('/auth/forgot-password'),
                                      child: Text(
                                        loc.authLostCredentials,
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 600.ms),

                                  // Error Callout
                                  if (authState.error != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppTheme.heritageRed.withValues(alpha: 0.06),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppTheme.heritageRed.withValues(alpha: 0.2)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline, color: AppTheme.heritageRed, size: 20),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              authState.error == 'authErrorInvalid' ? loc.authErrorInvalid : loc.authErrorUnknown,
                                              style: const TextStyle(color: AppTheme.heritageRed, fontSize: 13, height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).animate().fadeIn().shake(),

                                  Container(
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: AppTheme.accentColor,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: authState.isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: AppTheme.heritageGreenDeep,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      child: authState.isLoading 
                                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: AppTheme.heritageGreenDeep, strokeWidth: 2))
                                        : Text(
                                            loc.authAccessButton,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                                          ),
                                    ),
                                  ).animate().fadeIn(delay: 700.ms).scale(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      
                      const SizedBox(height: 48),

                      // Footer Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(loc.authNewHere, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: Text(
                              loc.authCreateAccount,
                              style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms),
                      
                      const SizedBox(height: 12),
                      
                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(
                          loc.authGuestBrowse,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
                        ),
                      ).animate().fadeIn(delay: 900.ms),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/auth/privacy'),
                            child: Text(
                              loc.authPrivacyTitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.25), 
                                fontSize: 11, 
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 11),
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
                      ).animate().fadeIn(delay: 1000.ms),
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.white38, size: 20),
              suffixIcon: isPassword ? IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white24, size: 18),
                onPressed: onTogglePassword,
              ) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.accentColor.withValues(alpha: 0.6), width: 1)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}
