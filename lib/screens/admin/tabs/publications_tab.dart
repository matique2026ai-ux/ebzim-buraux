import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/models/publication.dart';
import 'package:ebzim_app/core/services/publication_service.dart';
import 'admin_shared_components.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:ebzim_app/core/services/api_client.dart';

class PublicationsTab extends ConsumerStatefulWidget {
  const PublicationsTab({super.key});

  @override
  ConsumerState<PublicationsTab> createState() => _PublicationsTabState();
}

class _PublicationsTabState extends ConsumerState<PublicationsTab> {
  PublicationCategory? _filterCategory;

  @override
  Widget build(BuildContext context) {
    final publicationsAsync = ref.watch(allPublicationsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: AdminSectionHeader(
                  title: 'إدارة المكتبة الرقمية',
                  subtitle: 'إضافة وتعديل الكتب، البحوث، والتقارير المؤسساتية',
                  icon: Icons.menu_book_rounded,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('إضافة منشور جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'الكل',
                  isSelected: _filterCategory == null,
                  onSelected: () => setState(() => _filterCategory = null),
                ),
                ...PublicationCategory.values.map((cat) => _FilterChip(
                  label: _getCategoryLabel(cat),
                  isSelected: _filterCategory == cat,
                  onSelected: () => setState(() => _filterCategory = cat),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: publicationsAsync.when(
              data: (allPubs) {
                final filtered = _filterCategory == null 
                    ? allPubs 
                    : allPubs.where((p) => p.category == _filterCategory).toList();

                if (filtered.isEmpty) {
                  return const AdminEmptyState(
                    message: 'لا توجد منشورات في هذا التصنيف حالياً',
                    icon: Icons.library_books_outlined,
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final pub = filtered[index];
                    return _PublicationListTile(
                      pub: pub,
                      onEdit: () => _showAddEditDialog(context, publication: pub),
                      onDelete: () => _confirmDelete(context, pub),
                    );
                  },
                );
              },
              loading: () => const AdminLoadingShimmer(),
              error: (e, _) => AdminErrorState(error: e.toString()),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(PublicationCategory cat) {
    return cat.getLabel('ar');
  }

  void _confirmDelete(BuildContext context, Publication pub) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف منشور'),
        content: Text('هل أنت متأكد من حذف "${pub.titleAr}"؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(publicationServiceProvider).deletePublication(pub.id);
      if (success) {
        ref.invalidate(allPublicationsProvider);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(adminSuccessSnack('تم حذف المنشور بنجاح'));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل في حذف المنشور'));
      }
    }
  }

  void _showAddEditDialog(BuildContext context, {Publication? publication}) {
    showDialog(
      context: context,
      builder: (ctx) => _AddEditPublicationDialog(publication: publication),
    ).then((_) => ref.invalidate(allPublicationsProvider));
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: GoogleFonts.tajawal(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300),
        ),
      ),
    );
  }
}

class _PublicationListTile extends StatelessWidget {
  final Publication pub;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PublicationListTile({
    required this.pub,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(pub.thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pub.titleAr,
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'بواسطة: ${pub.authorAr}',
                  style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _SmallBadge(label: pub.category.name, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('yyyy/MM/dd').format(pub.publishedDate),
                      style: GoogleFonts.playfairDisplay(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red), onPressed: onDelete),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _SmallBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: GoogleFonts.tajawal(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }
}

class _AddEditPublicationDialog extends ConsumerStatefulWidget {
  final Publication? publication;
  const _AddEditPublicationDialog({this.publication});

  @override
  ConsumerState<_AddEditPublicationDialog> createState() => __AddEditPublicationDialogState();
}

class __AddEditPublicationDialogState extends ConsumerState<_AddEditPublicationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleArController;
  late TextEditingController _titleFrController;
  late TextEditingController _titleEnController;
  late TextEditingController _authorArController;
  late TextEditingController _authorFrController;
  late TextEditingController _authorEnController;
  late TextEditingController _summaryArController;
  late TextEditingController _summaryFrController;
  late TextEditingController _summaryEnController;
  late TextEditingController _thumbnailController;
  late TextEditingController _pdfController;
  late PublicationCategory _category;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(text: widget.publication?.titleAr ?? '');
    _titleFrController = TextEditingController(text: widget.publication?.titleFr ?? '');
    _titleEnController = TextEditingController(text: widget.publication?.titleEn ?? '');
    _authorArController = TextEditingController(text: widget.publication?.authorAr ?? '');
    _authorFrController = TextEditingController(text: widget.publication?.authorFr ?? '');
    _authorEnController = TextEditingController(text: widget.publication?.authorEn ?? '');
    _summaryArController = TextEditingController(text: widget.publication?.summaryAr ?? '');
    _summaryFrController = TextEditingController(text: widget.publication?.summaryFr ?? '');
    _summaryEnController = TextEditingController(text: widget.publication?.summaryEn ?? '');
    _thumbnailController = TextEditingController(text: widget.publication?.thumbnailUrl ?? '');
    _pdfController = TextEditingController(text: widget.publication?.pdfUrl ?? '');
    _category = widget.publication?.category ?? PublicationCategory.heritage;
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleFrController.dispose();
    _titleEnController.dispose();
    _authorArController.dispose();
    _authorFrController.dispose();
    _authorEnController.dispose();
    _summaryArController.dispose();
    _summaryFrController.dispose();
    _summaryEnController.dispose();
    _thumbnailController.dispose();
    _pdfController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E301E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
      errorStyle: const TextStyle(color: Color(0xFFEF4444)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
    );

    return AlertDialog(
      backgroundColor: const Color(0xFF0F1A0F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.publication == null ? 'إضافة منشور جديد' : 'تعديل منشور', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.white)),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageTabsField(
                  label: 'العنوان',
                  arController: _titleArController,
                  frController: _titleFrController,
                  enController: _titleEnController,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildLanguageTabsField(
                  label: 'المؤلف',
                  arController: _authorArController,
                  frController: _authorFrController,
                  enController: _authorEnController,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildLanguageTabsField(
                  label: 'الملخص',
                  arController: _summaryArController,
                  frController: _summaryFrController,
                  enController: _summaryEnController,
                  isRequired: false,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PublicationCategory>(
                  value: _category,
                  dropdownColor: const Color(0xFF0F1A0F),
                  style: const TextStyle(color: Colors.white),
                  decoration: fieldDecoration.copyWith(labelText: 'التصنيف', labelStyle: const TextStyle(color: AppTheme.primaryColor)),
                  items: PublicationCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.getLabel('ar')))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),
                _FileUploadField(
                  label: 'صورة الغلاف (Image)',
                  controller: _thumbnailController,
                  allowedExtensions: const ['jpg', 'png', 'jpeg', 'webp'],
                  onUpload: (url) => setState(() => _thumbnailController.text = url),
                ),
                const SizedBox(height: 12),
                _FileUploadField(
                  label: 'ملف الكتاب (PDF)',
                  controller: _pdfController,
                  allowedExtensions: const ['pdf'],
                  onUpload: (url) => setState(() => _pdfController.text = url),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Color(0xFFC5A059)))),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
          child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('حفظ'),
        ),
      ],
    );
  }

  Widget _buildLanguageTabsField({
    required String label,
    required TextEditingController arController,
    required TextEditingController frController,
    required TextEditingController enController,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    final fieldStyle = const TextStyle(color: Colors.white, fontSize: 14.5);
    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E301E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
      errorStyle: const TextStyle(color: Color(0xFFEF4444)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label${isRequired ? ' *' : ''}', style: const TextStyle(color: Color(0xFFC5A059), fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                  labelColor: const Color(0xFFC5A059),
                  unselectedLabelColor: Colors.white38,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: const Color(0xFFC5A059),
                  tabs: const [Tab(text: 'العربية'), Tab(text: 'Français'), Tab(text: 'English')],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: maxLines == 1 ? 55 : 100,
                child: TabBarView(
                  children: [
                    TextFormField(
                      controller: arController,
                      maxLines: maxLines,
                      style: fieldStyle,
                      decoration: fieldDecoration.copyWith(hintText: 'بالعربية...'),
                      validator: isRequired ? (v) => v!.isEmpty ? 'مطلوب' : null : null,
                    ),
                    TextFormField(
                      controller: frController,
                      maxLines: maxLines,
                      style: fieldStyle,
                      decoration: fieldDecoration.copyWith(hintText: 'En Français...'),
                    ),
                    TextFormField(
                      controller: enController,
                      maxLines: maxLines,
                      style: fieldStyle,
                      decoration: fieldDecoration.copyWith(hintText: 'In English...'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    final data = {
      'title': {'ar': _titleArController.text, 'en': _titleEnController.text, 'fr': _titleFrController.text},
      'author': {'ar': _authorArController.text, 'en': _authorEnController.text, 'fr': _authorFrController.text},
      'summary': {'ar': _summaryArController.text, 'en': _summaryEnController.text, 'fr': _summaryFrController.text},
      'thumbnailUrl': _thumbnailController.text,
      'pdfUrl': _pdfController.text,
      'category': _category.name.toUpperCase(),
      'publishedDate': DateTime.now().toIso8601String(),
    };

    String? errorMessage;
    bool success = false;
    try {
      if (widget.publication == null) {
        success = await ref.read(publicationServiceProvider).createPublication(data);
      } else {
        success = await ref.read(publicationServiceProvider).updatePublication(widget.publication!.id, data);
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ref.invalidate(allPublicationsProvider);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(adminSuccessSnack('تم حفظ المنشور بنجاح'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(adminErrorSnack('فشل: ${errorMessage ?? "خطأ غير معروف"}'));
      }
    }
  }
}

class _FileUploadField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final List<String> allowedExtensions;
  final Function(String) onUpload;

  const _FileUploadField({
    required this.label,
    required this.controller,
    required this.allowedExtensions,
    required this.onUpload,
  });

  @override
  ConsumerState<_FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends ConsumerState<_FileUploadField> {
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() => _isUploading = true);
      final file = result.files.single;
      
      try {
        final url = await ref.read(publicationServiceProvider).uploadFile(file.bytes!, file.name);
        if (mounted) {
          setState(() => _isUploading = false);
          widget.onUpload(url);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            adminErrorSnack(e.toString().replaceAll('Exception: ', '')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(color: Colors.white, fontSize: 14.5),
            decoration: InputDecoration(
              hintText: '${widget.label}*',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13.5),
              filled: true,
              fillColor: const Color(0xFF1E301E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
              errorStyle: const TextStyle(color: Color(0xFFEF4444)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (v) => v!.isEmpty ? 'مطلوب رفع الملف' : null,
            readOnly: true,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickAndUpload,
          icon: _isUploading 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.upload_file_rounded),
          label: const Text('رفع'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            foregroundColor: AppTheme.primaryColor,
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
