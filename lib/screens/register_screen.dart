import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/auth_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).register(
        _nameController.text.trim(), 
        _emailController.text.trim(),
        _passwordController.text,
        '', // Phone omitted as per specification for first-step registration
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String getErrorMessage(String key) {
      if (key.toLowerCase().contains('email already exists') || key.toLowerCase().contains('duplicate')) {
        return isRtl ? 'هذا البريد الإلكتروني مسجل مسبقاً.' : 'This email is already registered.';
      }
      switch (key) {
        case 'authErrorInvalid': return loc.authErrorInvalid;
        case 'authErrorNoConnection': return loc.authErrorNoConnection;
        case 'authErrorUnknown': return loc.authErrorUnknown;
        default: return key;
      }
    }

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && previous?.isAuthenticated != true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(loc.authAccountCreated),
          backgroundColor: AppTheme.primaryColor,
        ));
        context.go('/dashboard');
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.accentColor,
        leading: IconButton(
          icon: Icon(isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: Stack(
          children: [
            // Atmospheric Glows
            Positioned(
              top: -100, right: -50,
              child: Container(
                width: 400, height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor.withValues(alpha: 0.05),
                ),
              ),
            ),
            
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add_outlined, 
                          color: Color(0xFFF0E0C8), 
                          size: 32,
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 24),
                      
                      Text(
                        loc.regTitle, // "إنشاء حساب جديد"
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 32,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                      const SizedBox(height: 12),
                      
                      Text(
                        loc.regSubtitle, // "أنشئ حسابك للوصول إلى خدمات المنصة ومتابعة أنشطتك بكل سهولة."
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 16),

                      // Legal/Product Note
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.1)),
                        ),
                        child: Text(
                          loc.regMembershipNote, // "إنشاء حساب في المنصة لا يعني اكتساب العضوية الرسمية في الجمعية."
                          style: TextStyle(
                            color: AppTheme.accentColor.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fadeIn(delay: 500.ms),
                      const SizedBox(height: 40),

                      // Glassmorphism Form Container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // 1. Full Name
                                  _buildCustomField(
                                    controller: _nameController,
                                    label: loc.regFullName.toUpperCase(),
                                    hint: loc.regFullNameHint, // "عكرور توفيق"
                                    icon: Icons.person_outline,
                                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                                    validator: (val) => val!.trim().isEmpty ? loc.valRequired : null,
                                  ).animate().fadeIn(delay: 600.ms).slideX(begin: isRtl ? 0.1 : -0.1),
                                  const SizedBox(height: 24),
                                  
                                  // 2. Email Address
                                  _buildCustomField(
                                    controller: _emailController,
                                    label: loc.regEmail.toUpperCase(),
                                    hint: 'name@example.com',
                                    icon: Icons.alternate_email,
                                    keyboardType: TextInputType.emailAddress,
                                    textDirection: TextDirection.ltr,
                                    validator: (val) {
                                      if (val!.trim().isEmpty) return loc.valRequired;
                                      if (!val.contains('@')) return loc.valEmail;
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 700.ms).slideX(begin: isRtl ? 0.1 : -0.1),
                                  const SizedBox(height: 24),

                                  // 3. Password
                                  _buildCustomField(
                                    controller: _passwordController,
                                    label: loc.regPassword.toUpperCase(),
                                    hint: '••••••••',
                                    icon: Icons.lock_outline,
                                    obscureText: _isPasswordObscured,
                                    textDirection: TextDirection.ltr,
                                    onToggleObscure: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                                    validator: (val) {
                                      if (val == null || val.length < 8) return loc.valPassword;
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 800.ms).slideX(begin: isRtl ? 0.1 : -0.1),
                                  const SizedBox(height: 24),

                                  // 4. Confirm Password
                                  _buildCustomField(
                                    controller: _confirmController,
                                    label: loc.regConfirm.toUpperCase(),
                                    hint: '••••••••',
                                    icon: Icons.verified_user_outlined,
                                    obscureText: _isConfirmObscured,
                                    textDirection: TextDirection.ltr,
                                    onToggleObscure: () => setState(() => _isConfirmObscured = !_isConfirmObscured),
                                    validator: (val) {
                                      if (val != _passwordController.text) return loc.valConfirm;
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 900.ms).slideX(begin: isRtl ? 0.1 : -0.1),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Validation Error Displayer
                                  if (authState.error != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                getErrorMessage(authState.error!),
                                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).animate().shake(),
                                  
                                  // Create Account Primary Action Button
                                  Container(
                                    height: 64,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: authState.isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.accentColor, // Premium Unified Gold
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: authState.isLoading 
                                        ? const SizedBox(
                                            height: 24, 
                                            width: 24, 
                                            child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                          )
                                        : Text(
                                            loc.regAction.toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                                          ),
                                    ),
                                  ).animate().fadeIn(delay: 1000.ms).scale(),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Return to Login Line
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${loc.regAlreadyHaveAccount} ',
                                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.go('/login'),
                                        child: Text(
                                          loc.regLogin,
                                          style: const TextStyle(
                                            color: AppTheme.accentColor, 
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
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
                      ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                      const SizedBox(height: 48),
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

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextDirection? textDirection,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFD3C5AD).withValues(alpha: 0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textDirection: textDirection,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2), fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.white38, size: 20),
              suffixIcon: onToggleObscure != null
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white38,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}
