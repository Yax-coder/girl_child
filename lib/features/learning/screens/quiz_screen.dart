import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../onboarding/screens/progress_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedIndex;
  bool _showFeedback = false;

  final List<String> _options = [
    "A bright star",
    "A talking cat",
    "A magical book",
    "A swift bird"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      appBar: AppBar(
        title: Text(
          "Mini Puzzle",
          style: GoogleFonts.outfit(color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: PureWhiteTheme.deepIndigo),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Area
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFF0F0F0)),
                        boxShadow: [
                          BoxShadow(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(LucideIcons.helpCircle, color: PureWhiteTheme.deepIndigo, size: 48),
                          const SizedBox(height: 24),
                          Text(
                            "What was the first thing the sun turned into in our story?",
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: PureWhiteTheme.deepIndigo,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Options List
                    ...List.generate(_options.length, (index) {
                      final isSelected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                              _showFeedback = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                            decoration: BoxDecoration(
                              color: isSelected ? PureWhiteTheme.deepIndigo : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? PureWhiteTheme.deepIndigo : const Color(0xFFF0F0F0),
                                width: 2,
                              ),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32, height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isSelected ? Colors.white : PureWhiteTheme.divider, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : PureWhiteTheme.deepIndigo),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    _options[index],
                                    style: GoogleFonts.inter(
                                      color: isSelected ? Colors.white : PureWhiteTheme.deepIndigo,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Feedback area
            if (_showFeedback)
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 48, top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.sparkles, color: Color(0xFFFFD700), size: 24),
                          const SizedBox(width: 12),
                          Text(
                            "Amazing Choice!",
                            style: GoogleFonts.outfit(color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const ProgressScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: PureWhiteTheme.deepIndigo, padding: const EdgeInsets.symmetric(vertical: 20)),
                          child: Text("Gama Wannan", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
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
