import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:ebzim_app/core/services/financial_service.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/common_widgets/login_required_overlay.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'dart:typed_data';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/media_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Contributions & Subscriptions Screen
// ─────────────────────────────────────────────────────────────────────────────

enum DonationType { general, project }

class ContributionsScreen extends ConsumerStatefulWidget {
  const ContributionsScreen({super.key});

  @override
  ConsumerState<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends ConsumerState<ContributionsScreen> {
  DonationType _selectedDonationType = DonationType.general;
  String _selectedCurrency = 'DZD';
  final _amountController = TextEditingController();
  bool _isLoadingFee = true;
  int _currentFee = 2000;
  bool _isSubmitting = false;
  NewsPost? _selectedProject;
  String? _proofUrl;
  bool _isUploadingProof = false;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    final settings = await ref.read(financialServiceProvider).getSettings();
    if (mounted) {
      setState(() {
        _currentFee = settings['annualMembershipFee'] ?? 2000;
        _isLoadingFee = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);

    if (userAsync.value == null && !userAsync.isLoading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.accentColor, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text(
            loc.finTitle,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.accentColor),
          ),
          centerTitle: true,
        ),
        body: const EbzimBackground(
          child: LoginRequiredOverlay(
            icon: Icons.volunteer_activism_rounded,
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          loc.finTitle,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 110, 24, 120),
          children: [
            // Move Membership section based on role
            ...(() {
              final user = ref.watch(currentUserProvider).asData?.value;
              final isPublic = user?.role == EbzimRole.public;

              final membershipWidget = Column(
                children: [
                   _SectionHeader(
                    title: isPublic ? loc.finJoinOptional : loc.finMembershipFee, 
                    icon: Icons.card_membership_rounded,
                    isAr: isAr,
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.finMembershipFee,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isDark ? Colors.white.withOpacity(0.5) : Colors.black45),
                                ),
                                _isLoadingFee 
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : Text(
                                      '$_currentFee DZD',
                                      style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.accentColor),
                                    ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: (isPublic ? Colors.blue : Colors.orange).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: (isPublic ? Colors.blue : Colors.orange).withOpacity(0.3)),
                              ),
                              child: Text(
                                isPublic ? loc.dashStatusActive : loc.finNeedsRenewal,
                                style: GoogleFonts.tajawal(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold, 
                                  color: isPublic ? Colors.blue : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _PrimaryButton(
                          label: isPublic ? loc.finApplyJoin : loc.finRenewNow,
                          onTap: () {
                            if (isPublic) {
                              context.push('/membership/apply');
                            } else {
                              _handleSubmit('ANNUAL_MEMBERSHIP', _currentFee.toDouble());
                            }
                          },
                          isLoading: _isSubmitting,
                          isAr: isAr,
                        ),
                      ],
                    ),
                  ),
                ],
              );

              // REORDERING LOGIC
              if (isPublic) {
                // For non-members, show Donations FIRST, then optional membership
                return [
                  const SizedBox(height: 0), // Placeholder
                ];
              } else {
                // For members, show Membership Section first
                return [
                  membershipWidget,
                  const SizedBox(height: 48),
                ];
              }
            }()),

            // ── Section 2: Donations Choice ──────────────────────────────────
            _SectionHeader(
              title: loc.finSupportProjects, 
              icon: Icons.volunteer_activism_rounded,
              isAr: isAr,
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.finChooseType,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  
                  // Selection Toggle (User Choice)
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceChip(
                          label: loc.finGeneral,
                          isSelected: _selectedDonationType == DonationType.general,
                          onTap: () => setState(() => _selectedDonationType = DonationType.general),
                          isAr: isAr,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ChoiceChip(
                          label: loc.finProject,
                          isSelected: _selectedDonationType == DonationType.project,
                          onTap: () => setState(() => _selectedDonationType = DonationType.project),
                          isAr: isAr,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Amount Field & Currency Selector
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            labelText: loc.finAmountLabel,
                            prefixIcon: const Icon(Icons.payments_outlined, color: AppTheme.accentColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: InputDecoration(
                            labelText: isAr ? 'العملة' : 'Currency',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          items: ['DZD', 'EUR', 'USD'].map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedCurrency = val ?? 'DZD'),
                        ),
                      ),
                    ],
                  ),
                  
                  if (_selectedDonationType == DonationType.project) ...[
                    const SizedBox(height: 16),
                    ref.watch(heritageProjectsProvider).when(
                      data: (projects) {
                        if (projects.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              isAr ? 'لا توجد مشاريع نشطة حالياً' : 'No active projects available',
                              style: GoogleFonts.tajawal(fontSize: 12, color: Colors.orange),
                            ),
                          );
                        }
                        return DropdownButtonFormField<NewsPost>(
                          value: _selectedProject ?? (projects.isNotEmpty ? projects.first : null),
                          decoration: InputDecoration(
                            labelText: isAr ? 'اختر المشروع' : 'Select Project',
                            prefixIcon: const Icon(Icons.architecture_rounded, color: AppTheme.accentColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          items: projects.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              p.getTitle(isAr ? 'ar' : 'en'),
                              style: GoogleFonts.tajawal(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedProject = val),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  
                  _ProofUploadTile(
                    onTap: () async {
                      final file = await ref.read(apiClientProvider).pickFile();
                      if (file == null) return;
                      
                      setState(() => _isUploadingProof = true);
                      try {
                        final result = await ref.read(mediaServiceProvider).uploadMedia(
                          file.bytes!,
                          file.name,
                        );
                        if (mounted) setState(() => _proofUrl = result);
                      } catch (e) {
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
                      } finally {
                        if (mounted) setState(() => _isUploadingProof = false);
                      }
                    },
                    isUploaded: _proofUrl != null,
                    isLoading: _isUploadingProof,
                    isAr: isAr,
                  ),

                  const SizedBox(height: 24),
                  _PrimaryButton(
                    label: loc.finSend,
                    onTap: () {
                      final amount = double.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) {
                        _handleSubmit(
                          _selectedDonationType == DonationType.general ? 'GENERAL_DONATION' : 'PROJECT_SUPPORT',
                          amount,
                          currency: _selectedCurrency,
                          projectId: _selectedDonationType == DonationType.project ? _selectedProject?.id : null,
                          proofUrl: _proofUrl,
                        );
                      }
                    },
                    isLoading: _isSubmitting,
                    isAr: isAr,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05),

            // If PUBLIC, show membership as an optional secondary action at the bottom
            ...(() {
              final user = ref.watch(currentUserProvider).asData?.value;
              final isPublic = user?.role == EbzimRole.public;
              
              if (isPublic) {
                return [
                  const SizedBox(height: 48),
                  _SectionHeader(
                    title: loc.finJoinOptional,
                    icon: Icons.card_membership_rounded,
                    isAr: isAr,
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          loc.finJoinInvite,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        _PrimaryButton(
                          label: loc.finApplyJoin,
                          onTap: () => context.push('/membership/apply'),
                          isAr: isAr,
                        ),
                      ],
                    ),
                  ),
                ];
              } else {
                return <Widget>[];
              }
            }()),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String type, double amount, {String currency = 'DZD', String? projectId, String? proofUrl}) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(financialServiceProvider).submitContribution(
        type: type,
        amount: amount,
        currency: currency,
        projectId: projectId,
        proofUrl: proofUrl,
      );
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 48),
          content: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'تم إرسال طلب المساهمة بنجاح. سيتم مراجعة الدفع من قِبل الإدارة وتحديث حالتك قريباً.'
                : 'Contribution request sent. Admin will verify your payment and update your status soon.',
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Components
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isAr;
  const _SectionHeader({required this.title, required this.icon, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAr;

  const _ChoiceChip({required this.label, required this.isSelected, required this.onTap, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppTheme.accentColor : AppTheme.accentColor.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isSelected ? Colors.white : AppTheme.accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isAr;
  final Color? color;

  const _PrimaryButton({required this.label, required this.onTap, this.isLoading = false, required this.isAr, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.accentColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: isLoading 
        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Text(label, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}


class _ProofUploadTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool isUploaded;
  final bool isLoading;
  final bool isAr;

  const _ProofUploadTile({required this.onTap, required this.isUploaded, required this.isLoading, required this.isAr});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUploaded ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
              color: isUploaded ? Colors.green : AppTheme.accentColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'وصل الدفع' : 'Proof of Payment',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    isUploaded 
                      ? (isAr ? 'تم تحميل الوصل' : 'Receipt uploaded') 
                      : (isAr ? 'اضغط لتحميل صورة الوصل (CCP/Bank)' : 'Tap to upload receipt image'),
                    style: TextStyle(fontSize: 11, color: isUploaded ? Colors.green : Colors.grey),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            else if (!isUploaded)
              const Icon(Icons.cloud_upload_outlined, color: AppTheme.accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}
