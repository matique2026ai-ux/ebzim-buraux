import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/auth_service.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordFocused = false;
  bool _isConfirmFocused = false;
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;
  bool _isSubmittedSuccess = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitReset() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .resetPassword(widget.token, _passwordController.text);

      final authState = ref.read(authProvider);

      if (mounted) {
        if (authState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                authState.error!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          setState(() {
            _isSubmittedSuccess = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    final isRtl = langCode == 'ar';
    final isLoading = ref.watch(authProvider).isLoading;

    String getTitle() {
      if (langCode == 'ar')
        return _isSubmittedSuccess ? 'تمت بنجاح' : 'تعيين كلمة المرور';
      if (langCode == 'fr')
        return _isSubmittedSuccess ? 'Succès' : 'Nouveau Mot de Passe';
      return _isSubmittedSuccess ? 'Success' : 'Reset Password';
    }

    String getDesc() {
      if (langCode == 'ar')
        return _isSubmittedSuccess
            ? 'تم تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول بحسابك.'
            : 'أنشئ كلمة مرور جديدة وقوية لحسابك.';
      if (langCode == 'fr')
        return _isSubmittedSuccess
            ? 'Votre mot de passe a été réinitialisé. Vous pouvez maintenant vous connecter.'
            : 'Créez un nouveau mot de passe fort pour votre compte.';
      return _isSubmittedSuccess
          ? 'Your password has been successfully reset. You may now login.'
          : 'Create a new, strong password for your account.';
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: EbzimBackground(
        child: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    if (!_isSubmittedSuccess)
                      IconButton(
                        icon: Icon(
                          isRtl
                              ? Icons.arrow_forward_ios
                              : Icons.arrow_back_ios,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => context.pop(),
                      )
                    else
                      const SizedBox(width: 48), // Spacer to match flex
                    const Spacer(),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 40.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isSubmittedSuccess
                              ? Icons.check_circle_outline
                              : Icons.lock_reset,
                          color: const Color(0xFFF0E0C8),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        getTitle(),
                        style: TextStyle(
                          fontFamily: Theme.of(
                            context,
                          ).textTheme.displayLarge?.fontFamily,
                          fontSize: 42,
                          height: 1.1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: isRtl
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        getDesc(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      if (!_isSubmittedSuccess) ...[
                        // New Password Input Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langCode == 'ar'
                                  ? 'كلمة المرور الجديدة'
                                  : 'NEW PASSWORD',
                              style: TextStyle(
                                color: const Color(
                                  0xFFD3C5AD,
                                ).withValues(alpha: 0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Focus(
                              onFocusChange: (hasFocus) =>
                                  setState(() => _isPasswordFocused = hasFocus),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isPasswordFocused
                                      ? Colors.white.withValues(alpha: 0.07)
                                      : Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isPasswordFocused
                                        ? const Color(0x4DD3C5AD)
                                        : Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isPasswordObscured,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white30,
                                      ),
                                      onPressed: () => setState(
                                        () => _isPasswordObscured =
                                            !_isPasswordObscured,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length < 8) {
                                      return langCode == 'ar'
                                          ? 'كلمة المرور قصيرة (8 رموز على الأقل)'
                                          : 'Password must be at least 8 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Confirm Password Input Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langCode == 'ar'
                                  ? 'تأكيد كلمة المرور'
                                  : 'CONFIRM PASSWORD',
                              style: TextStyle(
                                color: const Color(
                                  0xFFD3C5AD,
                                ).withValues(alpha: 0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Focus(
                              onFocusChange: (hasFocus) =>
                                  setState(() => _isConfirmFocused = hasFocus),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isConfirmFocused
                                      ? Colors.white.withValues(alpha: 0.07)
                                      : Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isConfirmFocused
                                        ? const Color(0x4DD3C5AD)
                                        : Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _isConfirmObscured,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white30,
                                      ),
                                      onPressed: () => setState(
                                        () => _isConfirmObscured =
                                            !_isConfirmObscured,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return langCode == 'ar'
                                          ? 'كلمة المرور غير متطابقة'
                                          : 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submitReset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0E0C8),
                              foregroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryColor,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    langCode == 'ar'
                                        ? 'تأكيد الحفظ'
                                        : (langCode == 'fr'
                                              ? 'SAUVEGARDER'
                                              : 'SAVE PASSWORD'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0E0C8),
                              foregroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              langCode == 'ar'
                                  ? 'تسجيل الدخول'
                                  : (langCode == 'fr'
                                        ? 'SE CONNECTER'
                                        : 'LOGIN'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
