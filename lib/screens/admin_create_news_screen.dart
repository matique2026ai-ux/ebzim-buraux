import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:ebzim_app/core/services/media_service.dart';
import 'package:ebzim_app/core/services/news_service.dart';

const _kGreen = AppTheme.primaryColor;
const _kGold = Color(0xFFC5A059);

class AdminCreateNewsScreen extends ConsumerStatefulWidget {
  final NewsPost? existingPost;
  const AdminCreateNewsScreen({super.key, this.existingPost});

  @override
  ConsumerState<AdminCreateNewsScreen> createState() => _AdminCreateNewsScreenState();
}

class _AdminCreateNewsScreenState extends ConsumerState<AdminCreateNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _summaryArController = TextEditingController();
  final _contentArController = TextEditingController();

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? _existingImageUrl;
  bool _isPinned = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingPost != null) {
      final p = widget.existingPost!;
      _titleArController.text = p.titleAr;
      _summaryArController.text = p.summaryAr;
      _contentArController.text = p.bodyAr;
      _existingImageUrl = p.imageUrl;
      _isPinned = p.isPinned;
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty && mounted) {
      final file = result.files.first;
      if (file.bytes != null || file.path != null) {
        setState(() {
          _selectedFileBytes = file.bytes;
          _selectedFileName = file.name;
          _selectedFilePath = file.path;
        });
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      String? uploadedImageUrl;

      // 1. Upload Image to Cloudinary if selected
      if ((_selectedFileBytes != null || _selectedFilePath != null) && _selectedFileName != null) {
        uploadedImageUrl = await ref.read(mediaServiceProvider).uploadMedia(
              _selectedFileBytes ?? Uint8List(0),
              _selectedFileName!,
              filePath: _selectedFilePath,
            );
      }

      // 2. Create or Update Post in Backend
      final isEditing = widget.existingPost != null;
      final finalImageUrl = uploadedImageUrl ?? _existingImageUrl;
      
      final payload = {
        'categoryId': NewsService.newsCategoryId,
        'title': {
          'ar': _titleArController.text,
          'fr': _titleArController.text.isNotEmpty ? _titleArController.text : ' ',
          'en': _titleArController.text.isNotEmpty ? _titleArController.text : ' ',
        },
        'summary': {
          'ar': _summaryArController.text.isNotEmpty ? _summaryArController.text : ' ',
          'fr': _summaryArController.text.isNotEmpty ? _summaryArController.text : ' ',
          'en': _summaryArController.text.isNotEmpty ? _summaryArController.text : ' ',
        },
        'content': {
          'ar': _contentArController.text,
          'fr': _contentArController.text.isNotEmpty ? _contentArController.text : ' ',
          'en': _contentArController.text.isNotEmpty ? _contentArController.text : ' ',
        },
        'status': 'PUBLISHED',
        'isFeatured': false,
        'isPinned': _isPinned,
      };

      if (finalImageUrl != null && finalImageUrl.isNotEmpty) {
        payload['media'] = [
          {
            'type': 'IMAGE',
            'cloudinaryUrl': finalImageUrl,
            'publicId': finalImageUrl.split('/').last.split('.').first,
          }
        ];
      }

      if (isEditing) {
        await ref.read(newsServiceProvider).updatePost(widget.existingPost!.id, payload);
      } else {
        await ref.read(newsServiceProvider).createPost(
              title: _titleArController.text,
              summary: _summaryArController.text,
              content: _contentArController.text,
              imageUrl: finalImageUrl,
              isPinned: _isPinned,
            );
      }

      if (mounted) {
        // Invalidate providers to force a refresh on the admin dashboard
        ref.invalidate(adminNewsProvider);
        ref.invalidate(newsProvider);

        final successMsg = isEditing ? '✅ تم تحديث الخبر بنجاح!' : '✅ تم نشر الخبر بنجاح!';
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(successMsg),
            backgroundColor: const Color(0xFF15803D),
          ),
        );
        context.go('/admin');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('❌ فشل النشر'),
            content: SingleChildScrollView(child: Text('حدث خطأ أثناء التواصل مع السيرفر:\n\n$e')),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('حسناً'))
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _summaryArController.dispose();
    _contentArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A0F),
      body: CustomScrollView(
        slivers: [
          // Custom AppBar
          SliverAppBar(
            backgroundColor: const Color(0xFF0F1A0F),
            expandedHeight: 160,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _kGold),
              onPressed: () => context.go('/admin'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A2E1A), Color(0xFF0F1A0F)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _kGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: _kGreen.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: const Icon(Icons.post_add_rounded, size: 36, color: _kGreen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.existingPost != null ? 'تعديل هذا الخبر' : 'إضافة خبر جديد',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Cover Image Section - FIRST, most prominent
                    _buildLabel('صورة الغلاف'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (_selectedFileBytes != null || _existingImageUrl != null)
                                ? const Color(0xFF22C55E)
                                : _kGreen.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          color: const Color(0xFF1A2E1A),
                          image: _selectedFileBytes != null
                              ? DecorationImage(image: MemoryImage(_selectedFileBytes!), fit: BoxFit.cover)
                              : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                                  ? DecorationImage(image: NetworkImage(_existingImageUrl!), fit: BoxFit.cover)
                                  : null,
                        ),
                        child: (_selectedFileBytes != null || _existingImageUrl != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                      child: Container(color: Colors.transparent),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
                                          const SizedBox(width: 6),
                                          const Text('تم الاختيار • اضغط للتغيير', style: TextStyle(color: Colors.white, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_rounded, size: 48, color: _kGreen.withValues(alpha: 0.7)),
                                  const SizedBox(height: 10),
                                  Text(
                                    'اضغط لاختيار صورة الغلاف',
                                    style: TextStyle(color: _kGreen.withValues(alpha: 0.9), fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'JPG · PNG · WEBP',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                                  ),
                                ],
                              ),
                      ),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 28),

                    // Title
                    _buildLabel('عنوان الخبر *'),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _titleArController,
                      hint: 'أدخل عنوان الخبر...',
                      validator: (v) => v == null || v.isEmpty ? 'حقل مطلوب' : null,
                    ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.04),

                    const SizedBox(height: 20),

                    // Summary
                    _buildLabel('ملخص سريع (للبطاقات)'),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _summaryArController,
                      hint: 'وصف موجز يظهر في قائمة الأخبار...',
                      maxLines: 2,
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.04),

                    const SizedBox(height: 20),

                    // Content
                    _buildLabel('نص الخبر الكامل *'),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _contentArController,
                      hint: 'اكتب محتوى الخبر هنا بالتفصيل...',
                      maxLines: 9,
                      validator: (v) => v == null || v.isEmpty ? 'حقل مطلوب' : null,
                    ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.04),
                    
                    const SizedBox(height: 24),

                    // Pin Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isPinned ? AppTheme.heritageOrange.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isPinned ? AppTheme.heritageOrange : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.push_pin_rounded,
                            color: _isPinned ? AppTheme.heritageOrange : Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تثبيت هذا المقال',
                                  style: TextStyle(
                                    color: _isPinned ? AppTheme.heritageOrange : Colors.white.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'سيظهر في أعلى القائمة بلون مميز',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPinned,
                            onChanged: (v) => setState(() => _isPinned = v),
                            activeColor: AppTheme.heritageOrange,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Icon(Icons.send_rounded, size: 20),
                        label: Text(
                          _isLoading
                              ? 'جاري النشر...'
                              : (widget.existingPost != null ? 'تحديث الخبر' : 'نشر الخبر'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 6,
                          shadowColor: _kGreen.withValues(alpha: 0.4),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _kGold,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13.5),
        filled: true,
        fillColor: const Color(0xFF1E301E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFEF4444)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
