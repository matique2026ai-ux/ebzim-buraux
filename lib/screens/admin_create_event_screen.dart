import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:ebzim_app/core/services/media_service.dart';
import 'package:ebzim_app/core/services/event_service.dart';

const _kGreen = AppTheme.primaryColor;
const _kGold = Color(0xFFC5A059);

class AdminCreateEventScreen extends ConsumerStatefulWidget {
  final ActivityEvent? existingEvent;
  const AdminCreateEventScreen({super.key, this.existingEvent});

  @override
  ConsumerState<AdminCreateEventScreen> createState() => _AdminCreateEventScreenState();
}

class _AdminCreateEventScreenState extends ConsumerState<AdminCreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _existingImageUrl;
  bool _isLoading = false;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingEvent != null) {
      final e = widget.existingEvent!;
      _titleArController.text = e.titleAr;
      _descriptionArController.text = e.descriptionAr;
      _addressController.text = e.locationAr;
      _selectedDate = e.date;
      _existingImageUrl = e.imageUrl;
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
      if (file.bytes != null) {
        setState(() {
          _selectedFileBytes = file.bytes;
          _selectedFileName = file.name;
        });
      }
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _kGreen,
            onPrimary: Colors.white,
            surface: Color(0xFF1E301E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد تاريخ الفعالية')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? uploadedImageUrl;

      // 1. Upload Image
      if (_selectedFileBytes != null && _selectedFileName != null) {
        uploadedImageUrl = await ref.read(mediaServiceProvider).uploadMedia(
              _selectedFileBytes!,
              _selectedFileName!,
            );
      }

      // 2. Create or Update Event
      final isEditing = widget.existingEvent != null;
      final payload = {
        'categoryId': EventService.eventCategoryId,
        'title': {
          'ar': _titleArController.text,
          'fr': _titleArController.text,
          'en': _titleArController.text,
        },
        'description': {
          'ar': _descriptionArController.text,
          'fr': _descriptionArController.text,
          'en': _descriptionArController.text,
        },
        'startDate': _selectedDate!.toIso8601String(),
        'endDate': _selectedDate!.add(const Duration(hours: 4)).toIso8601String(),
        'location': {
          'formattedAddress': _addressController.text,
        },
        'isOnline': _isOnline,
        'publicationStatus': 'PUBLISHED',
        'eventStatus': 'UPCOMING',
      };

      final finalImageUrl = uploadedImageUrl ?? _existingImageUrl;
      if (finalImageUrl != null && finalImageUrl.isNotEmpty) {
        payload['coverImage'] = {
          'url': finalImageUrl,
          'publicId': finalImageUrl.split('/').last.split('.').first,
        };
      }

      if (isEditing) {
        await ref.read(eventServiceProvider).updateEvent(widget.existingEvent!.id, payload);
      } else {
        await ref.read(eventServiceProvider).createEvent(
              title: _titleArController.text,
              description: _descriptionArController.text,
              startDate: payload['startDate'] as String,
              endDate: payload['endDate'] as String,
              location: _addressController.text,
              isOnline: _isOnline,
              imageUrl: finalImageUrl,
            );
      }

      if (mounted) {
        // Invalidate providers to force a refresh on the admin dashboard
        ref.invalidate(adminEventsProvider);
        ref.invalidate(upcomingEventsProvider);

        final successMsg = isEditing ? '✅ تم تحديث النشاط بنجاح!' : '✅ تمت جدولة النشاط بنجاح!';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ فشل النشر: $e'),
            backgroundColor: Colors.redAccent,
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
    _descriptionArController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A0F),
      body: CustomScrollView(
        slivers: [
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
                      child: const Icon(Icons.event_rounded, size: 36, color: _kGreen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.existingEvent != null ? 'تعديل نشاط موجود' : 'إضافة نشاط جديد',
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

                    // Cover Image
                    _buildLabel('غلاف إعلاني للنشاط'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 160,
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
                        child: _selectedFileBytes != null
                            ? Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 17),
                                      SizedBox(width: 6),
                                      Text('تم الاختيار • اضغط للتغيير', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_rounded, size: 42, color: _kGreen.withValues(alpha: 0.7)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'اضغط لاختيار صورة الغلاف',
                                    style: TextStyle(color: _kGreen.withValues(alpha: 0.9), fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('JPG · PNG · WEBP', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                                ],
                              ),
                      ),
                    ).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 24),

                    // Event Title
                    _buildLabel('عنوان النشاط *'),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _titleArController,
                      hint: 'مثال: ورشة عمل، ملتقى خيري، ندوة ثقافية...',
                      validator: (v) => v == null || v.isEmpty ? 'حقل مطلوب' : null,
                    ).animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 20),

                    // Description
                    _buildLabel('وصف النشاط'),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _descriptionArController,
                      hint: 'اكتب تفاصيل النشاط وأهدافه...',
                      maxLines: 4,
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 20),

                    // Date Picker
                    _buildLabel('موعد الفعالية *'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E301E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedDate != null ? _kGreen : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, color: _kGreen, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate == null
                                  ? 'اختر تاريخ الفعالية'
                                  : '${_selectedDate!.day} / ${_selectedDate!.month} / ${_selectedDate!.year}',
                              style: TextStyle(
                                color: _selectedDate == null ? Colors.white.withValues(alpha: 0.4) : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.3), size: 20),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 230.ms),

                    const SizedBox(height: 16),

                    // Online Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E301E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'النشاط عن بُعد (أونلاين)؟',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        activeTrackColor: _kGreen,
                        value: _isOnline,
                        onChanged: (v) => setState(() => _isOnline = v),
                      ),
                    ).animate().fadeIn(delay: 260.ms),

                    if (!_isOnline) ...[
                      const SizedBox(height: 14),
                      _buildLabel('مكان الفعالية'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: _addressController,
                        hint: 'مقر الجمعية، دار الثقافة...',
                      ).animate().fadeIn(duration: 200.ms),
                    ],

                    const SizedBox(height: 40),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Icon(Icons.event_available_rounded, size: 20),
                        label: Text(
                          _isLoading
                              ? 'جاري النشر...'
                              : (widget.existingEvent != null ? 'تحديث الحدث' : 'نشر الحدث'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(color: _kGold, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.3),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 14.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13.5),
          filled: true,
          fillColor: const Color(0xFF1E301E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _kGreen, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
          errorStyle: const TextStyle(color: Color(0xFFEF4444)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
}
