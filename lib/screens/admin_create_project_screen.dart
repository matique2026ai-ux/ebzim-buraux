import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/services/news_service.dart';
import 'package:ebzim_app/core/models/news_post.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';

class AdminCreateProjectScreen extends ConsumerStatefulWidget {
  final NewsPost? existingPost;
  final String? initialCategory;

  const AdminCreateProjectScreen({
    super.key,
    this.existingPost,
    this.initialCategory,
  });

  @override
  ConsumerState<AdminCreateProjectScreen> createState() => _AdminCreateProjectScreenState();
}

class _AdminCreateProjectScreenState extends ConsumerState<AdminCreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  
  String _category = 'RESTORATION';
  String _status = 'PREPARING';
  double _progress = 0.0;
  List<ProjectMilestone> _milestones = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingPost?.titleAr ?? '');
    _summaryController = TextEditingController(text: widget.existingPost?.summaryAr ?? '');
    _contentController = TextEditingController(text: widget.existingPost?.bodyAr ?? '');
    
    if (widget.existingPost != null) {
      _category = widget.existingPost!.category;
      _status = widget.existingPost!.projectStatus;
      _progress = widget.existingPost!.progressPercentage;
      _milestones = List.from(widget.existingPost!.milestones);
    } else if (widget.initialCategory != null) {
      _category = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      if (widget.existingPost != null) {
        await ref.read(newsServiceProvider).updatePost(
          id: widget.existingPost!.id,
          title: _titleController.text,
          summary: _summaryController.text,
          content: _contentController.text,
          category: _category,
          projectStatus: _status,
          metadata: {
            'progressPercentage': _progress,
            'milestones': _milestones.map((m) => m.toJson()).toList(),
          },
        );
      } else {
        await ref.read(newsServiceProvider).createPost(
          title: _titleController.text,
          summary: _summaryController.text,
          content: _contentController.text,
          category: _category,
          projectStatus: _status,
          metadata: {
            'progressPercentage': _progress,
            'milestones': _milestones.map((m) => m.toJson()).toList(),
          },
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الحفظ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('المعلومات الأساسية', Icons.info_outline),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _titleController,
                      label: 'عنوان المشروع (بالعربية)',
                      hint: 'مثال: ترميم قصر الحمراء...',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _summaryController,
                      label: 'وصف مختصر',
                      hint: 'وصف سريع للمشروع يظهر في البطاقات...',
                      icon: Icons.short_text_rounded,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('حالة المشروع والتقدم', Icons.trending_up_rounded),
                    const SizedBox(height: 20),
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),
                    _buildProgressSlider(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'إدارة مشروع مؤسساتي',
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
                AppTheme.primaryColor.withOpacity(0.8),
                const Color(0xFF020617),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(icon, color: AppTheme.accentColor.withOpacity(0.7), size: 20),
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
          validator: (v) => v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
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

    return Container(
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
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: s['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(s['label'] as String, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) => setState(() => _status = v!),
        ),
      ),
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('نسبة الإنجاز الكلية', style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 18),
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: AppTheme.accentColor.withOpacity(0.4),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : const Text(
                'حفظ ونشر المشروع المؤسساتي',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
      ),
    );
  }
}
