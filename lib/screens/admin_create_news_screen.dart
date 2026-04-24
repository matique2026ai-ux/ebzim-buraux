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
  final String? initialCategory;
  const AdminCreateNewsScreen({super.key, this.existingPost, this.initialCategory});

  @override
  ConsumerState<AdminCreateNewsScreen> createState() => _AdminCreateNewsScreenState();
}

class _AdminCreateNewsScreenState extends ConsumerState<AdminCreateNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleFrController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _summaryArController = TextEditingController();
  final _summaryFrController = TextEditingController();
  final _summaryEnController = TextEditingController();
  final _contentArController = TextEditingController();
  final _contentFrController = TextEditingController();
  final _contentEnController = TextEditingController();

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? _existingImageUrl;
  bool _isPinned = false;
  bool _isLoading = false;

  // Project-specific fields
  String _category = 'ANNOUNCEMENT';
  String _projectStatus = 'GENERAL';
  double _progressPercentage = 0.0;
  final List<ProjectMilestone> _milestones = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingPost != null) {
      final p = widget.existingPost!;
      _titleArController.text = p.titleAr;
      _titleFrController.text = p.titleFr;
      _titleEnController.text = p.titleEn;
      _summaryArController.text = p.summaryAr;
      _summaryFrController.text = p.summaryFr;
      _summaryEnController.text = p.summaryEn;
      _contentArController.text = p.bodyAr;
      _contentFrController.text = p.bodyFr;
      _contentEnController.text = p.bodyEn;
      _existingImageUrl = p.imageUrl;
      _isPinned = p.isPinned;
      _category = p.category;
      _projectStatus = p.projectStatus;
      _progressPercentage = p.progressPercentage;
      _milestones.addAll(p.milestones);
    } else if (widget.initialCategory != null) {
      _category = widget.initialCategory!;
      // Default project status if it's a project category
      if (_category != 'ANNOUNCEMENT') {
        _projectStatus = 'PREPARING';
      }
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

      if ((_selectedFileBytes != null || _selectedFilePath != null) && _selectedFileName != null) {
        uploadedImageUrl = await ref.read(mediaServiceProvider).uploadMedia(
              _selectedFileBytes ?? Uint8List(0),
              _selectedFileName!,
              filePath: _selectedFilePath,
            );
      }

      final isEditing = widget.existingPost != null;
      final finalImageUrl = uploadedImageUrl ?? _existingImageUrl;
      
      final payload = {
        'categoryId': NewsService.newsCategoryId,
        'title': {
          'ar': _titleArController.text,
          'fr': _titleFrController.text,
          'en': _titleEnController.text,
        },
        'summary': {
          'ar': _summaryArController.text,
          'fr': _summaryFrController.text,
          'en': _summaryEnController.text,
        },
        'content': {
          'ar': _contentArController.text,
          'fr': _contentFrController.text,
          'en': _contentEnController.text,
        },
        'status': 'PUBLISHED',
        'isFeatured': false,
        'isPinned': _isPinned,
        'category': _category,
        'projectStatus': _projectStatus,
        'metadata': {
          'progressPercentage': _progressPercentage,
          'milestones': _milestones.map((m) => m.toJson()).toList(),
        }
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
              titleFr: _titleFrController.text,
              titleEn: _titleEnController.text,
              summary: _summaryArController.text,
              summaryFr: _summaryFrController.text,
              summaryEn: _summaryEnController.text,
              content: _contentArController.text,
              contentFr: _contentFrController.text,
              contentEn: _contentEnController.text,
              imageUrl: finalImageUrl,
              isPinned: _isPinned,
              category: _category,
              projectStatus: _projectStatus,
              metadata: {
                'progressPercentage': _progressPercentage,
                'milestones': _milestones.map((m) => m.toJson()).toList(),
              },
            );
      }

      if (mounted) {
        ref.invalidate(adminNewsProvider);
        ref.invalidate(newsProvider);

        final typeLabel = _category == 'ANNOUNCEMENT' ? 'الخبر' : 'المشروع';
        final successMsg = isEditing ? '✅ تم تحديث $typeLabel بنجاح!' : '✅ تم نشر $typeLabel بنجاح!';
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(successMsg),
            backgroundColor: const Color(0xFF15803D),
            duration: const Duration(seconds: 3),
          ),
        );
        // Wait a bit before navigating back
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.go('/admin');
        });
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
    _titleFrController.dispose();
    _titleEnController.dispose();
    _summaryArController.dispose();
    _summaryFrController.dispose();
    _summaryEnController.dispose();
    _contentArController.dispose();
    _contentFrController.dispose();
    _contentEnController.dispose();
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
                      child: const Icon(Icons.post_add_rounded, size: 36, color: _kGreen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.existingPost != null 
                        ? (_category == 'ANNOUNCEMENT' ? 'تعديل هذا الخبر' : 'تعديل هذا المشروع')
                        : (_category == 'ANNOUNCEMENT' ? 'إضافة خبر جديد' : 'إضافة مشروع جديد'),
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

                    _buildLabel(_category == 'ANNOUNCEMENT' ? 'عنوان الخبر (متعدد اللغات) *' : 'عنوان المشروع (متعدد اللغات) *'),
                    const SizedBox(height: 8),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          _buildLanguageTabs(),
                          SliverToBoxAdapter(child: SizedBox(height: 10)), // Dummy spacer
                          Container(
                            height: 60,
                            child: TabBarView(
                              children: [
                                _buildField(controller: _titleArController, hint: 'العربية...', validator: (v) => v == null || v.isEmpty ? 'حقل مطلوب' : null),
                                _buildField(controller: _titleFrController, hint: 'Français...'),
                                _buildField(controller: _titleEnController, hint: 'English...'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.04),

                    const SizedBox(height: 20),

                    _buildLabel(_category == 'ANNOUNCEMENT' ? 'ملخص سريع (متعدد اللغات)' : 'ملخص المشروع (متعدد اللغات)'),
                    const SizedBox(height: 8),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          _buildLanguageTabs(),
                          Container(
                            height: 100,
                            child: TabBarView(
                              children: [
                                _buildField(controller: _summaryArController, hint: 'العربية...', maxLines: 2),
                                _buildField(controller: _summaryFrController, hint: 'Français...', maxLines: 2),
                                _buildField(controller: _summaryEnController, hint: 'English...', maxLines: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.04),

                    const SizedBox(height: 20),

                    _buildLabel(_category == 'ANNOUNCEMENT' ? 'المحتوى التفصيلي (متعدد اللغات) *' : 'وصف المشروع (متعدد اللغات) *'),
                    const SizedBox(height: 8),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          _buildLanguageTabs(),
                          Container(
                            height: 250,
                            child: TabBarView(
                              children: [
                                _buildField(controller: _contentArController, hint: 'العربية...', maxLines: 9, validator: (v) => v == null || v.isEmpty ? 'حقل مطلوب' : null),
                                _buildField(controller: _contentFrController, hint: 'Français...', maxLines: 9),
                                _buildField(controller: _contentEnController, hint: 'English...', maxLines: 9),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.04),
                    
                    const SizedBox(height: 24),

                    SwitchListTile(
                      title: const Text('تثبيت في الأعلى', style: TextStyle(color: Colors.white, fontSize: 14.5)),
                      subtitle: const Text('سيظهر الخبر في الشريط العلوي للمجلة', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      value: _isPinned,
                      onChanged: (val) => setState(() => _isPinned = val),
                      activeColor: _kGreen,
                      contentPadding: EdgeInsets.zero,
                    ).animate().fadeIn(delay: 280.ms),

                    const SizedBox(height: 24),

                    _buildLabel('نوع المنشور'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _CategoryChip(
                          label: 'خبر عام',
                          icon: Icons.newspaper_rounded,
                          isSelected: _category == 'ANNOUNCEMENT',
                          onTap: () => setState(() => _category = 'ANNOUNCEMENT'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'ترميم',
                          icon: Icons.architecture_rounded,
                          isSelected: _category == 'RESTORATION',
                          onTap: () => setState(() => _category = 'RESTORATION'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'ثقافي',
                          icon: Icons.theater_comedy_rounded,
                          isSelected: _category == 'CULTURAL',
                          onTap: () => setState(() => _category = 'CULTURAL'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CategoryChip(
                          label: 'علمي',
                          icon: Icons.science_rounded,
                          isSelected: _category == 'SCIENTIFIC',
                          onTap: () => setState(() => _category = 'SCIENTIFIC'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'فني',
                          icon: Icons.palette_rounded,
                          isSelected: _category == 'ARTISTIC',
                          onTap: () => setState(() => _category = 'ARTISTIC'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CategoryChip(
                          label: 'شراكة',
                          icon: Icons.handshake_rounded,
                          isSelected: _category == 'PARTNERSHIP',
                          onTap: () => setState(() => _category = 'PARTNERSHIP'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'تقرير نشاط',
                          icon: Icons.assignment_rounded,
                          isSelected: _category == 'EVENT_REPORT',
                          onTap: () => setState(() => _category = 'EVENT_REPORT'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CategoryChip(
                          label: 'ذاكرة وطنية',
                          icon: Icons.history_edu_rounded,
                          isSelected: _category == 'MEMORY',
                          onTap: () => setState(() => _category = 'MEMORY'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'سياحة ثقافية',
                          icon: Icons.map_rounded,
                          isSelected: _category == 'TOURISM',
                          onTap: () => setState(() => _category = 'TOURISM'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                         _CategoryChip(
                          label: 'لجنة الطفل',
                          icon: Icons.child_care_rounded,
                          isSelected: _category == 'CHILD',
                          onTap: () => setState(() => _category = 'CHILD'),
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'مشروع مؤسساتي',
                          icon: Icons.business_rounded,
                          isSelected: _category == 'PROJECT',
                          onTap: () => setState(() => _category = 'PROJECT'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    _buildLabel(_category != 'ANNOUNCEMENT' ? 'حالة المشروع' : 'نوع الخبر'),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_category != 'ANNOUNCEMENT') ...[
                            _StatusChip(
                              label: 'قيد التحضير',
                              color: Colors.blue.shade300,
                              isSelected: _projectStatus == 'PREPARING',
                              onTap: () => setState(() => _projectStatus = 'PREPARING'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'انطلاق الإنجاز',
                              color: Colors.indigo.shade400,
                              isSelected: _projectStatus == 'LAUNCHING',
                              onTap: () => setState(() => _projectStatus = 'LAUNCHING'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'نشط',
                              color: Colors.green.shade600,
                              isSelected: _projectStatus == 'ACTIVE',
                              onTap: () => setState(() => _projectStatus = 'ACTIVE'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'متوقف مؤقتاً',
                              color: Colors.orange.shade700,
                              isSelected: _projectStatus == 'ON_HOLD',
                              onTap: () => setState(() => _projectStatus = 'ON_HOLD'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'تم الإنجاز',
                              color: _kGold,
                              isSelected: _projectStatus == 'COMPLETED',
                              onTap: () => setState(() => _projectStatus = 'COMPLETED'),
                            ),
                          ] else ...[
                            _StatusChip(
                              label: 'خبر عام',
                              color: Colors.grey,
                              isSelected: _projectStatus == 'GENERAL' || _projectStatus == 'ANNOUNCEMENT',
                              onTap: () => setState(() => _projectStatus = 'GENERAL'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'خبر هام',
                              color: Colors.orange,
                              isSelected: _projectStatus == 'IMPORTANT',
                              onTap: () => setState(() => _projectStatus = 'IMPORTANT'),
                            ),
                            const SizedBox(width: 10),
                            _StatusChip(
                              label: 'خبر عاجل',
                              color: Colors.red,
                              isSelected: _projectStatus == 'URGENT',
                              onTap: () => setState(() => _projectStatus = 'URGENT'),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (_category != 'ANNOUNCEMENT') ...[
                      const SizedBox(height: 32),
                      _buildLabel('نسبة تقدم المشروع (${(_progressPercentage * 100).toInt()}%)'),
                      Slider(
                        value: _progressPercentage,
                        onChanged: (v) => setState(() => _progressPercentage = v),
                        activeColor: _kGreen,
                        inactiveColor: Colors.white.withValues(alpha: 0.1),
                        thumbColor: _kGold,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel('مراحل المشروع (Milestones)'),
                          ElevatedButton.icon(
                            onPressed: _addMilestone,
                            icon: const Icon(Icons.add_circle_outline, size: 16, color: Colors.white),
                            label: const Text('إضافة مرحلة', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                            backgroundColor: _kGreen.withValues(alpha: 0.3),
                            side: const BorderSide(color: _kGreen),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._milestones.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final milestone = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildField(
                                      controller: TextEditingController(text: milestone.titleAr)..selection = TextSelection.collapsed(offset: milestone.titleAr.length),
                                      hint: 'عنوان المرحلة (مثال: انطلاق الأشغال)',
                                      onChanged: (v) => setState(() => _milestones[idx] = ProjectMilestone(
                                        titleAr: v,
                                        titleEn: v,
                                        date: milestone.date,
                                        isCompleted: milestone.isCompleted,
                                      )),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () => _selectMilestoneDate(idx),
                                          child: Text(
                                            'التاريخ: ${milestone.date.day}/${milestone.date.month}/${milestone.date.year}',
                                            style: const TextStyle(fontSize: 11, color: Colors.white60),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text('مكتملة', style: TextStyle(fontSize: 11, color: Colors.white60)),
                                        Checkbox(
                                          value: milestone.isCompleted,
                                          onChanged: (v) => setState(() => _milestones[idx] = ProjectMilestone(
                                            titleAr: milestone.titleAr,
                                            titleEn: milestone.titleEn,
                                            date: milestone.date,
                                            isCompleted: v ?? false,
                                          )),
                                          activeColor: _kGreen,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => setState(() => _milestones.removeAt(idx)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 40),

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
                              : (widget.existingPost != null 
                                  ? (_category == 'ANNOUNCEMENT' ? 'تحديث الخبر' : 'تحديث المشروع')
                                  : (_category == 'ANNOUNCEMENT' ? 'نشر الخبر' : 'نشر المشروع')),
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
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
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

  void _addMilestone() {
    setState(() {
      _milestones.add(ProjectMilestone(
        titleAr: '',
        titleEn: '',
        date: DateTime.now(),
        isCompleted: false,
      ));
    });
  }

  Widget _buildLanguageTabs() {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicatorColor: _kGold,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: _kGold,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'العربية'),
          Tab(text: 'Français'),
          Tab(text: 'English'),
        ],
      ),
    );
  }

  Future<void> _selectMilestoneDate(int idx) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _milestones[idx].date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _milestones[idx] = ProjectMilestone(
          titleAr: _milestones[idx].titleAr,
          titleEn: _milestones[idx].titleEn,
          date: picked,
          isCompleted: _milestones[idx].isCompleted,
        );
      });
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _kGreen : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _kGreen : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.white60),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
