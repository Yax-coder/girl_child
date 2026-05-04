import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../../core/models/learning_models.dart';
import '../providers/session_provider.dart';

class LessonPlayerScreen extends StatelessWidget {
  final String lessonId;
  const LessonPlayerScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionProvider()..startLesson(lessonId),
      child: const _LessonPlayerView(),
    );
  }
}

class _LessonPlayerView extends StatefulWidget {
  const _LessonPlayerView();

  @override
  State<_LessonPlayerView> createState() => _LessonPlayerViewState();
}

class _LessonPlayerViewState extends State<_LessonPlayerView> with SingleTickerProviderStateMixin {
  final TextEditingController _reflectionController = TextEditingController();
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final step = provider.currentStepResponse;

    if (provider.error != null) {
      return Scaffold(
        backgroundColor: PureWhiteTheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.alertTriangle, color: Colors.red, size: 64),
                const SizedBox(height: 24),
                Text(
                  "An samu matsala", // Error occurred
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: PureWhiteTheme.deepIndigo),
                ),
                Text(provider.error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Koma Baya"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (step == null || provider.isLoading) {
      return Scaffold(
        backgroundColor: PureWhiteTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: PureWhiteTheme.deepIndigo),
              const SizedBox(height: 24),
              Text("Magic is happening...", style: GoogleFonts.outfit(color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      appBar: AppBar(
        title: Text(
          "Tarbiya Classroom",
          style: GoogleFonts.outfit(color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: PureWhiteTheme.deepIndigo),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildJiddaAvatar(),
                  const SizedBox(height: 40),
                  _buildContentCard(context, step),
                  
                  if (step.currentStep == "QUIZ") ...[
                    const SizedBox(height: 32),
                    _buildQuizOptions(context, provider, step.stepContent),
                  ],
                  
                  if (step.currentStep == "REFLECTION") ...[
                    const SizedBox(height: 32),
                    _buildReflectionInput(context),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomAction(context, provider, step),
        ],
      ),
    );
  }

  Widget _buildJiddaAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.1), blurRadius: 30, spreadRadius: 5)],
          ),
        ),
        ClipOval(
          child: SizedBox(width: 100, height: 100, child: Image.asset('assets/images/jidda_avatar.png', fit: BoxFit.cover)),
        ),
        // Active Speaking Indicator
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Container(
                      width: 4, height: 8 + (_waveController.value * 12 * (index == 1 ? 1 : 0.5)),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: PureWhiteTheme.deepIndigo, borderRadius: BorderRadius.circular(2)),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(BuildContext context, SessionStepResponse step) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [BoxShadow(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text(
            _getTitleForStep(step),
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: PureWhiteTheme.deepIndigo),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            _getBodyForStep(step),
            style: GoogleFonts.inter(fontSize: 18, height: 1.6, color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizOptions(BuildContext context, SessionProvider provider, StepContent content) {
    if (content.options == null) return const SizedBox.shrink();
    return Column(
      children: List.generate(content.options!.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => provider.submitStep(data: {'answerIndex': index}),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF0F0F0))),
              child: Row(
                children: [
                   Container(
                    width: 32, height: 32,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Center(child: Text(String.fromCharCode(65 + index), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: PureWhiteTheme.deepIndigo))),
                  ),
                  const SizedBox(width: 20),
                  Expanded(child: Text(content.options![index], style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: PureWhiteTheme.deepIndigo))),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReflectionInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _reflectionController,
        maxLines: 3,
        style: GoogleFonts.inter(color: PureWhiteTheme.deepIndigo),
        decoration: InputDecoration(
          hintText: "Rubuta tunanin ki...",
          hintStyle: GoogleFonts.inter(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, SessionProvider provider, SessionStepResponse step) {
    if (step.currentStep == "QUIZ") return const SizedBox.shrink();
    final isFinal = step.isComplete || step.currentStep == "COMPLETE" || step.currentStep == "OUTRO";

    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 40, top: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (isFinal) {
              Navigator.of(context).pop();
            } else if (step.currentStep == "REFLECTION") {
              provider.submitStep(data: {'reflectionText': _reflectionController.text});
            } else {
              provider.submitStep();
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: PureWhiteTheme.deepIndigo, padding: const EdgeInsets.symmetric(vertical: 20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isFinal ? "Gama Wannan" : "Ci gaba", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(width: 8),
              Icon(isFinal ? LucideIcons.check : LucideIcons.arrowRight, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitleForStep(SessionStepResponse step) {
    final content = step.stepContent;
    switch (step.currentStep) {
      case "INTRO": return content.lessonTitle ?? "Sannu!";
      case "CONTENT": return "Darasi";
      case "PRACTICE": return "Gwaji";
      case "QUIZ": return "Tambaya";
      case "REFLECTION": return "Tunanin Ki";
      default: return "Masha'Allah!";
    }
  }

  String _getBodyForStep(SessionStepResponse step) {
    final content = step.stepContent;
    switch (step.currentStep) {
      case "INTRO": return content.hook ?? "";
      case "CONTENT": return "${content.simpleExplanation ?? ""}\n\n${content.localExample ?? ""}";
      case "PRACTICE": return content.guidedPractice ?? "";
      case "QUIZ": return content.question ?? "";
      case "REFLECTION": return content.reflectionPrompt ?? "Me kika koya yau?";
      default: return content.completionMessage ?? "Kin gama wannan darasin!";
    }
  }
}
