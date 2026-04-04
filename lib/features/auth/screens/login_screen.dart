import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../../../main.dart'; 

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
        _emailController.text, 
        _passwordController.text,
      );
    }
  }

  void _showRecoveryDialog(BuildContext context, AppLocalizations loc) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        final isRtl = ref.read(localeProvider).languageCode == 'ar';
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: AppTheme.heritageGreenDeep.withValues(alpha: 0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: AppTheme.restrainedGold.withValues(alpha: 0.2)),
              ),
              title: Text(
                loc.authForgotPasswordTitle, 
                style: const TextStyle(color: AppTheme.premiumParchment, fontWeight: FontWeight.bold)
              ),
              content: Text(
                loc.authForgotPasswordDesc, 
                style: TextStyle(color: AppTheme.premiumParchment.withValues(alpha: 0.7), fontSize: 14, height: 1.6)
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    isRtl ? loc.memBack : loc.memBack.toUpperCase(), 
                    style: TextStyle(
                      color: AppTheme.restrainedGold, 
                      letterSpacing: isRtl ? 0 : 1.5, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';
    final theme = Theme.of(context);

    String getErrorMessage(String key) {
      switch (key) {
        case 'authErrorInvalid': return loc.authErrorInvalid;
        case 'authErrorNoConnection': return loc.authErrorNoConnection;
        case 'authErrorUnknown': return loc.authErrorUnknown;
        default: return key;
      }
    }

    // Auth state listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.heritageGreenDeep,
      body: Stack(
        children: [
          // Cinematic Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.6),
                radius: 1.5,
                colors: [
                  AppTheme.heritageGreenEmerald,
                  AppTheme.heritageGreenDeep,
                ],
              ),
            ),
          ),
          
          // 2. Simplified Performance Background
          Container(
            color: Colors.black.withValues(alpha: 0.1),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity
                    Column(
                      children: [
                        Image.asset('assets/images/logo.png', height: 100, color: AppTheme.premiumParchment),
                        const SizedBox(height: 16),
                        Text(
                          'SÉTIF • ALGERIA',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.restrainedGold.withValues(alpha: 0.5),
                            letterSpacing: 4.0,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 56),

                    // Simplified Login Card (No Blur)
                    Container(
                      padding: const EdgeInsets.all(36),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(44),
                        border: Border.all(
                          width: 0.6,
                          color: AppTheme.premiumParchment.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Page Heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    loc.authWelcome,
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      color: AppTheme.premiumParchment,
                                      fontSize: 32,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.security, color: AppTheme.restrainedGold, size: 16),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Staged Inputs
                            CustomTextField(
                              controller: _emailController,
                              label: loc.authIdentity,
                              hint: loc.authIdentityHint,
                              prefixIcon: Icons.account_circle_outlined,
                              isDarkBackground: true,
                              validator: (val) => val!.isEmpty ? loc.valRequired : null,
                            ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.05),
                            
                            const SizedBox(height: 24),

                            CustomTextField(
                              controller: _passwordController,
                              label: loc.authSecret,
                              hint: loc.authPasswordHint,
                              prefixIcon: Icons.lock_open_outlined,
                              isPassword: true,
                              isDarkBackground: true,
                              validator: (val) => val!.length < 8 ? loc.valPassword : null,
                            ).animate().fadeIn(delay: 750.ms, duration: 600.ms).slideY(begin: 0.05),
                            
                            const SizedBox(height: 12),

                            // Refined Helper Action
                            Align(
                              alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _showRecoveryDialog(context, loc),
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  isRtl ? loc.authLostCredentials : loc.authLostCredentials.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    letterSpacing: isRtl ? 0 : 1.5,
                                    color: AppTheme.restrainedGold.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),

                            // Integrated Error Message
                            if (authState.error != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.heritageRed.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.heritageRed.withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, color: AppTheme.heritageRed, size: 14),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          getErrorMessage(authState.error!),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: AppTheme.heritageRed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn().shake(hz: 8, curve: Curves.easeInOutCubic, duration: 400.ms),
                              ),

                            // Primary Elite CTA
                            Hero(
                              tag: 'auth_button',
                              child: ElevatedButton(
                                onPressed: authState.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.restrainedGold.withValues(alpha: 0.9),
                                  foregroundColor: AppTheme.heritageGreenDeep,
                                  padding: const EdgeInsets.symmetric(vertical: 22),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                                child: authState.isLoading 
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppTheme.heritageGreenDeep, strokeWidth: 2))
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isRtl ? loc.authAccessButton : loc.authAccessButton.toUpperCase(), 
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900, 
                                            letterSpacing: isRtl ? 0 : 2.5
                                          )
                                        ),
                                        const SizedBox(width: 16),
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(isRtl ? 3.14159 : 0),
                                          child: const Icon(Icons.arrow_forward_rounded, size: 20),
                                        ),
                                      ],
                                    ),
                              ),
                            ),
                            
                            const SizedBox(height: 48),
                            
                            // Elite Biometrics Section
                            Column(
                              children: [
                                Text(
                                  loc.authBiometric.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 8, 
                                    letterSpacing: 4, 
                                    color: AppTheme.premiumParchment.withValues(alpha: 0.3)
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.premiumParchment.withValues(alpha: 0.08)),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.fingerprint_rounded, color: AppTheme.premiumParchment, size: 40),
                                    style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      foregroundColor: AppTheme.premiumParchment.withValues(alpha: 0.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Premium Footer
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppTheme.premiumParchment.withValues(alpha: 0.08))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            isRtl ? loc.authNewHere : loc.authNewHere.toUpperCase(), 
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.premiumParchment.withValues(alpha: 0.4), 
                              fontSize: 9,
                              letterSpacing: isRtl ? 0 : 1.5
                            )
                          ),
                        ),
                        Expanded(child: Divider(color: AppTheme.premiumParchment.withValues(alpha: 0.08))),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    OutlinedButton(
                      onPressed: () => context.go('/register'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.restrainedGold.withValues(alpha: 0.2)),
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white.withValues(alpha: 0.02),
                      ),
                      child: Text(
                        isRtl ? loc.authCreateAccount : loc.authCreateAccount.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.restrainedGold, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: isRtl ? 0 : 2, 
                          fontSize: 10
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
