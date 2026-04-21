import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/auth_service.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  bool _isSaving = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    
    // Splitting the name for the form fields
    // Our UserProfile.name is firstName + lastName
    // We'll try to guess or just use what we have.
    // In a real app, the backend should provide firstName and lastName separately.
    // For now, we use a simple split.
    final nameParts = user?.name.split(' ') ?? [''];
    _firstNameController = TextEditingController(text: nameParts.first);
    _lastNameController = TextEditingController(text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() => _isUploading = true);
        
        final file = result.files.single;
        await ref.read(authProvider.notifier).uploadAvatar(
          file.bytes!,
          file.name,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الصورة الشخصية'), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل الصورة: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(authProvider.notifier).updateProfile({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الملف الشخصي بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.profileEdit,
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.accentColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: EbzimBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- AVATAR EDIT ---
                Center(
                  child: GestureDetector(
                    onTap: _isUploading ? null : _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                            backgroundImage: user?.imageUrl.isNotEmpty == true && user!.imageUrl.startsWith('http')
                                ? NetworkImage(user.imageUrl)
                                : null,
                            child: _isUploading 
                                ? const CircularProgressIndicator(color: AppTheme.accentColor)
                                : ((user?.imageUrl.isEmpty ?? true) || !user!.imageUrl.startsWith('http')
                                    ? const Icon(Icons.person, color: AppTheme.accentColor, size: 40)
                                    : null),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_enhance_rounded, size: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ).animate().scale(),

                const SizedBox(height: 48),

                // --- INPUT FIELDS ---
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel(loc.regFullName),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _firstNameController,
                        hint: 'الاسم أو المستعار',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v!.isEmpty ? loc.valRequired : null,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildFieldLabel('اللقب / العائلة'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _lastNameController,
                        hint: 'اللقب',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),

                      _buildFieldLabel(loc.profilePhone),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _phoneController,
                        hint: '05XX XX XX XX',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.1, delay: 200.ms).fadeIn(),

                const SizedBox(height: 40),

                // --- SAVE BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: AppTheme.accentColor.withOpacity(0.3),
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                        : Text(
                            'حفظ التغييرات',
                            style: GoogleFonts.tajawal(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
                          ),
                  ),
                ).animate().slideY(begin: 0.2, delay: 400.ms).fadeIn(),
                
                const SizedBox(height: 20),
                Text(
                  'سيتم تحديث نسبة إكمال الملف تلقائياً بعد الحفظ',
                  style: GoogleFonts.cairo(color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.playfairDisplay(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppTheme.accentColor.withOpacity(0.7),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.tajawal(fontSize: 16, color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
        prefixIcon: Icon(icon, color: AppTheme.accentColor.withOpacity(0.5), size: 20),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
