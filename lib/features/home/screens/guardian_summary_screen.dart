import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/pure_white_theme.dart';

class GuardianSummaryScreen extends StatelessWidget {
  const GuardianSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: PureWhiteTheme.deepIndigo),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Parent Portal",
          style: GoogleFonts.outfit(
            color: PureWhiteTheme.deepIndigo,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Parent
              Text(
                "Nurturing Growth",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: PureWhiteTheme.deepIndigo,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "See how your child is flourishing in her learning magic.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 48),

              // Summary Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildStatCard("35m", "Total Time", LucideIcons.timer),
                  _buildStatCard("12", "Stars Won", LucideIcons.star),
                  _buildStatCard("Lv 1", "Path Stage", LucideIcons.map),
                  _buildStatCard("85%", "Accuracy", LucideIcons.checkCircle2),
                ],
              ),

              const SizedBox(height: 48),

              // Settings / Path
              Text(
                "Path Settings",
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PureWhiteTheme.deepIndigo,
                ),
              ),
              const SizedBox(height: 20),
              _buildSettingsTile(
                "Learning Path",
                "Reading & Understanding",
                LucideIcons.bookOpen,
              ),
              _buildSettingsTile(
                "Language Pref",
                "Hausa & English Mix",
                LucideIcons.languages,
              ),
              _buildSettingsTile(
                "Daily Goal",
                "15 minutes / day",
                LucideIcons.target,
              ),

              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8F9FE),
                    foregroundColor: PureWhiteTheme.deepIndigo,
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFF0F0F0)),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.share, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Export Progress Report",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String val, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: PureWhiteTheme.deepIndigo, size: 24),
          const SizedBox(height: 12),
          Text(
            val,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: PureWhiteTheme.deepIndigo, size: 18),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: PureWhiteTheme.deepIndigo,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: PureWhiteTheme.divider, size: 18),
        ],
      ),
    );
  }
}
