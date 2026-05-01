import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/models/market_book.dart';
import 'package:ebzim_app/core/services/marketplace_service.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:ebzim_app/core/services/media_service.dart';
class MarketplaceTab extends ConsumerStatefulWidget {
  const MarketplaceTab({super.key});

  @override
  ConsumerState<MarketplaceTab> createState() => _MarketplaceTabState();
}

class _MarketplaceTabState extends ConsumerState<MarketplaceTab> {
  void _showBookDialog([MarketBook? book]) {
    showDialog(
      context: context,
      builder: (context) => _MarketBookDialog(book: book),
    );
  }

  void _deleteBook(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف', textDirection: TextDirection.rtl),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا الكتاب؟', textDirection: TextDirection.rtl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(marketplaceServiceProvider).deleteBook(id);
      if (success && mounted) {
        ref.invalidate(allMarketBooksProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(allMarketBooksProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookDialog(),
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.add),
        label: Text('إضافة كتاب جديد', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('حدث خطأ: $e')),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Text(
                'لا توجد كتب معروضة للبيع حالياً.',
                style: GoogleFonts.tajawal(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: book.coverImage.isNotEmpty
                        ? Image.network(book.coverImage, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.book, size: 40),
                  ),
                  title: Text(book.titleAr, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                  subtitle: Text('${book.price} DZD - ${book.condition == 'NEW' ? 'جديد' : 'مستعمل'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showBookDialog(book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteBook(book.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MarketBookDialog extends ConsumerStatefulWidget {
  final MarketBook? book;

  const _MarketBookDialog({this.book});

  @override
  ConsumerState<_MarketBookDialog> createState() => _MarketBookDialogState();
}

class _MarketBookDialogState extends ConsumerState<_MarketBookDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleArController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionArController;
  late TextEditingController _priceController;
  late TextEditingController _deliveryCostController;
  late TextEditingController _contactInfoController;
  
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _selectedFilePath;
  String? _existingImageUrl;
  
  String _condition = 'NEW';
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(text: widget.book?.titleAr ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _descriptionArController = TextEditingController(text: widget.book?.descriptionAr ?? '');
    _priceController = TextEditingController(text: widget.book?.price.toString() ?? '');
    _deliveryCostController = TextEditingController(text: widget.book?.deliveryCost.toString() ?? '0');
    _contactInfoController = TextEditingController(text: widget.book?.contactInfo ?? '');
    _existingImageUrl = widget.book?.coverImage;
    _condition = widget.book?.condition ?? 'NEW';
    _isAvailable = widget.book?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _authorController.dispose();
    _descriptionArController.dispose();
    _priceController.dispose();
    _deliveryCostController.dispose();
    _contactInfoController.dispose();
    super.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? uploadedImageUrl;

    if ((_selectedFileBytes != null || _selectedFilePath != null) && _selectedFileName != null) {
      try {
        uploadedImageUrl = await ref.read(mediaServiceProvider).uploadMedia(
              _selectedFileBytes ?? Uint8List(0),
              _selectedFileName!,
              filePath: _selectedFilePath,
            );
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل رفع الصورة: $e')));
        return;
      }
    }

    final finalImageUrl = uploadedImageUrl ?? _existingImageUrl ?? '';

    if (finalImageUrl.isEmpty) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب اختيار صورة الغلاف')));
      return;
    }

    final data = {
      'title': {
        'ar': _titleArController.text,
        'en': _titleArController.text,
        'fr': _titleArController.text,
      },
      'author': _authorController.text,
      'description': {
        'ar': _descriptionArController.text,
        'en': _descriptionArController.text,
        'fr': _descriptionArController.text,
      },
      'price': double.tryParse(_priceController.text) ?? 0,
      'deliveryCost': double.tryParse(_deliveryCostController.text) ?? 0,
      'condition': _condition,
      'coverImage': finalImageUrl,
      'contactInfo': _contactInfoController.text,
      'isAvailable': _isAvailable,
    };

    bool success;
    if (widget.book == null) {
      success = await ref.read(marketplaceServiceProvider).createBook(data);
    } else {
      success = await ref.read(marketplaceServiceProvider).updateBook(widget.book!.id, data);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ref.invalidate(allMarketBooksProvider);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.book == null ? 'تمت الإضافة بنجاح' : 'تم التحديث بنجاح'),
      ));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('حدث خطأ أثناء الحفظ'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                widget.book == null ? 'إضافة كتاب للمتجر' : 'تعديل بيانات الكتاب',
                style: GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleArController,
                decoration: const InputDecoration(labelText: 'عنوان الكتاب'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'اسم المؤلف'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionArController,
                decoration: const InputDecoration(labelText: 'وصف الكتاب (حالته، مميزاته)'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'السعر (د.ج)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'مطلوب' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _deliveryCostController,
                      decoration: const InputDecoration(labelText: 'سعر التوصيل (د.ج)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _condition,
                      decoration: const InputDecoration(labelText: 'حالة الكتاب'),
                      items: const [
                        DropdownMenuItem(value: 'NEW', child: Text('جديد')),
                        DropdownMenuItem(value: 'USED', child: Text('مستعمل')),
                      ],
                      onChanged: (v) => setState(() => _condition = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('متاح للبيع؟'),
                      value: _isAvailable,
                      onChanged: (v) => setState(() => _isAvailable = v!),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('صورة الغلاف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    border: Border.all(color: AppTheme.accentColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedFileBytes != null
                        ? DecorationImage(image: MemoryImage(_selectedFileBytes!), fit: BoxFit.cover)
                        : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                            ? DecorationImage(image: NetworkImage(_existingImageUrl!), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_selectedFileBytes == null && (_existingImageUrl == null || _existingImageUrl!.isEmpty))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_rounded, color: AppTheme.accentColor),
                            const SizedBox(height: 4),
                            Text('اضغط لاختيار صورة', style: TextStyle(color: AppTheme.accentColor, fontSize: 12)),
                          ],
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Icon(Icons.edit, color: Colors.white)),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactInfoController,
                decoration: const InputDecoration(labelText: 'معلومات التواصل (رقم الهاتف أو الواتساب)'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('حفظ', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
