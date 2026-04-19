import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmailFocused = false;
  bool _isSubmitted = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).forgotPassword(_emailController.text);
      if (mounted) {
         context.push('/auth/forgot-password/otp', extra: _emailController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';
    final langCode = ref.watch(localeProvider).languageCode;

    String getConfirmationMessage() {
      if (langCode == 'ar') {
        return 'إذا كان هناك حساب مسجل بهذا البريد الإلكتروني، فقد تم إرسال تعليمات إعادة تعيين كلمة المرور.';
      } else if (langCode == 'fr') {
        return 'Si un compte existe pour cet e-mail, les instructions de réinitialisation du mot de passe ont été envoyées.';
      } else {
        return 'If an account exists for this email, password reset instructions have been sent.';
      }
    }

    String getExplanatoryText() {
      if (langCode == 'ar') {
        return 'أدخل البريد الإلكتروني المرتبط بحسابك لتلقي رابط آمن لإعادة تعيين كلمة المرور الخاصة بك عبر بريدك الوارد.';
      } else if (langCode == 'fr') {
        return 'Veuillez saisir l\'adresse e-mail associée à votre compte pour recevoir un lien de réinitialisation sécurisé.';
      } else {
        return 'Enter the email address associated with your account to receive a secure password reset link.';
      }
    }

    String getBackToLoginText() {
      if (langCode == 'ar') {
        return 'العودة إلى تسجيل الدخول';
      } else if (langCode == 'fr') {
        return 'Retour à la connexion';
      } else {
        return 'Back to Login';
      }
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text(
                      'EBZIM | إبزيم',
                      style: TextStyle(
                        fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                        color: Colors.white24,
                        fontSize: 12,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Editorial Icon/Graphic Placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isSubmitted ? Icons.mark_email_read_outlined : Icons.shield_outlined, 
                          color: const Color(0xFFF0E0C8), 
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        loc.authForgotPasswordTitle,
                        style: TextStyle(
                          fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily,
                          fontSize: 42,
                          height: 1.1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: isRtl ? FontStyle.normal : FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      if (!_isSubmitted) ...[
                        Text(
                          getExplanatoryText(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Email Input Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRtl ? loc.authIdentity : loc.authIdentity.toUpperCase(),
                              style: TextStyle(
                                color: const Color(0xFFD3C5AD).withOpacity(0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Focus(
                              onFocusChange: (hasFocus) => setState(() => _isEmailFocused = hasFocus),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isEmailFocused ? Colors.white.withOpacity(0.07) : Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isEmailFocused ? const Color(0x4DD3C5AD) : Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: loc.authIdentityHint,
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return loc.valRequired;
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return loc.valEmail; // Ensures actual email format validation
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
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF0E0C8),
                              foregroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Text(
                              loc.langContinue.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          getConfirmationMessage(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 60),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () => context.pop(), // Pop goes back to Login
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFFF0E0C8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: Color(0xFFF0E0C8), width: 1.5)
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              getBackToLoginText().toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ],

                      // Secondary Navigation Action
                      if (!_isSubmitted)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                getBackToLoginText(),
                                style: const TextStyle(color: Colors.white60, fontSize: 13),
                              ),
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
      ),
    );
  }
}
