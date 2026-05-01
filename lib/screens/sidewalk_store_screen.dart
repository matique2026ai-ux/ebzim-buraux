import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/theme/app_theme.dart';
import 'package:ebzim_app/core/common_widgets/ebzim_logo.dart';
import 'package:ebzim_app/core/widgets/ebzim_background.dart';
import 'package:ebzim_app/core/services/marketplace_service.dart';
import 'package:ebzim_app/core/models/market_book.dart';
import 'dart:ui';

class SidewalkStoreScreen extends ConsumerStatefulWidget {
  const SidewalkStoreScreen({super.key});

  @override
  ConsumerState<SidewalkStoreScreen> createState() => _SidewalkStoreScreenState();
}

class _SidewalkStoreScreenState extends ConsumerState<SidewalkStoreScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _selectedCondition = 'ALL';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(allMarketBooksProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: EbzimBackground(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildAppBar(),
            _buildStoreHeader(),
          ],
          body: booksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.accentColor)),
            error: (err, _) => Center(child: Text('حدث خطأ: $err', style: const TextStyle(color: Colors.red))),
            data: (books) {
              final filteredBooks = books.where((b) {
                if (!b.isAvailable) return false;
                if (_selectedCondition == 'ALL') return true;
                return b.condition == _selectedCondition;
              }).toList();

              if (filteredBooks.isEmpty) {
                return _buildEmptyState();
              }
              return _buildBookGrid(filteredBooks);
            },
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: _isScrolled ? const Color(0xFF2C1E16).withOpacity(0.95) : Colors.transparent,
      elevation: _isScrolled ? 8 : 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => context.go('/library'),
      ).animate().fadeIn(),
      centerTitle: true,
      title: _isScrolled
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_rounded, color: AppTheme.accentColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'كتب الرصيف',
                  style: GoogleFonts.rakkas(color: Colors.white, fontSize: 24),
                ),
              ],
            ).animate().fadeIn()
          : const EbzimLogo().animate().fadeIn(),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildStoreHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const Icon(Icons.storefront_rounded, size: 64, color: AppTheme.accentColor)
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              'كتب الرصيف',
              style: GoogleFonts.rakkas(
                fontSize: 48,
                color: Colors.white,
                shadows: [
                  Shadow(color: AppTheme.accentColor.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 4))
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 12),
            Text(
              'اكتشف كنوز المعرفة بأسعار في المتناول، كتب مستعملة وجديدة من أصدقاء المنصة.',
              textAlign: TextAlign.center,
              style: GoogleFonts.tajawal(
                fontSize: 18,
                color: Colors.white70,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 32),
            _buildFilterTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterChip('الكل', 'ALL'),
        const SizedBox(width: 12),
        _buildFilterChip('جديد', 'NEW'),
        const SizedBox(width: 12),
        _buildFilterChip('مستعمل', 'USED'),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedCondition == value;
    return InkWell(
      onTap: () => setState(() => _selectedCondition = value),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.white30,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.tajawal(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid(List<MarketBook> books) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _MarketBookCard(book: books[index])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 * (index % 10)))
                    .slideY(begin: 0.1, end: 0);
              },
              childCount: books.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.white30),
          const SizedBox(height: 16),
          Text(
            'لا توجد كتب متاحة حالياً بهذا التصنيف',
            style: GoogleFonts.tajawal(fontSize: 20, color: Colors.white54),
          ),
        ],
      ).animate().fadeIn(),
    );
  }
}

class _MarketBookCard extends StatelessWidget {
  final MarketBook book;

  const _MarketBookCard({required this.book});

  void _showBookDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MarketBookDetailsSheet(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBookDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2C1E16).withOpacity(0.8), // Wooden shelf feel
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: book.coverImage.isNotEmpty
                        ? Image.network(book.coverImage, fit: BoxFit.cover)
                        : Container(color: Colors.grey[800], child: const Icon(Icons.book, size: 64, color: Colors.white54)),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: book.condition == 'NEW' ? Colors.green.withOpacity(0.9) : Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        book.condition == 'NEW' ? 'جديد' : 'مستعمل',
                        style: GoogleFonts.tajawal(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.titleAr,
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: GoogleFonts.tajawal(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${book.price} د.ج',
                        style: GoogleFonts.tajawal(
                          color: AppTheme.accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white54, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketBookDetailsSheet extends StatelessWidget {
  final MarketBook book;

  const _MarketBookDetailsSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color(0xFF1E140F).withOpacity(0.9),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                book.coverImage,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: book.condition == 'NEW' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: book.condition == 'NEW' ? Colors.green : Colors.orange,
                                  ),
                                ),
                                child: Text(
                                  book.condition == 'NEW' ? 'حالة ممتازة / جديد' : 'مستعمل بحالة جيدة',
                                  style: GoogleFonts.tajawal(
                                    color: book.condition == 'NEW' ? Colors.greenAccent : Colors.orangeAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${book.price} د.ج',
                                style: GoogleFonts.tajawal(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 24),
                          Text(
                            book.titleAr,
                            style: GoogleFonts.tajawal(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                          const SizedBox(height: 8),
                          Text(
                            'المؤلف: ${book.author}',
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                          const SizedBox(height: 32),
                          Text(
                            'وصف الكتاب',
                            style: GoogleFonts.tajawal(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentColor,
                            ),
                          ).animate().fadeIn(delay: 500.ms),
                          const SizedBox(height: 16),
                          Text(
                            book.descriptionAr,
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.8,
                            ),
                          ).animate().fadeIn(delay: 600.ms),
                          const SizedBox(height: 32),
                          _buildContactSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_rounded, color: AppTheme.accentColor),
              const SizedBox(width: 12),
              Text(
                'سعر التوصيل: ${book.deliveryCost > 0 ? '${book.deliveryCost} د.ج' : 'مجاني'}',
                style: GoogleFonts.tajawal(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white12),
          ),
          Text(
            'لشراء هذا الكتاب، يرجى التواصل مع البائع مباشرة عبر الرابط أو الرقم أدناه:',
            style: GoogleFonts.tajawal(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Here we would use url_launcher to open WhatsApp or phone dialer
              },
              icon: const Icon(Icons.chat_rounded, color: Colors.white),
              label: Text(
                book.contactInfo,
                style: GoogleFonts.tajawal(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0);
  }
}
