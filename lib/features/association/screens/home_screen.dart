import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../events/services/event_service.dart';
import '../../events/widgets/event_card.dart';
import '../widgets/section_header.dart';
import '../../../main.dart'; 
import '../../../core/common_widgets/ebzim_sliver_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // AppBar
          EbzimSliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.primaryColor),
              onPressed: () {},
            ),
            actions: [
              IconButton(icon: const Icon(Icons.account_circle, color: AppTheme.primaryColor), onPressed: () {}),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, const Color(0xFF004B3E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 80, color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(height: 24),
                  Text(
                    loc.homeWelcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.homeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryColor.withValues(alpha: 0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/membership/apply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: AppTheme.textDark,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(loc.homeActionJoin, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.go('/activities'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text(loc.homeActionExplore.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          // Events Horizontal List
          SliverToBoxAdapter(
            child: SectionHeader(
              title: loc.homeUpcomingEvents,
              trailing: Row(
                children: [
                   Icon(isRtl ? Icons.chevron_right : Icons.chevron_left, color: AppTheme.primaryColor),
                   Icon(isRtl ? Icons.chevron_left : Icons.chevron_right, color: AppTheme.primaryColor),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: eventsAsync.when(
                data: (events) => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                      event: event,
                      onTap: () => context.push('/event/${event.id}'),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text(e.toString())),
              ),
            ),
          ),

          // Pillars Section
          SliverToBoxAdapter(
            child: SectionHeader(title: loc.homePillars),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildPillarCard(
                    context, 
                    title: loc.homeWorkshopTitle, 
                    desc: loc.homeWorkshopDesc, 
                    img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC28xi6vqbiwTMG_3Tc_mN430N1U2EKOS13VVJ30lAizaiXYj1Tmq2nrZhziqQv6m1lgJhSDpSbulgBaJTS8UCeIzKUyDAVNjhGUFq6lZNZxzEQSb3pSezwnxsxM02OYhSFXF0saXKS9GxxoqMegGFZ6GL9UfonTmDGHvxxzuSQuPLjxS2NKzyQz4KOW856Be1SP-s3P6dVKZaJBew3A2Q2ljyNTlgbidA-j2fHWKP8-ZG9Mr-wJ6FOS1_6YbcNDIYSZ45zAMnsK3bF',
                  ),
                  const SizedBox(height: 24),
                  _buildPillarCard(
                    context, 
                    title: loc.homeHistoryTitle, 
                    desc: loc.homeHistoryDesc, 
                    img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAR5AwJO0Gf5JvrMhIE0lnLNUSS1L53oOos7Vt8xSwLV-DtGhuvYknVWkspfirkDms-Mn6nqTZTkMg-9q8pEcnWcrWBaGTYIYQwbJcn7riI-g3QBVIG59H57pa8N2hhg0CIc0zLyoUiLhYrea6t5ijEJenhMaorSLuKDdG_7XA-YPZCqwQvvFb65Jt7_CUVi8NB2C7dxdoCBJDeQnc2M__BvxJqCXeKYUymD1kPVbXw1VHGqTXGyT5KnrFfewhcHJdb2zWxdCr-rJFm',
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildPillarCard(BuildContext context, {required String title, required String desc, required String img}) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor.withValues(alpha: 0.9), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
