import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/services/api_client.dart';
import 'package:ebzim_app/core/services/media_service.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_project_timeline.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_image.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/common_widgets/glass_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AdminCreateProjectScreen extends ConsumerStatefulWidget {
  final NewsPost? existingPost;
  final String? initialCategory;

  const AdminCreateProjectScreen({
    super.key,
    this.existingPost,
    this.initialCategory,
  });

  @override
  ConsumerState<AdminCreateProjectScreen> createState() =>
      _AdminCreateProjectScreenState();
}

class _AdminCreateProjectScreenState
    extends ConsumerState<AdminCreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleArController;
  late TextEditingController _titleFrController;
  late TextEditingController _titleEnController;
  late TextEditingController _summaryArController;
  late TextEditingController _summaryFrController;
  late TextEditingController _summaryEnController;
  late TextEditingController _contentArController;
  late TextEditingController _contentFrController;
  late TextEditingController _contentEnController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  String _category = 'RESTORATION';
  String _status = 'PREPARING';
  double _progress = 0.0;
  List<ProjectMilestone> _milestones = [];
  String? _imageUrl;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(
      text: widget.existingPost?.titleAr ?? '',
    );
    _titleFrController = TextEditingController(
      text: widget.existingPost?.titleFr ?? '',
    );
    _titleEnController = TextEditingController(
      text: widget.existingPost?.titleEn ?? '',
    );
    _summaryArController = TextEditingController(
      text: widget.existingPost?.summaryAr ?? '',
    );
    _summaryFrController = TextEditingController(
      text: widget.existingPost?.summaryFr ?? '',
    );
    _summaryEnController = TextEditingController(
      text: widget.existingPost?.summaryEn ?? '',
    );
    _contentArController = TextEditingController(
      text: widget.existingPost?.bodyAr ?? '',
    );
    _contentFrController = TextEditingController(
      text: widget.existingPost?.bodyFr ?? '',
    );
    _contentEnController = TextEditingController(
      text: widget.existingPost?.bodyEn ?? '',
    );
    _latController = TextEditingController(
      text: widget.existingPost?.latitude?.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: widget.existingPost?.longitude?.toString() ?? '',
    );

    if (widget.existingPost != null) {
      _category = widget.existingPost!.category;
      _status = widget.existingPost!.projectStatus;
      _progress = widget.existingPost!.progressPercentage;
      _milestones = List.from(widget.existingPost!.milestones);
      _imageUrl = widget.existingPost!.imageUrl;
    } else if (widget.initialCategory != null) {
      _category = widget.initialCategory!;
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
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> metadata = {
        'progressPercentage': _progress,
        'milestones': _milestones.map((m) => m.toJson()).toList(),
        'projectStatus': _status,
        'category': _category,
        'latitude': double.tryParse(_latController.text),
        'longitude': double.tryParse(_lngController.text),
      };

      if (widget.existingPost != null) {
        final payload = {
          'title': {
            'ar': _titleArController.text,
            'fr': _titleFrController.text.isNotEmpty
                ? _titleFrController.text
                : _titleArController.text,
            'en': _titleEnController.text.isNotEmpty
                ? _titleEnController.text
                : _titleArController.text,
          },
          'summary': {
            'ar': _summaryArController.text,
            'fr': _summaryFrController.text.isNotEmpty
                ? _summaryFrController.text
                : _summaryArController.text,
            'en': _summaryEnController.text.isNotEmpty
                ? _summaryEnController.text
                : _summaryArController.text,
          },
          'content': {
            'ar': _contentArController.text,
            'fr': _contentFrController.text.isNotEmpty
                ? _contentFrController.text
                : _contentArController.text,
            'en': _contentEnController.text.isNotEmpty
                ? _contentEnController.text
                : _contentArController.text,
          },
          'category': _category,
          'contentType': 'PROJECT',
          'projectStatus': _status,
          'metadata': metadata,
        };

        if (_imageUrl != null) {
          payload['media'] = [
            {
              'type': 'IMAGE',
              'cloudinaryUrl': _imageUrl,
              'publicId': _imageUrl!.split('/').last.split('.').first,
            },
          ];
        }

        await ref
            .read(newsServiceProvider)
            .updatePost(widget.existingPost!.id, payload);
      } else {
        await ref
            .read(newsServiceProvider)
            .createPost(
              title: _titleArController.text,
              titleFr: _titleFrController.text,
              titleEn: _titleEnController.text,
              summary: _summaryArController.text,
              summaryFr: _summaryFrController.text,
              summaryEn: _summaryEnController.text,
              content: _contentArController.text,
              contentFr: _contentFrController.text,
              contentEn: _contentEnController.text,
              imageUrl: _imageUrl,
              category: _category,
              projectStatus: _status,
              metadata: {...metadata, 'contentType': 'PROJECT'},
            );
      }
      if (mounted) {
        // Invalidate providers to refresh the list
        ref.invalidate(adminNewsProvider);
        ref.invalidate(newsProvider);

        final successMsg = widget.existingPost != null
            ? '✅ تم تحديث المشروع المؤسساتي بنجاح!'
            : '✅ تم نشر المشروع المؤسساتي بنجاح!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              successMsg,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: const Color(0xFF15803D),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Wait a bit before navigating back
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.pop();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: EbzimBackground(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImagePicker(),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'المعلومات الأساسية (العربية)',
                          Icons.language_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _titleArController,
                          label: 'عنوان المشروع',
                          hint:
                              'مثال: القافلة الطبية، المهرجان الثقافي، ترميم المعالم...',
                          icon: Icons.title_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _summaryArController,
                          label: 'وصف مختصر',
                          hint: 'وصف سريع للمشروع يظهر في البطاقات...',
                          icon: Icons.short_text_rounded,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _contentArController,
                          label: 'المحتوى الكامل للمشروع',
                          hint:
                              'اكتب هنا كل التفاصيل والأهداف والخطوات التنفيذية...',
                          icon: Icons.article_rounded,
                          maxLines: 8,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'الترجمة الفرنسية (French)',
                          Icons.translate_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _titleFrController,
                          label: 'العنوان (FR)',
                          hint: 'Titre du projet...',
                          icon: Icons.title_rounded,
                          isRequired: false,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _summaryFrController,
                          label: 'الوصف المختصر (FR)',
                          hint: 'Résumé court...',
                          icon: Icons.short_text_rounded,
                          isRequired: false,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _contentFrController,
                          label: 'المحتوى الكامل (FR)',
                          hint: 'Détails complets en français...',
                          icon: Icons.article_rounded,
                          maxLines: 4,
                          isRequired: false,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'الترجمة الإنجليزية (English)',
                          Icons.language_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _titleEnController,
                          label: 'العنوان (EN)',
                          hint: 'Project Title...',
                          icon: Icons.title_rounded,
                          isRequired: false,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _summaryEnController,
                          label: 'الوصف المختصر (EN)',
                          hint: 'Short summary...',
                          icon: Icons.short_text_rounded,
                          isRequired: false,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _contentEnController,
                          label: 'المحتوى الكامل (EN)',
                          hint: 'Full details in English...',
                          icon: Icons.article_rounded,
                          maxLines: 4,
                          isRequired: false,
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'تصنيف وحالة المشروع',
                          Icons.category_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 16),
                        _buildStatusDropdown(),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'الموقع الجغرافي (على الخريطة)',
                          Icons.map_rounded,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _latController,
                                label: 'خط العرض (Lat)',
                                hint: '36.1895',
                                icon: Icons.location_on_outlined,
                                isRequired: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _lngController,
                                label: 'خط الطول (Lng)',
                                hint: '5.4098',
                                icon: Icons.location_on_outlined,
                                isRequired: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildProgressSlider(),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'المحطات والجدول الزمني',
                          Icons.timeline_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildMilestoneEditor(),
                        if (_milestones.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'معاينة الخط الزمني',
                            Icons.visibility_outlined,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.02),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: EbzimProjectTimeline(
                              milestones: _milestones,
                              lang: ref.watch(localeProvider).languageCode,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'تحديد الموقع بدقة',
                          Icons.ads_click_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildMapPicker(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'إدارة الأنشطة والبرامج الجمعوية',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 22),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(
              icon,
              color: AppTheme.accentColor.withOpacity(0.7),
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.accentColor),
            ),
          ),
          validator: isRequired
              ? (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = [
      {
        'value': 'ASSOCIATIVE',
        'label': 'نشاط جمعوي (ولائي)',
        'icon': Icons.groups_rounded,
      },
      {
        'value': 'PROJECT',
        'label': 'مشروع مؤسساتي',
        'icon': Icons.assignment_rounded,
      },
      {
        'value': 'RESTORATION',
        'label': 'حماية التراث والآثار',
        'icon': Icons.museum_rounded,
      },
      {
        'value': 'CULTURAL',
        'label': 'مهرجان / نشاط ثقافي',
        'icon': Icons.palette_rounded,
      },
      {
        'value': 'SOCIAL',
        'label': 'مبادرة اجتماعية',
        'icon': Icons.favorite_rounded,
      },
      {
        'value': 'SCIENTIFIC',
        'label': 'ندوة / بحث علمي',
        'icon': Icons.science_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تصنيف المشروع',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: categories.any((c) => c['value'] == _category)
                  ? _category
                  : 'PROJECT',
              dropdownColor: const Color(0xFF0F172A),
              isExpanded: true,
              items: categories.map((c) {
                return DropdownMenuItem(
                  value: c['value'] as String,
                  child: Row(
                    children: [
                      Icon(
                        c['icon'] as IconData,
                        color: AppTheme.accentColor,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        c['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    final statuses = [
      {'value': 'PREPARING', 'label': 'قيد التحضير', 'color': Colors.blue},
      {'value': 'ONGOING', 'label': 'جاري العمل', 'color': Colors.orange},
      {'value': 'COMPLETED', 'label': 'تم الإنجاز', 'color': Colors.green},
      {'value': 'SUSPENDED', 'label': 'متوقف مؤقتاً', 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'حالة المشروع الحالية',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _status,
              dropdownColor: const Color(0xFF0F172A),
              isExpanded: true,
              items: statuses.map((s) {
                return DropdownMenuItem(
                  value: s['value'] as String,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: s['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        s['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'نسبة الإنجاز الكلية',
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.accentColor,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: AppTheme.accentColor,
            overlayColor: AppTheme.accentColor.withOpacity(0.2),
          ),
          child: Slider(
            value: _progress,
            onChanged: (v) => setState(() => _progress = v),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneEditor() {
    return Column(
      children: [
        ..._milestones.asMap().entries.map((entry) {
          final idx = entry.key;
          final milestone = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: milestone.isCompleted,
                  onChanged: (v) => setState(
                    () =>
                        _milestones[idx] = milestone.copyWith(isCompleted: v!),
                  ),
                  activeColor: AppTheme.accentColor,
                  checkColor: Colors.black,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: milestone.titleAr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'عنوان المحطة...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (v) {
                          _milestones[idx] = milestone.copyWith(titleAr: v);
                          // Trigger UI update for timeline preview
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _milestones.removeAt(idx)),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _milestones.add(
                ProjectMilestone(
                  titleAr: '',
                  titleEn: '',
                  date: DateTime.now(),
                  isCompleted: false,
                ),
              );
            });
          },
          icon: const Icon(
            Icons.add_circle_outline,
            color: AppTheme.accentColor,
          ),
          label: const Text(
            'إضافة محطة جديدة',
            style: TextStyle(color: AppTheme.accentColor, fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: AppTheme.accentColor.withOpacity(0.4),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : const Text(
                'حفظ ونشر المشروع المؤسساتي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة المشروع الرئيسية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _isUploadingImage ? null : _uploadImage,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              image: _imageUrl != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(_imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _isUploadingImage
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentColor,
                    ),
                  )
                : _imageUrl == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppTheme.accentColor.withOpacity(0.5),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'اضغط لاختيار صورة للمشروع',
                        style: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: EbzimImage(
                          imageUrl: _imageUrl,
                          borderRadius: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Row(
                          children: [
                            // Edit Button
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Remove Button
                            InkWell(
                              onTap: () => setState(() => _imageUrl = null),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPicker() {
    final lat = double.tryParse(_latController.text) ?? 36.1915;
    final lng = double.tryParse(_lngController.text) ?? 5.4110;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, lng),
                initialZoom: 13,
                onTap: (tapPosition, point) {
                  setState(() {
                    _latController.text = point.latitude.toStringAsFixed(6);
                    _lngController.text = point.longitude.toStringAsFixed(6);
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.ebzim.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        double.tryParse(_latController.text) ?? lat,
                        double.tryParse(_lngController.text) ?? lng,
                      ),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppTheme.accentColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'انقر على الخريطة لتحديد موقع المشروع بدقة',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Future<void> _uploadImage() async {
    setState(() => _isUploadingImage = true);
    try {
      final mediaService = ref.read(mediaServiceProvider);
      final file = await ref.read(apiClientProvider).pickFile();
      if (file != null) {
        final url = await mediaService.uploadMedia(file.bytes!, file.name);
        setState(() => _imageUrl = url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في رفع الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }
}
