import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/membership_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/services/media_service.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class MembershipFlowScreen extends ConsumerStatefulWidget {
  const MembershipFlowScreen({super.key});

  @override
  ConsumerState<MembershipFlowScreen> createState() => _MembershipFlowScreenState();
}

class _MembershipFlowScreenState extends ConsumerState<MembershipFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 6;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitForm() async {
    // Show loading
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    await ref.read(membershipProvider.notifier).submitApplication();
    if (!mounted) return;
    context.pop(); // dismiss loading
    context.go('/membership/success');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final stepLabels = [
      isAr ? 'الشروط' : 'Éligibilité',
      isAr ? 'الهوية' : 'Identité',
      isAr ? 'الاتصال' : 'Contact',
      isAr ? 'الوثائق' : 'Documents',
      isAr ? 'الدوافع' : 'Motivation',
      isAr ? 'التأكيد' : 'Confirm',
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
                ),
                child: IconButton(
                  icon: Icon(
                    _currentStep == 0
                        ? Icons.close_rounded
                        : (isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded),
                    color: AppTheme.accentColor,
                    size: 18,
                  ),
                  onPressed: _currentStep == 0 ? () => context.pop() : _prevStep,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Ebzim • إبزيم',
          style: GoogleFonts.tajawal(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: EbzimBackground(
        child: Column(
          children: [
            // ── Stepper ──────────────────────────────────────
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 72),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: List.generate(_totalSteps * 2 - 1, (i) {
                  if (i.isOdd) {
                    // Connector
                    final stepIdx = i ~/ 2;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: stepIdx < _currentStep
                              ? AppTheme.accentColor
                              : isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
                        ),
                      ),
                    );
                  }
                  // Step dot
                  final stepIdx = i ~/ 2;
                  final isActive = stepIdx == _currentStep;
                  final isDone = stepIdx < _currentStep;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 36 : 28,
                    height: isActive ? 36 : 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? AppTheme.accentColor
                          : isActive
                              ? AppTheme.accentColor.withOpacity(0.15)
                              : isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      border: Border.all(
                        color: (isDone || isActive)
                            ? AppTheme.accentColor
                            : isDark ? Colors.white12 : Colors.black.withOpacity(0.1),
                        width: isActive ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                          : Text(
                              '${stepIdx + 1}',
                              style: TextStyle(
                                color: isActive ? AppTheme.accentColor : (isDark ? Colors.white30 : Colors.black38),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ),

            // Step label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  stepLabels[_currentStep],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Page view ─────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _Step0Conditions(),
                  _Step1IdentityForm(),
                  _Step2ContactForm(),
                  _Step3AttachmentsForm(),
                  _Step4MotivationForm(),
                  _Step5ReviewForm(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.85),
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06))),
            ),
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [AppTheme.accentColor, const Color(0xFFB8941E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _nextStep();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      (_currentStep == _totalSteps - 1 ? loc.memSubmit : loc.memNext).toUpperCase(),
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// (Old _buildStep and _buildDivider removed — replaced by inline stepper)
}

// --------------------------------------------------------------------------
// STEP 1: IDENTITY
// --------------------------------------------------------------------------
class _Step1IdentityForm extends ConsumerWidget {
  const _Step1IdentityForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(membershipProvider);
    final notifier = ref.read(membershipProvider.notifier);
    final userAsync = ref.watch(currentUserProvider);

    // Auto-fill from profile on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.fullName.isEmpty) {
        userAsync.whenData((user) {
          if (user != null) {
            notifier.updateField('fullName', user.name);
            notifier.updateField('email', user.email);
            notifier.updateField('phone', user.phone);
          }
        });
      }
    });

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.memStepper1, style: TextStyle(fontFamily: theme.textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          _buildInput(context, loc.memFullName, state.fullName, (v) => notifier.updateField('fullName', v)),
          const SizedBox(height: 24),
          _buildDatePicker(context, loc.memDOB, state.dob, (v) => notifier.updateField('dob', v)),
          const SizedBox(height: 24),
          Text(loc.memGender.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildRadio(loc.memMale, 'male', state.gender, (v) => notifier.updateField('gender', v))),
              const SizedBox(width: 16),
              Expanded(child: _buildRadio(loc.memFemale, 'female', state.gender, (v) => notifier.updateField('gender', v))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime? value, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: value ?? DateTime(2000), firstDate: DateTime(1920), lastDate: DateTime.now());
            if (picked != null) onChanged(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Text(
              value == null ? '' : DateFormat.yMd().format(value),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String) onChanged) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? AppTheme.secondaryColor : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(label.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: isSelected ? AppTheme.secondaryColor : Colors.grey)),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// STEP 2: CONTACT
// --------------------------------------------------------------------------
class _Step2ContactForm extends ConsumerWidget {
  const _Step2ContactForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(membershipProvider);
    final notifier = ref.read(membershipProvider.notifier);
    final wilayas = ref.read(wilayaServiceProvider).getWilayas();
    final communes = ref.read(wilayaServiceProvider).getCommunes(state.wilayaId);

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.memStepper2, style: TextStyle(fontFamily: theme.textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          _buildDropdown(context, loc.memWilaya, state.wilayaId, wilayas.map((w) => DropdownMenuItem(value: w.id, child: Text(w.nameEn))).toList(), (v) => notifier.updateField('wilayaId', v)),
          const SizedBox(height: 24),
          _buildDropdown(context, loc.memCommune, state.communeId, communes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nameEn))).toList(), (v) => notifier.updateField('communeId', v)),
          const SizedBox(height: 24),
          _buildInput(context, loc.memPhone, state.phone, (v) => notifier.updateField('phone', v), hint: loc.memPhoneHint),
          const SizedBox(height: 24),
          _buildInput(context, 'Email', state.email, (v) => notifier.updateField('email', v)),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String label, String value, List<DropdownMenuItem<String>> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        DropdownButtonFormField<String>(
          initialValue: value.isEmpty ? null : value,
          items: items,
          onChanged: (v) { if(v != null) onChanged(v); },
          icon: const Icon(Icons.expand_more),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(BuildContext context, String label, String value, Function(String) onChanged, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// STEP 4: MOTIVATION & INTERESTS
// --------------------------------------------------------------------------
class _Step4MotivationForm extends ConsumerWidget {
  const _Step4MotivationForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(membershipProvider);
    final notifier = ref.read(membershipProvider.notifier);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final realCommittees = [
      {'id': 'heritage', 'ar': 'لجنة التراث', 'en': 'Heritage'},
      {'id': 'children', 'ar': 'لجنة الطفل', 'en': 'Children'},
      {'id': 'tourism', 'ar': 'لجنة السياحة الثقافية', 'en': 'Tourism'},
      {'id': 'research', 'ar': 'لجنة البحث العلمي', 'en': 'Research'},
      {'id': 'memory', 'ar': 'لجنة الذاكرة', 'en': 'History/Memory'},
    ];

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.memStepper3, style: TextStyle(fontFamily: theme.textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          Text(loc.memInterests.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: realCommittees.map((committee) {
              final label = isAr ? committee['ar']! : committee['en']!;
              final isSelected = state.interests.contains(committee['id']);
              return FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => notifier.toggleList('interests', committee['id']!),
                selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.secondaryColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(loc.memMotivation.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: state.motivation,
            onChanged: (v) => notifier.updateField('motivation', v),
            maxLines: 4,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.primaryColor.withOpacity(0.02),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor)),
            ),
          )
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// STEP 5: REVIEW
// --------------------------------------------------------------------------
class _Step5ReviewForm extends ConsumerWidget {
  const _Step5ReviewForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(membershipProvider);
    final notifier = ref.read(membershipProvider.notifier);

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.memStepper4, style: TextStyle(fontFamily: theme.textTheme.headlineMedium?.fontFamily, fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 32),
          // Checkbox for Consent
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24, height: 24,
                child: Checkbox(
                  value: state.hasConsented,
                  onChanged: (v) => notifier.updateField('hasConsented', v),
                  activeColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'أصرح بالتزامي التام بالقانون الأساسي للجمعية (المصادق عليه في 14 ديسمبر 2024) وبنظامها الداخلي، وأتعهد باحترام قيم وثوابت الأمة الجزائرية.',
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              )
            ],
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(child: Text(loc.memPrivacyNote, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// STEP 3: ATTACHMENTS (ID, Photo)
// --------------------------------------------------------------------------
class _Step3AttachmentsForm extends ConsumerWidget {
  const _Step3AttachmentsForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(membershipProvider);
    final notifier = ref.read(membershipProvider.notifier);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasId = state.attachments.any((a) => a['type'] == 'ID_CARD');
    final hasPhoto = state.attachments.any((a) => a['type'] == 'PHOTO');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'الوثائق الثبوتية' : 'Documents Identity',
            style: GoogleFonts.tajawal(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isAr ? 'يرجى تحميل نسخة من بطاقة الهوية وصورة شخصية حديثة' : 'Please upload a copy of your ID and a recent photo',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          _buildUploadCard(
            context, 
            isAr ? 'بطاقة التعريف الوطنية' : 'Identity Card (National ID)',
            'ID_CARD',
            hasId,
            Icons.badge_outlined,
            () async {
              try {
                final file = await ref.read(apiClientProvider).pickFile();
                if (file == null) return;
                
                final result = await ref.read(mediaServiceProvider).uploadMedia(
                  file.bytes!,
                  file.name,
                );
                if (result.isNotEmpty) {
                  final newList = List<Map<String, String>>.from(state.attachments);
                  newList.add({'url': result, 'type': 'ID_CARD'});
                  notifier.updateField('attachments', newList);
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
              }
            }
          ),
          
          const SizedBox(height: 20),
          
          _buildUploadCard(
            context, 
            isAr ? 'صورة شخصية حديثة' : 'Recent Personal Photo',
            'PHOTO',
            hasPhoto,
            Icons.face_retouching_natural_rounded,
            () async {
              try {
                final file = await ref.read(apiClientProvider).pickFile();
                if (file == null) return;
                
                final result = await ref.read(mediaServiceProvider).uploadMedia(
                  file.bytes!,
                  file.name,
                );
                if (result.isNotEmpty) {
                  final newList = List<Map<String, String>>.from(state.attachments);
                  newList.add({'url': result, 'type': 'PHOTO'});
                  notifier.updateField('attachments', newList);
                }
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
              }
            }
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context, String title, String type, bool isDone, IconData icon, VoidCallback onUpload) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onUpload,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDone 
            ? const Color(0xFF22C55E).withOpacity(0.05) 
            : isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone ? const Color(0xFF22C55E).withOpacity(0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF22C55E).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(isDone ? Icons.check_circle_rounded : icon, color: isDone ? const Color(0xFF22C55E) : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    isDone ? 'تم التحميل بنجاح' : 'اضغط للتحميل (JPG, PNG)', 
                    style: TextStyle(fontSize: 11, color: isDone ? const Color(0xFF22C55E) : Colors.grey),
                  ),
                ],
              ),
            ),
            if (!isDone) const Icon(Icons.cloud_upload_outlined, color: AppTheme.accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// STEP 0: CONDITIONS (Based on Art. 10)
// --------------------------------------------------------------------------
class _Step0Conditions extends StatelessWidget {
  const _Step0Conditions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شروط الانضمام',
            style: TextStyle(
              fontFamily: theme.textTheme.displayMedium?.fontFamily,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'وفقاً للمادة 10 من القانون الأساسي للجمعية، يجب أن تتوفر في العضو الشروط التالية:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildConditionItem(
            Icons.volunteer_activism,
            'النشاط الاجتماعي',
            'أن تكون ناشطاً في المجال الاجتماعي ومساهماً في خدمة الصالح العام.',
          ),
          const SizedBox(height: 20),
          _buildConditionItem(
            Icons.palette,
            'الممارسة الفنية',
            'أن تكون ممارساً لأي نوع من أنواع الفنون (موهوب، ممارس، أو أكاديمي).',
          ),
          const SizedBox(height: 20),
          _buildConditionItem(
            Icons.gavel,
            'النزاهة والوطنية',
            'أن لا يكون للمتقدم أي نشاط سابق يتعارض مع المصالح العليا للأمة الجزائرية.',
          ),
          const SizedBox(height: 20),
          _buildConditionItem(
            Icons.payments_outlined,
            'الاشتراك السنوي',
            'الانخراط في الجمعية خاضع لدفع الاشتراك السنوي. لا تُفعَّل العضوية إلا بعد سداد الرسوم المقررة والمصادقة عليها من مكتب الجمعية.',
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.secondaryColor),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'بالمتابعة، أنت تؤكد استيفاءك لهذه الشروط القانونية.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
