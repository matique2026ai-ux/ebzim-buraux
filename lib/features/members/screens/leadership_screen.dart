import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../services/member_service.dart';
import '../../../core/common_widgets/ebzim_app_bar.dart';
import '../../../main.dart' show localeProvider;

class LeadershipScreen extends ConsumerWidget {
  const LeadershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';
    final leadersAsync = ref.watch(leadershipProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: EbzimAppBar(
        leading: IconButton(
          icon: Icon(isRtl ? Icons.arrow_forward : Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.leadHeroBadge.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2, color: AppTheme.secondaryColor)),
                  const SizedBox(height: 12),
                  Text(loc.leadHeroTitle, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 12),
                  Text(loc.leadHeroSub, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: AppTheme.textDark.withValues(alpha: 0.8))),
                  const SizedBox(height: 32),
                  // Search and Filter
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: loc.leadSearchHint,
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildChip(loc.leadCatAll, true),
                        _buildChip(loc.leadCatBoard, false),
                        _buildChip(loc.leadCatExec, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          leadersAsync.when(
            data: (members) {
              final executive = members.firstWhere((m) => m.isExecutive, orElse: () => members.first);
              final board = members.where((m) => !m.isExecutive).toList();

              return SliverList(
                delegate: SliverChildListDelegate([
                  // Executive Spotlight
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _SpotlightMemberCard(member: executive),
                  ),
                  const SizedBox(height: 32),
                  
                  // Board Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Text(loc.leadCatBoard, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        const SizedBox(width: 16),
                        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Board Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: board.length,
                      itemBuilder: (context, index) {
                        return _BoardMemberCard(member: board[index]);
                      },
                    ),
                  ),
                  
                  // Join Advisory CTA
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        Text(loc.leadJoinTitle, textAlign: TextAlign.center, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        const SizedBox(height: 16),
                        Text(loc.leadJoinSub, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppTheme.textDark.withValues(alpha: 0.7))),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () => context.push('/membership/apply'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primaryColor),
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                          ),
                          child: Text(loc.leadJoinBtn.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ]),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverFillRemaining(child: Center(child: Text(e.toString()))),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textDark,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SpotlightMemberCard extends StatelessWidget {
  final Member member;
  const _SpotlightMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final name = member.getName(lang);
    final role = member.getRole(lang);
    final bio = member.getBio(lang);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(member.imageUrl, height: 350, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text(member.category.toUpperCase(), style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.secondaryColor)),
                ),
                const SizedBox(height: 16),
                Text(name, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(height: 8),
                Text(role, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16), // Padding for both sides
                  decoration: BoxDecoration(
                    border: Border(
                      left: lang == 'ar' ? BorderSide.none : const BorderSide(color: AppTheme.secondaryColor, width: 2),
                      right: lang == 'ar' ? const BorderSide(color: AppTheme.secondaryColor, width: 2) : BorderSide.none,
                    ),
                  ),
                  child: Text('"$bio"', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: AppTheme.textDark.withValues(alpha: 0.8))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BoardMemberCard extends StatelessWidget {
  final Member member;
  const _BoardMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final name = member.getName(lang);
    final role = member.getRole(lang);
    final bio = member.getBio(lang);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(member.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(height: 4),
                Text(role.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppTheme.secondaryColor)),
                const SizedBox(height: 8),
                Text(bio, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: AppTheme.textDark.withValues(alpha: 0.6))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
