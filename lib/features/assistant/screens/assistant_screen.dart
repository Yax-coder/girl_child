import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/services/api_service.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final VoiceService _voiceService = VoiceService();
  final ApiService _apiService = ApiService();
  final TextEditingController _textController = TextEditingController();
  
  bool _isListening = false;
  bool _isProcessing = false;
  String _transcript = "I'm Jidda, your learning companion. How can I help you today, Gimbiya?";
  String? _learnerId;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _loadLearnerId();
  }

  Future<void> _loadLearnerId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _learnerId = prefs.getString('learnerId');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _voiceService.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
        _isProcessing = true;
        _pulseController.stop();
      });

      await _voiceService.stopListening();
      
      // The transcription is already updated in _currentTranscription if we used a listener,
      // but here we wait for the final text from VoiceService if needed, or use the lastWords notifier.
      final text = _voiceService.lastWords.value;
      if (text.isNotEmpty) {
        _processInput(text);
      } else {
        setState(() {
          _isProcessing = false;
          _transcript = "Gafara, ban ji ki ba. Za ki iya sake fada?";
        });
      }
    } else {
      setState(() {
        _isListening = true;
        _pulseController.repeat();
        _transcript = "Ina sauraron ki..."; 
      });

      await _voiceService.startListening(onResult: (text) {
        setState(() {
          _transcript = text;
        });
      });
    }
  }

  void _handleTextSubmit() {
    if (_textController.text.isEmpty) return;
    
    final text = _textController.text;
    _textController.clear();
    _processInput(text);
  }

  Future<void> _processInput(String text) async {
    setState(() {
      _transcript = text;
      _isProcessing = true;
    });

    try {
      // Send text to backend AI Chat endpoint
      // We use learnerId as both sessionId and userId for persistence
      final responseText = await _apiService.aiChatMessage(
        _learnerId, 
        text, 
        userId: _learnerId
      );
      
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _transcript = responseText;
        });
        
        // Jidda speaks the response
        await _voiceService.speak(responseText);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _transcript = "An samu jinkiri gurin Jidda. Za ki iya gwada wani abun?";
        });
      }
    }
  }

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
          "Talk to Jidda",
          style: GoogleFonts.outfit(
            color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.bold, fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    _buildAvatar(),
                    const SizedBox(height: 48),
                    _buildTranscriptBox(),
                  ],
                ),
              ),
            ),

            // Input Area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isListening)
            ...List.generate(2, (index) {
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final progress = (_pulseController.value + (index * 0.5)) % 1.0;
                  return Transform.scale(
                    scale: 1.0 + (progress * 1.5),
                    child: Opacity(
                      opacity: 0.2 * (1.0 - progress),
                      child: Container(
                        width: 140, height: 140,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: PureWhiteTheme.deepIndigo),
                      ),
                    ),
                  );
                },
              );
            }),
          Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.1),
                  blurRadius: 40, spreadRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: ClipOval(child: Image.asset('assets/images/jidda_avatar.png', fit: BoxFit.cover)),
          ),
          if (_isProcessing)
             const SizedBox(width: 210, height: 210, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(PureWhiteTheme.deepIndigo))),
        ],
      ),
    );
  }

  Widget _buildTranscriptBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Text(
        _transcript,
        style: GoogleFonts.inter(
          color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.w500, fontSize: 18, height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text Input Fallback
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(32),
               border: Border.all(color: const Color(0xFFF0F0F0)),
               boxShadow: [
                 BoxShadow(
                   color: Colors.black.withValues(alpha: 0.02),
                   blurRadius: 10,
                   offset: const Offset(0, 4),
                 ),
               ],
             ),
             child: Row(
               children: [
                 Expanded(
                   child: TextField(
                     controller: _textController,
                     style: GoogleFonts.inter(color: PureWhiteTheme.deepIndigo),
                     decoration: InputDecoration(
                       hintText: "Rubuta tambayar ki...",
                       hintStyle: GoogleFonts.inter(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.3)),
                       border: InputBorder.none,
                     ),
                     onSubmitted: (_) => _handleTextSubmit(),
                   ),
                 ),
                 IconButton(
                    icon: const Icon(LucideIcons.send, color: PureWhiteTheme.deepIndigo, size: 20),
                    onPressed: _handleTextSubmit,
                 ),
               ],
             ),
          ),
          const SizedBox(height: 24),
          
          // Microphone Button
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isListening ? Colors.red.shade400 : PureWhiteTheme.deepIndigo,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : PureWhiteTheme.deepIndigo).withValues(alpha: 0.3),
                    blurRadius: 30, offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(_isListening ? LucideIcons.square : LucideIcons.mic, color: Colors.white, size: 36),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isListening ? "Fada abinda kike so..." : "Danna don yin magana",
            style: GoogleFonts.outfit(color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.4), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
