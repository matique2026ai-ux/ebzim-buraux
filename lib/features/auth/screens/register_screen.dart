import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).register(
        _nameController.text, 
        _emailController.text,
        _passwordController.text,
        _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.authAccountCreated)));
        context.go('/dashboard');
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF002200), // Cinematic dark green
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(loc.appName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100, left: -50,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryColor.withValues(alpha: 0.3)),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                child: Column(
                  children: [
                    // Header
                    Text(
                      loc.regTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge?.copyWith(fontSize: 36, color: AppTheme.premiumParchment),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.regSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.premiumParchment.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Optimized Card (No Shadows/Blurs)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppTheme.premiumParchment.withValues(alpha: 0.1)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              label: loc.regFullName,
                              hint: loc.regFullNameHint,
                              prefixIcon: Icons.person_outline,
                              isDarkBackground: true,
                              validator: (val) => val!.isEmpty ? loc.valRequired : null,
                            ),
                            const SizedBox(height: 24),
                            
                            CustomTextField(
                              controller: _phoneController,
                              label: loc.regPhone,
                              hint: loc.regPhoneHint,
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              isDarkBackground: true,
                              validator: (val) => val!.isEmpty ? loc.valRequired : null,
                            ),
                            const SizedBox(height: 24),

                            CustomTextField(
                              controller: _emailController,
                              label: loc.regEmail,
                              hint: loc.regEmailHint,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              isDarkBackground: true,
                              validator: (val) {
                                if (val!.isEmpty) return loc.valRequired;
                                if (!val.contains('@')) return loc.valEmail;
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            CustomTextField(
                              controller: _passwordController,
                              label: loc.regPassword,
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              isDarkBackground: true,
                              validator: (val) => val!.length < 8 ? loc.valPassword : null,
                            ),
                            const SizedBox(height: 24),

                            CustomTextField(
                              controller: _confirmController,
                              label: loc.regConfirm,
                              hint: '••••••••',
                              prefixIcon: Icons.verified_user_outlined,
                              isPassword: true,
                              isDarkBackground: true,
                              validator: (val) {
                                if (val != _passwordController.text) return loc.valConfirm;
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 40),
                            
                            ElevatedButton(
                              onPressed: authState.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.restrainedGold,
                                foregroundColor: AppTheme.heritageGreenDeep,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                                child: authState.isLoading 
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppTheme.heritageGreenDeep, strokeWidth: 2))
                                  : Text(
                                      isRtl ? loc.regAction : loc.regAction.toUpperCase(), 
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppTheme.heritageGreenDeep, 
                                        letterSpacing: isRtl ? 0 : 2, 
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(loc.regAlreadyHaveAccount, style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.premiumParchment.withValues(alpha: 0.6))),
                                TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: Text(loc.regLogin, style: theme.textTheme.labelSmall?.copyWith(color: AppTheme.restrainedGold)),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Membership CTA with secondary appearance
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.workspace_premium, color: AppTheme.restrainedGold),
                      label: Text(
                        isRtl ? loc.regMembership : loc.regMembership.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.restrainedGold, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: isRtl ? 0 : 1
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        side: BorderSide(color: AppTheme.restrainedGold.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 48),
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
