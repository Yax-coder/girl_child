import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/selection_card.dart';
import '../../home/screens/home_screen.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../../core/models/learning_models.dart';

class WhoIsLearningStep extends StatefulWidget {
  const WhoIsLearningStep({super.key});

  @override
  State<WhoIsLearningStep> createState() => _WhoIsLearningStepState();
}

class _WhoIsLearningStepState extends State<WhoIsLearningStep> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            "Wane ne yake koyo a yau?",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Who is learning today?",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          
          // Beautiful Text Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.05),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              controller: _nameController,
              style: GoogleFonts.outfit(
                fontSize: 20,
                color: PureWhiteTheme.deepIndigo,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Saka sunanki (e.g. Aisha)",
                hintStyle: GoogleFonts.outfit(
                  fontSize: 18,
                  color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
              ),
              onChanged: (val) => provider.payload.displayName = val,
            ),
          ),
          
          const SizedBox(height: 40),
          
          SelectionCard(
            title: "Ni kaina (Myself)",
            subtitle: "I am ready to learn!",
            icon: Icons.person_outline,
            isSelected: provider.payload.userType == "SELF",
            onTap: () => provider.setUserType("SELF"),
          ),
          const SizedBox(height: 12),
          SelectionCard(
            title: "Yarona (My Child)",
            subtitle: "I am setting this up for my child.",
            icon: Icons.child_care_outlined,
            isSelected: provider.payload.userType == "CHILD",
            onTap: () => provider.setUserType("CHILD"),
          ),
        ],
      ),
    );
  }
}

class AgeRangeStep extends StatelessWidget {
  const AgeRangeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            "Shekarun ku nawa?",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "How old are you?",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SelectionCard(
            title: "8 - 12 Years",
            icon: Icons.auto_awesome_outlined,
            isSelected: provider.payload.ageRange == AgeRange.AGE_8_12,
            onTap: () => provider.setAgeRange(AgeRange.AGE_8_12),
          ),
          SelectionCard(
            title: "13 - 17 Years",
            icon: Icons.celebration_outlined,
            isSelected: provider.payload.ageRange == AgeRange.AGE_13_17,
            onTap: () => provider.setAgeRange(AgeRange.AGE_13_17),
          ),
          SelectionCard(
            title: "18+ Years",
            icon: Icons.school_outlined,
            isSelected: provider.payload.ageRange == AgeRange.AGE_18_PLUS,
            onTap: () => provider.setAgeRange(AgeRange.AGE_18_PLUS),
          ),
        ],
      ),
    );
  }
}

class LiteracyStep extends StatelessWidget {
  const LiteracyStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            "Za ku iya karatu?",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Can you read?",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SelectionCard(
            title: "A'a tukuna (Not Yet)",
            subtitle: "I want to start from the sounds.",
            icon: Icons.hearing_outlined,
            isSelected: provider.payload.literacyLevel == LiteracyLevel.PRE_LITERATE,
            onTap: () => provider.setLiteracy(LiteracyLevel.PRE_LITERATE),
          ),
          SelectionCard(
            title: "Kadan (A Little)",
            subtitle: "I can read simple words.",
            icon: Icons.auto_stories_outlined,
            isSelected: provider.payload.literacyLevel == LiteracyLevel.EMERGING_READER,
            onTap: () => provider.setLiteracy(LiteracyLevel.EMERGING_READER),
          ),
          SelectionCard(
            title: "Na iya karatu (Yes)",
            subtitle: "I can read full stories.",
            icon: Icons.menu_book_outlined,
            isSelected: provider.payload.literacyLevel == LiteracyLevel.READER,
            onTap: () => provider.setLiteracy(LiteracyLevel.READER),
          ),
        ],
      ),
    );
  }
}

class ParentSettingsStep extends StatelessWidget {
  const ParentSettingsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            "Saitunan Iyaye",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Parent Settings",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SelectionCard(
            title: "Haske akan Karatu",
            subtitle: "Focus on Literacy",
            icon: Icons.spellcheck,
            isSelected: provider.payload.parentSettings?.preferredPath == "LITERACY",
            onTap: () => provider.setPreferredPath("LITERACY"),
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: SwitchListTile(
              title: Text(
                "Takaita karatun dare",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: PureWhiteTheme.deepIndigo,
                ),
              ),
              subtitle: const Text("Only allow learning during daytime (6 AM - 6 PM)."),
              value: provider.payload.parentSettings?.restrictions.contains("RESTRICT_NIGHT") ?? false,
              onChanged: (val) => provider.toggleRestriction("RESTRICT_NIGHT"),
              activeColor: PureWhiteTheme.deepIndigo,
            ),
          ),
          
          const Spacer(),
          ElevatedButton(
            onPressed: () => provider.saveParentSettings(),
            child: const Text("Gama Tsarin (Complete Setup)"),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PlacementSummaryStep extends StatelessWidget {
  const PlacementSummaryStep({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final rationale = provider.placement?.rationale ?? "An shirya muku darassin farko na ban mamaki.";
    
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Jidda Success Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F5E9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.asset(
                    'assets/images/jidda_avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: PureWhiteTheme.successGreen,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          
          Text(
            "An shirya komai!",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: PureWhiteTheme.deepIndigo,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Rationale Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Text(
              rationale,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PureWhiteTheme.deepIndigo,
                padding: const EdgeInsets.symmetric(vertical: 24),
              ),
              child: const Text("Bari mu fara (Let's Begin)"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
