import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/services/event_service.dart';
import 'package:ebzim_app/widgets/event_card.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_app_bar.dart';
import 'package:ebzim_app/core/providers/locale_provider.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final lang = ref.watch(localeProvider).languageCode;

    // Categories aligned with EBZIM's real activity domains
    final categories = [
      loc.actCatAll,
      loc.actCatWorkshops,
      loc.actCatEvents,
      loc.actCatCampaigns,
      loc.actCatYouth,
      'شراكات', // Partnerships (Museum, University)
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: EbzimAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.actTitle,
                  style: TextStyle(
                    fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.actSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                // ── Search ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: loc.actSearchHint,
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Category Chips ──
          SizedBox(
            height: 44,
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                final isPartnership = index == categories.length - 1;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isPartnership)
                          const Padding(
                            padding: EdgeInsetsDirectional.only(end: 4),
                            child: Icon(Icons.handshake, size: 12, color: AppTheme.primaryColor),
                          ),
                        Text(
                          categories[index].toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategoryIndex = index),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: AppTheme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.secondaryColor.withValues(alpha: 0.3) : Colors.transparent,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ── Events Grid ──
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                // Filter by search query
                final filtered = _searchQuery.isEmpty
                    ? events
                    : events.where((e) {
                        final title = e.getTitle(lang).toLowerCase();
                        return title.contains(_searchQuery.toLowerCase());
                      }).toList();

                if (filtered.isEmpty) {
                  return _EmptyState(isSearch: _searchQuery.isNotEmpty);
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return EventCard(
                      event: event,
                      width: double.infinity,
                      onTap: () => context.push('/event/${event.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                  strokeWidth: 2,
                ),
              ),
              error: (e, _) => _ErrorState(onRetry: () => ref.invalidate(upcomingEventsProvider)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State Widget ──
class _EmptyState extends StatelessWidget {
  final bool isSearch;
  const _EmptyState({this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearch ? Icons.search_off : Icons.event_busy,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isSearch ? 'لا توجد نتائج للبحث' : 'لا توجد أنشطة قريبة',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            isSearch ? 'جرّب كلمة مختلفة' : 'تابعنا للاطلاع على أنشطة جمعية إبزيم',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Error State Widget ──
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'تعذّر تحميل الأنشطة',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
