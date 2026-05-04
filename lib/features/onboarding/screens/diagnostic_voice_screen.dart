import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../providers/onboarding_provider.dart';
import '../../home/screens/home_screen.dart';

class DiagnosticVoiceScreen extends StatefulWidget {
  const DiagnosticVoiceScreen({super.key});

  @override
  State<DiagnosticVoiceScreen> createState() => _DiagnosticVoiceScreenState();
}

class _DiagnosticVoiceScreenState extends State<DiagnosticVoiceScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _waveController;
  bool _isRecording = false;
  String _currentTranscription = "";

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Auto-play Jidda's greeting on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingProvider>().playGreeting();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _handleMicTap(OnboardingProvider provider) async {
    if (_isRecording) {
      await provider.stopListening();
      setState(() => _isRecording = false);
    } else {
      await provider.startListening(onResult: (text) {
        setState(() {
          _currentTranscription = text;
          if (provider.stage == DiagnosticStage.intro) {
            _nameController.text = text;
            provider.setDisplayName(text);
          }
        });
      });
      setState(() {
        _isRecording = true;
        _currentTranscription = "Ina sauraron ki...";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    
    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildAvatar(provider),
                    const SizedBox(height: 48),
                    _buildTextContent(provider),
                    const SizedBox(height: 40),
                    _buildInputArea(provider),
                    const SizedBox(height: 48),
                    if (provider.stage == DiagnosticStage.questions || provider.stage == DiagnosticStage.intro)
                      _buildWaveform(provider),
                  ],
                ),
              ),
            ),
            _buildBottomAction(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(OnboardingProvider provider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: provider.stage == DiagnosticStage.computing 
                    ? Colors.purple.withValues(alpha: 0.2)
                    : PureWhiteTheme.deepIndigo.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF0F4FF)],
            ),
          ),
        ),
        ClipOval(
          child: SizedBox(
            width: 140,
            height: 140,
            child: Image.asset(
              'assets/images/jidda_avatar.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (provider.isLoading || provider.stage == DiagnosticStage.computing)
          const SizedBox(
            width: 154,
            height: 154,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(PureWhiteTheme.deepIndigo),
            ),
          ),
      ],
    );
  }

  Widget _buildTextContent(OnboardingProvider provider) {
    String title = "Suna na Jidda.\nKe meye sunanki?";
    String subtitle = "My name is Jidda. What is your name?";

    if (provider.stage == DiagnosticStage.questions) {
      final q = provider.questions[provider.currentQuestionIndex];
      title = q['text'] ?? "";
      subtitle = q['translation'] ?? "";
    } else if (provider.stage == DiagnosticStage.computing) {
      title = "Ina duba yadda\nzamu fara...";
      subtitle = "Discovering where we shall start...";
    } else if (provider.stage == DiagnosticStage.summary) {
      title = "Masha'Allah!";
      subtitle = provider.placement?.rationale ?? "Your learning path is ready.";
    }

    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: provider.stage == DiagnosticStage.summary ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: PureWhiteTheme.deepIndigo,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputArea(OnboardingProvider provider) {
    if (provider.stage == DiagnosticStage.intro) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.05), width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _nameController,
                onChanged: (val) => provider.setDisplayName(val),
                style: GoogleFonts.outfit(fontSize: 20, color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: "Rubuta sunanki anan...",
                  hintStyle: GoogleFonts.outfit(fontSize: 18, color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.3)),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            _buildCircleButton(
              icon: LucideIcons.arrowRight,
              onPressed: provider.isLoading ? () {} : () async {
                await provider.startDiagnosticFlow();
                if (provider.error != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.error!), backgroundColor: Colors.red),
                  );
                }
              },
            ),
          ],
        ),
      );
    }

    if (provider.stage == DiagnosticStage.questions) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          _currentTranscription.isEmpty ? "Danna mic don bamu amsa..." : _currentTranscription,
          style: GoogleFonts.inter(
            fontSize: 18,
            color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.7),
            fontStyle: _currentTranscription.isEmpty ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: PureWhiteTheme.deepIndigo,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildWaveform(OnboardingProvider provider) {
    return Center(
      child: SizedBox(
        height: 80,
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(7, (index) {
                double height = 20 + (_waveController.value * (10 * (index % 3 + 2)));
                if (!_isRecording && !provider.isSpeaking.value) height = 10;
                return Container(
                  width: 8,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: index % 2 == 0 
                        ? [const Color(0xFF4EE6B3), const Color(0xFF4EE6DF)]
                        : [const Color(0xFFB34EE6), const Color(0xFF6B4EE6)],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomAction(OnboardingProvider provider) {
    if (provider.stage == DiagnosticStage.intro) {
       return Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: _buildMicButton(() => _handleMicTap(provider)),
      );
    }

    if (provider.stage == DiagnosticStage.questions) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 40.0, left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMicButton(() => _handleMicTap(provider)),
            if (_currentTranscription.isNotEmpty && !_isRecording)
              ElevatedButton(
                onPressed: () {
                  provider.submitAnswer(_currentTranscription);
                  setState(() => _currentTranscription = "");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  backgroundColor: PureWhiteTheme.deepIndigo,
                ),
                child: const Text("Gaba (Next)"),
              ),
          ],
        ),
      );
    }

    if (provider.stage == DiagnosticStage.summary) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 40.0, left: 32, right: 32),
        child: SizedBox(
           width: double.infinity,
           child: ElevatedButton(
            onPressed: () {
               Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 24),
              backgroundColor: PureWhiteTheme.deepIndigo,
            ),
            child: const Text("Bari mu fara (Let's Begin)"),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMicButton(VoidCallback onTap) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(shape: BoxShape.circle, color: (_isRecording ? Colors.red : const Color(0xFF6B4EE6)).withValues(alpha: 0.1)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 84, height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isRecording ? [Colors.red, Colors.redAccent] : [const Color(0xFF6B4EE6), const Color(0xFF904EE6)],
              ),
              boxShadow: [BoxShadow(color: (_isRecording ? Colors.red : const Color(0xFF6B4EE6)).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Icon(_isRecording ? LucideIcons.square : LucideIcons.mic, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
