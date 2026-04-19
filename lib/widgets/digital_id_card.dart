import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebzim_app/core/services/user_profile_service.dart';
import 'package:ebzim_app/core/localization/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalIdCard extends StatelessWidget {
  final UserProfile user;

  const DigitalIdCard({super.key, required this.user});

  // Production Card Palette
  static const Color ivory = Color(0xFFFDFCF8);
  static const Color emerald = Color(0xFF066B4E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color slateBlack = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: ivory,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: emerald, width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ── Background Institutional Pattern ──
            Positioned(
              left: -40,
              bottom: -40,
              child: Opacity(
                opacity: 0.03,
                child: Icon(Icons.workspace_premium, size: 240, color: emerald),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // ── Header Zone ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'EBZIM - جمعية إبزيم للثقافة والمواطنة',
                        style: GoogleFonts.tajawal(
                          color: gold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Official Logo Placeholder (using Icon for now, assuming asset exists)
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.workspace_premium, color: emerald, size: 32),
                        const SizedBox(height: 2),
                        Text(
                          'EBZIM',
                          style: GoogleFonts.inter(
                            color: slateBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Membership Card Label
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          '${loc.cardTitle} / MEMBERSHIP CARD',
                          style: GoogleFonts.cairo(
                            color: gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        if (user.membershipLevel.toUpperCase() == 'SUPER_ADMIN' || user.membershipLevel.toUpperCase() == 'ADMIN')
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              color: user.membershipLevel.toUpperCase() == 'SUPER_ADMIN' ? Colors.black : emerald,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.membershipLevel.toUpperCase() == 'SUPER_ADMIN' ? 'SUPER ADMIN (OWNER)' : 'ASSOCIATION ADMIN',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // ── Data Zone ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Photo Area
                      Container(
                        width: 60,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: gold, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: user.imageUrl.isNotEmpty 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(2.5),
                              child: Image.network(user.imageUrl, fit: BoxFit.cover),
                            )
                          : Center(child: Icon(Icons.person, color: gold.withOpacity(0.5))),
                      ),
                      const SizedBox(width: 16),
                      
                      // Member Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardField(
                              loc.cardFullName, 
                              user.getName(Localizations.localeOf(context).languageCode),
                              isAr
                            ),
                            const SizedBox(height: 6),
                            _buildCardField(
                              loc.cardMemberId, 
                              'ID-${user.id.substring(user.id.length - 6).toUpperCase()}',
                              isAr
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildCardField(
                                    loc.cardIssueDate, 
                                    '10/04/2026', // Placeholder for now
                                    isAr
                                  ),
                                ),
                                Expanded(
                                  child: _buildCardField(
                                    loc.cardExpiryDate, 
                                    user.membershipExpiry != null 
                                      ? '${user.membershipExpiry!.day.toString().padLeft(2, '0')}/${user.membershipExpiry!.month.toString().padLeft(2, '0')}/${user.membershipExpiry!.year}'
                                      : '31/12/2026',
                                    isAr
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // QR Area
                      Column(
                        children: [
                          Text(
                            loc.cardScanMe,
                            style: GoogleFonts.cairo(fontSize: 6, fontWeight: FontWeight.bold, color: emerald),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: emerald, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.qr_code_2, size: 40, color: slateBlack),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildCardField(String label, String value, bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.cairo(
            fontSize: 6.5,
            fontWeight: FontWeight.bold,
            color: emerald.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: slateBlack,
          ),
        ),
      ],
    );
  }
}
