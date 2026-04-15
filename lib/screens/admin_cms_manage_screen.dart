import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/models/cms_models.dart';
import 'package:ebzim_app/core/services/cms_content_service.dart';
import 'package:ebzim_app/core/services/media_service.dart';

enum CMSManageType { hero, partner, leadership }

class AdminCmsManageScreen extends ConsumerStatefulWidget {
  final String contentType; 
  const AdminCmsManageScreen({super.key, required this.contentType});

  CMSManageType get type {
    if (contentType == 'partner') return CMSManageType.partner;
    if (contentType == 'leadership') return CMSManageType.leadership;
    return CMSManageType.hero;
  }

  @override
  ConsumerState<AdminCmsManageScreen> createState() => _AdminCmsManageScreenState();
}

class _AdminCmsManageScreenState extends ConsumerState<AdminCmsManageScreen> {
  String get title {
    switch (widget.type) {
      case CMSManageType.hero: return 'إدارة شريط الواجهة';
      case CMSManageType.partner: return 'إدارة الشركاء';
      case CMSManageType.leadership: return 'إدارة المكتب التنفيذي';
    }
  }

  IconData get titleIcon {
    switch (widget.type) {
      case CMSManageType.hero: return Icons.slideshow_rounded;
      case CMSManageType.partner: return Icons.handshake_rounded;
      case CMSManageType.leadership: return Icons.people_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slidesAsync = ref.watch(heroSlidesProvider);
    final partnersAsync = ref.watch(partnersProvider);
    final leadershipAsync = ref.watch(leadershipProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppTheme.accentColor,
        onRefresh: () async {
          ref.invalidate(heroSlidesProvider);
          ref.invalidate(partnersProvider);
          ref.invalidate(leadershipProvider);
        },
        child: _buildList(slidesAsync, partnersAsync, leadershipAsync),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add_rounded, color: AppTheme.accentColor),
        label: Text('إضافة جديد', style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showEditorDialog(context, null),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(titleIcon, color: AppTheme.accentColor, size: 20),
          const SizedBox(width: 10),
          Text(title, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF052011), Color(0xFF0A3D21)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildList(AsyncValue<List<HeroSlide>> slides, AsyncValue<List<Partner>> partners, AsyncValue<List<EbzimLeader>> leadership) {
    switch (widget.type) {
      case CMSManageType.hero:
        return slides.when(
          data: (list) => list.isEmpty
              ? _EmptyState(label: 'لا توجد شرائح بعد', icon: Icons.slideshow_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _HeroSlideTile(
                    slide: list[i],
                    onEdit: () => _showEditorDialog(context, list[i]),
                    onDelete: () => _confirmDelete(list[i].id),
                  ),
                ),
          loading: () => const _LoadingState(),
          error: (e, _) => _ErrorState(message: '$e'),
        );
      case CMSManageType.partner:
        return partners.when(
          data: (list) => list.isEmpty
              ? _EmptyState(label: 'لا يوجد شركاء بعد', icon: Icons.handshake_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _PartnerTile(
                    partner: list[i],
                    onEdit: () => _showEditorDialog(context, list[i]),
                    onDelete: () => _confirmDelete(list[i].id),
                  ),
                ),
          loading: () => const _LoadingState(),
          error: (e, _) => _ErrorState(message: '$e'),
        );
      case CMSManageType.leadership:
        return leadership.when(
          data: (list) => list.isEmpty
              ? _EmptyState(label: 'لا توجد قيادة بعد', icon: Icons.people_outline)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _LeaderTile(
                    leader: list[i],
                    onEdit: () => _showEditorDialog(context, list[i]),
                    onDelete: () => _confirmDelete(list[i].id),
                  ),
                ),
          loading: () => const _LoadingState(),
          error: (e, _) => _ErrorState(message: '$e'),
        );
    }
  }

  Future<void> _confirmDelete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 10),
          Text('تأكيد الحذف', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        ]),
        content: Text('هل أنت متأكد من حذف هذا العنصر نهائياً؟', style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: GoogleFonts.tajawal()),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 18),
            label: Text('حذف', style: GoogleFonts.tajawal(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final service = ref.read(cmsContentServiceProvider);
        switch (widget.type) {
          case CMSManageType.hero: await service.deleteHeroSlide(id); break;
          case CMSManageType.partner: await service.deletePartner(id); break;
          case CMSManageType.leadership: await service.deleteLeader(id); break;
        }
        _refresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم الحذف بنجاح', style: GoogleFonts.tajawal()), backgroundColor: Colors.red.shade700),
          );
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  void _refresh() {
    ref.invalidate(heroSlidesProvider);
    ref.invalidate(partnersProvider);
    ref.invalidate(leadershipProvider);
  }

  void _showEditorDialog(BuildContext context, dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _CMSEditorForm(
          type: widget.type,
          item: item,
          onSaved: () {
            _refresh();
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم الحفظ بنجاح ✓', style: GoogleFonts.tajawal(color: Colors.white)),
                backgroundColor: AppTheme.primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor));
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 48),
      const SizedBox(height: 12),
      Text(message, style: GoogleFonts.tajawal(color: Colors.red)),
    ]),
  );
}

class _EmptyState extends StatelessWidget {
  final String label;
  final IconData icon;
  const _EmptyState({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: Colors.grey.shade300),
      const SizedBox(height: 16),
      Text(label, style: GoogleFonts.tajawal(color: Colors.grey, fontSize: 16)),
      const SizedBox(height: 8),
      Text('اضغط + لإضافة عنصر جديد', style: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 12)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TILES
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSlideTile extends StatelessWidget {
  final HeroSlide slide;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _HeroSlideTile({required this.slide, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            SizedBox(
              width: 100, height: 80,
              child: CachedNetworkImage(
                imageUrl: slide.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(slide.titleAr, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(slide.subtitleAr, style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Color(0xFF2196F3), size: 20), onPressed: onEdit, tooltip: 'تعديل'),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20), onPressed: onDelete, tooltip: 'حذف'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerTile extends StatelessWidget {
  final Partner partner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _PartnerTile({required this.partner, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = _hexColor(partner.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(6),
              child: CachedNetworkImage(imageUrl: partner.logoUrl, fit: BoxFit.contain,
                errorWidget: (_, __, ___) => Icon(Icons.business_rounded, color: color)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(partner.nameAr, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14)),
                  if (partner.goalsSummaryAr.isNotEmpty)
                    Text(partner.goalsSummaryAr, style: GoogleFonts.tajawal(fontSize: 11, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Color(0xFF2196F3), size: 20), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (_) {
      return AppTheme.accentColor;
    }
  }
}

class _LeaderTile extends StatelessWidget {
  final EbzimLeader leader;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _LeaderTile({required this.leader, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.accentColor.withValues(alpha: 0.1),
              backgroundImage: leader.photoUrl != null ? CachedNetworkImageProvider(leader.photoUrl!) : null,
              child: leader.photoUrl == null ? const Icon(Icons.person_rounded, color: AppTheme.accentColor, size: 28) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leader.nameAr, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(leader.roleAr, style: GoogleFonts.tajawal(fontSize: 12, color: AppTheme.accentColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Color(0xFF2196F3), size: 20), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDITOR FORM (Premium Multilingual Bottom Sheet)
// ─────────────────────────────────────────────────────────────────────────────

class _CMSEditorForm extends ConsumerStatefulWidget {
  final CMSManageType type;
  final dynamic item;
  final VoidCallback onSaved;
  const _CMSEditorForm({required this.type, this.item, required this.onSaved});

  @override
  ConsumerState<_CMSEditorForm> createState() => _CMSEditorFormState();
}

class _CMSEditorFormState extends ConsumerState<_CMSEditorForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _data;
  bool _isLoading = false;
  String? _previewUrl;
  late TabController _langTab;

  @override
  void initState() {
    super.initState();
    _langTab = TabController(length: 3, vsync: this);
    _initData();
    _previewUrl = _getInitialPreviewUrl();
  }

  @override
  void dispose() {
    _langTab.dispose();
    super.dispose();
  }

  String? _getInitialPreviewUrl() {
    if (widget.item == null) return null;
    if (widget.type == CMSManageType.hero) return (widget.item as HeroSlide).imageUrl;
    if (widget.type == CMSManageType.partner) return (widget.item as Partner).logoUrl;
    if (widget.type == CMSManageType.leadership) return (widget.item as EbzimLeader).photoUrl;
    return null;
  }

  void _initData() {
    if (widget.item == null) {
      _data = {
        'title': {'ar': '', 'en': '', 'fr': ''},
        'subtitle': {'ar': '', 'en': '', 'fr': ''},
        'name': {'ar': '', 'en': '', 'fr': ''},
        'goalsSummary': {'ar': '', 'en': '', 'fr': ''},
        'role': {'ar': '', 'en': '', 'fr': ''},
        'imageUrl': '',
        'logoUrl': '',
        'photoUrl': '',
        'color': '1A6B3A',
        'order': 0,
      };
      return;
    }
    final item = widget.item;
    if (widget.type == CMSManageType.hero) {
      final s = item as HeroSlide;
      _data = {
        'title': {'ar': s.titleAr, 'en': s.titleEn, 'fr': s.titleFr},
        'subtitle': {'ar': s.subtitleAr, 'en': s.subtitleEn, 'fr': s.subtitleFr},
        'imageUrl': s.imageUrl,
        'order': s.order,
      };
    } else if (widget.type == CMSManageType.partner) {
      final p = item as Partner;
      _data = {
        'name': {'ar': p.nameAr, 'en': p.nameEn, 'fr': p.nameFr},
        'goalsSummary': {'ar': p.goalsSummaryAr, 'en': p.goalsSummaryEn, 'fr': p.goalsSummaryFr},
        'logoUrl': p.logoUrl,
        'color': p.color,
        'order': p.order,
      };
    } else if (widget.type == CMSManageType.leadership) {
      final l = item as EbzimLeader;
      _data = {
        'name': {'ar': l.nameAr, 'en': l.nameEn, 'fr': ''},
        'role': {'ar': l.roleAr, 'en': l.roleEn, 'fr': l.roleFr},
        'photoUrl': l.photoUrl ?? '',
        'order': l.order,
      };
    }
  }

  void _updateData(String key, dynamic value) {
    if (key.contains('.')) {
      final parts = key.split('.');
      if (_data[parts[0]] is! Map) _data[parts[0]] = <String, dynamic>{};
      (_data[parts[0]] as Map)[parts[1]] = value;
    } else {
      _data[key] = value;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    try {
      final service = ref.read(cmsContentServiceProvider);
      final id = widget.item?.id;

      if (widget.type == CMSManageType.hero) {
        id == null ? await service.createHeroSlide(_data) : await service.updateHeroSlide(id, _data);
      } else if (widget.type == CMSManageType.partner) {
        id == null ? await service.createPartner(_data) : await service.updatePartner(id, _data);
      } else if (widget.type == CMSManageType.leadership) {
        id == null ? await service.createLeader(_data) : await service.updateLeader(id, _data);
      }
      widget.onSaved();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e', style: GoogleFonts.tajawal())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(width: 48, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: Icon(isEdit ? Icons.edit_rounded : Icons.add_rounded, color: AppTheme.accentColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isEdit ? 'تعديل البيانات' : 'إضافة جديد', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(_getSubtitle(), style: GoogleFonts.tajawal(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.type == CMSManageType.hero) ..._heroFields(),
                    if (widget.type == CMSManageType.partner) ..._partnerFields(),
                    if (widget.type == CMSManageType.leadership) ..._leaderFields(),
                    const SizedBox(height: 24),
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentColor),
                                  const SizedBox(width: 10),
                                  Text('حفظ التغييرات', style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSubtitle() {
    switch (widget.type) {
      case CMSManageType.hero: return 'شريحة الصفحة الرئيسية';
      case CMSManageType.partner: return 'شريك مؤسسي';
      case CMSManageType.leadership: return 'عضو المكتب التنفيذي';
    }
  }

  List<Widget> _heroFields() {
    return [
      _sectionLabel('الصورة', Icons.image_rounded),
      _imagePreviewField('imageUrl', 'رابط الصورة (URL)', _data['imageUrl']),
      const SizedBox(height: 20),
      _sectionLabel('العنوان الرئيسي', Icons.title_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('العنوان (عربي) *', 'title.ar', _data['title']?['ar'], required: true, isAr: true),
          _buildTextField('Title (English)', 'title.en', _data['title']?['en'], isAr: false),
          _buildTextField('Titre (Français)', 'title.fr', _data['title']?['fr'], isAr: false),
        ],
      ),
      const SizedBox(height: 20),
      _sectionLabel('العنوان الفرعي', Icons.subtitles_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('العنوان الفرعي (عربي)', 'subtitle.ar', _data['subtitle']?['ar'], isAr: true),
          _buildTextField('Subtitle (English)', 'subtitle.en', _data['subtitle']?['en'], isAr: false),
          _buildTextField('Sous-titre (Français)', 'subtitle.fr', _data['subtitle']?['fr'], isAr: false),
        ],
        tabKey: 'sub',
      ),
    ];
  }

  List<Widget> _partnerFields() {
    return [
      _sectionLabel('شعار الشريك', Icons.image_rounded),
      _imagePreviewField('logoUrl', 'رابط الشعار (URL)', _data['logoUrl']),
      const SizedBox(height: 20),
      _sectionLabel('اسم الشريك', Icons.business_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('الاسم (عربي) *', 'name.ar', _data['name']?['ar'], required: true, isAr: true),
          _buildTextField('Name (English)', 'name.en', _data['name']?['en'], isAr: false),
          _buildTextField('Nom (Français)', 'name.fr', _data['name']?['fr'], isAr: false),
        ],
      ),
      const SizedBox(height: 20),
      _sectionLabel('ملخص أهداف الشراكة', Icons.description_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('الأهداف (عربي)', 'goalsSummary.ar', _data['goalsSummary']?['ar'], isAr: true, maxLines: 3),
          _buildTextField('Goals (English)', 'goalsSummary.en', _data['goalsSummary']?['en'], isAr: false, maxLines: 3),
          _buildTextField('Objectifs (Français)', 'goalsSummary.fr', _data['goalsSummary']?['fr'], isAr: false, maxLines: 3),
        ],
        tabKey: 'goals',
      ),
      const SizedBox(height: 20),
      _sectionLabel('اللون المميز', Icons.palette_rounded),
      _buildTextField('لون (Hex code مثال: 1A6B3A)', 'color', _data['color'], isAr: false),
    ];
  }

  List<Widget> _leaderFields() {
    return [
      _sectionLabel('الصورة الشخصية', Icons.person_rounded),
      _imagePreviewField('photoUrl', 'رابط الصورة الشخصية (URL)', _data['photoUrl'], isCircle: true),
      const SizedBox(height: 20),
      _sectionLabel('الاسم الكامل', Icons.badge_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('الاسم (عربي) *', 'name.ar', _data['name']?['ar'], required: true, isAr: true),
          _buildTextField('Name (English)', 'name.en', _data['name']?['en'], isAr: false),
          _buildTextField('Nom (Français)', 'name.fr', _data['name']?['fr'], isAr: false),
        ],
      ),
      const SizedBox(height: 20),
      _sectionLabel('المنصب الوظيفي', Icons.work_rounded),
      _buildLangTabs(
        fields: [
          _buildTextField('المنصب (عربي) *', 'role.ar', _data['role']?['ar'], required: true, isAr: true),
          _buildTextField('Role (English)', 'role.en', _data['role']?['en'], isAr: false),
          _buildTextField('Rôle (Français)', 'role.fr', _data['role']?['fr'], isAr: false),
        ],
        tabKey: 'role',
      ),
    ];
  }

  Widget _sectionLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.accentColor),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }

  Widget _imagePreviewField(String key, String label, String? initialUrl, {bool isCircle = false}) {
    final ctrl = TextEditingController(text: initialUrl ?? '');
    bool isUploading = false;

    return StatefulBuilder(
      builder: (context, setS) {
        final preview = ctrl.text.trim();

        Future<void> _pickAndUpload() async {
          try {
            final result = await FilePicker.pickFiles(
              type: FileType.image,
              withData: true,
              allowMultiple: false,
            );
            if (result == null || result.files.isEmpty) return;
            final file = result.files.first;
            if (file.bytes == null) return;

            setS(() => isUploading = true);
            if (kDebugMode) print('[IMAGE PICKER] Starting upload for child file: ${file.name}');
            
            final uploadedUrl = await ref.read(mediaServiceProvider).uploadMedia(
              file.bytes!,
              file.name,
            );
            
            if (kDebugMode) print('[IMAGE PICKER] Upload success: $uploadedUrl');
            ctrl.text = uploadedUrl;
            _updateData(key, uploadedUrl);
            setS(() => isUploading = false);
          } catch (e) {
            if (kDebugMode) print('[IMAGE PICKER] ERROR: $e');
            setS(() => isUploading = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('خطأ في رفع الصورة: $e', style: GoogleFonts.tajawal()),
                backgroundColor: Colors.red.shade700,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(label: 'حسناً', textColor: Colors.white, onPressed: () {}),
              ));
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Live Preview Box ──────────────────────────────────
            Container(
              height: isCircle ? 120 : 140,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              clipBehavior: Clip.antiAlias,
              child: isUploading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: AppTheme.accentColor, strokeWidth: 3),
                          const SizedBox(height: 10),
                          Text('جاري رفع الصورة...', style: GoogleFonts.tajawal(color: AppTheme.primaryColor, fontSize: 12)),
                        ],
                      ),
                    )
                  : preview.isEmpty
                      ? GestureDetector(
                          onTap: _pickAndUpload,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCircle ? Icons.person_add_alt_1_rounded : Icons.add_photo_alternate_rounded,
                                  size: 28, color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('اضغط لاختيار صورة من جهازك', style: GoogleFonts.tajawal(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                              Text('يدعم JPG ، PNG ، WEBP', style: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 10)),
                            ],
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            isCircle
                                ? Center(
                                    child: CircleAvatar(
                                      radius: 48,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: CachedNetworkImageProvider(preview),
                                      onBackgroundImageError: (_, __) {},
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: preview,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorWidget: (_, __, ___) => Center(
                                      child: Icon(Icons.broken_image_rounded, size: 36, color: Colors.red.shade300),
                                    ),
                                    placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                            // Overlay "تغيير" button
                            Positioned(
                              bottom: 8, right: 8,
                              child: GestureDetector(
                                onTap: _pickAndUpload,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text('تغيير', style: GoogleFonts.tajawal(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
            // ── Upload Button ────────────────────────────────────
            OutlinedButton.icon(
              onPressed: isUploading ? null : _pickAndUpload,
              icon: const Icon(Icons.folder_open_rounded, size: 18),
              label: Text('اختيار من الجهاز', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
            const SizedBox(height: 8),
            // ── Fallback URL field ────────────────────────────────
            TextFormField(
              controller: ctrl,
              textDirection: TextDirection.ltr,
              style: GoogleFonts.tajawal(color: const Color(0xFF1A1A2E), fontSize: 13),
              decoration: InputDecoration(
                labelText: 'أو أدخل رابط URL مباشرةً',
                labelStyle: GoogleFonts.tajawal(color: const Color(0xFF94A3B8), fontSize: 12),
                prefixIcon: Icon(Icons.link_rounded, color: Colors.grey.shade400, size: 18),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (val) => setS(() {}),
              onSaved: (val) => _updateData(key, ctrl.text.trim()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLangTabs({required List<Widget> fields, String tabKey = 'main'}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(child: _LangTabBtn(label: 'العربية 🇩🇿', selected: _langTab.index == 0, onTap: () => setState(() => _langTab.index = 0))),
                Expanded(child: _LangTabBtn(label: 'English 🇬🇧', selected: _langTab.index == 1, onTap: () => setState(() => _langTab.index = 1))),
                Expanded(child: _LangTabBtn(label: 'Français 🇫🇷', selected: _langTab.index == 2, onTap: () => setState(() => _langTab.index = 2))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: IndexedStack(index: _langTab.index, children: fields),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key, String? initial, {bool required = false, bool isAr = true, int maxLines = 1}) {
    return TextFormField(
      initialValue: initial ?? '',
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      style: GoogleFonts.tajawal(color: const Color(0xFF1A1A2E), fontSize: 14),
      onSaved: (val) => _updateData(key, val?.trim() ?? ''),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.tajawal(color: const Color(0xFF64748B), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null : null,
    );
  }
}

class _LangTabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangTabBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
