import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/services/auth_service.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isRegistration;

  const OtpVerificationScreen({super.key, required this.email, this.isRegistration = false});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFocused = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      if (widget.isRegistration) {
        ref.read(authProvider.notifier).verifyEmail(widget.email, _otpController.text);
      } else {
        // Password reset flow
        context.push('/auth/reset-password', extra: _otpController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    final isRtl = langCode == 'ar';
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (widget.isRegistration) {
        if (!next.isEmailVerificationRequired && next.error == null && previous?.isEmailVerificationRequired == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(langCode == 'ar' ? 'تم تأكيد الحساب بنجاح، يرجى تسجيل الدخول' : 'Account verified successfully, please log in'),
            backgroundColor: AppTheme.primaryColor,
          ));
          context.go('/login');
        } else if (next.error != null && previous?.error != next.error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.redAccent,
          ));
        }
      }
    });

    String getTitle() {
      if (langCode == 'ar') return 'تأكيد الرمز';
      if (langCode == 'fr') return 'Vérification du code';
      return 'Verify Code';
    }

    String getDesc() {
      if (langCode == 'ar') return 'الرجاء إدخال الرمز المكون من 6 أرقام المرسل إلى بريدك الإلكتروني لإكمال استعادة الحساب.';
      if (langCode == 'fr') return 'Veuillez entrer le code à 6 chiffres envoyé à votre adresse e-mail.';
      return 'Please enter the 6-digit code sent to your email to continue your account recovery.';
    }

    String getMaskedEmail() {
      // Create a masked email context based on backend behavior
      try {
        final parts = widget.email.split('@');
        if (parts.length == 2 && parts[0].length > 2) {
          final prefix = parts[0].substring(0, 2);
          return '$prefix***@${parts[1]}';
        }
      } catch (_) {}
      return 'your email';
    }

    String getConfirmBtnText() {
      if (langCode == 'ar') return 'التحقق والمتابعة';
      if (langCode == 'fr') return 'Vérifier et continuer';
      return 'Verify & Continue';
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
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined, 
                          color: Color(0xFFF0E0C8), 
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        getTitle(),
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
                      
                      Text(
                        getDesc(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Show masked email
                      Text(
                        getMaskedEmail(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: const Color(0xFFD3C5AD).withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 60),

                      // Code Input Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            langCode == 'ar' ? 'رمز التحقق' : 'VERIFICATION CODE',
                            style: TextStyle(
                              color: const Color(0xFFD3C5AD).withOpacity(0.6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Focus(
                            onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isFocused ? Colors.white.withOpacity(0.07) : Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isFocused ? const Color(0x4DD3C5AD) : Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: TextFormField(
                                controller: _otpController,
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 28, 
                                  letterSpacing: 24, // Wide spacing to simulate digits
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr, // Western numerals only
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return langCode == 'ar' ? 'الرمز غير مكتمل' : 'Code is incomplete';
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
                          onPressed: authState.isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0E0C8),
                            foregroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: authState.isLoading 
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor))
                            : Text(
                                getConfirmBtnText().toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
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
