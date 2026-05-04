import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/pure_white_theme.dart';

class PlacementComputingStep extends StatefulWidget {
  const PlacementComputingStep({super.key});

  @override
  State<PlacementComputingStep> createState() => _PlacementComputingStepState();
}

class _PlacementComputingStepState extends State<PlacementComputingStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PureWhiteTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Premium Animated Loader with Jidda
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Orbiting Particle 1
                        Transform.rotate(
                          angle: _controller.value * 2 * math.pi,
                          child: Transform.translate(
                            offset: const Offset(100, 0),
                            child: _buildParticle(const Color(0xFF4EE6B3)),
                          ),
                        ),
                        // Orbiting Particle 2
                        Transform.rotate(
                          angle: (_controller.value * 2 * math.pi) + math.pi,
                          child: Transform.translate(
                            offset: const Offset(100, 0),
                            child: _buildParticle(const Color(0xFFB34EE6)),
                          ),
                        ),
                        
                        // Outer Pulsing Ring
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.1),
                              width: 2,
                            ),
                          ),
                        ),
                        
                        // Main Glow
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.15),
                                blurRadius: 40 + (math.sin(_controller.value * 2 * math.pi) * 10),
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        
                        // Jidda Avatar
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
                      ],
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 64),
              
              // Hausa Text
              Text(
                "Ina duba inda za mu fara...",
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: PureWhiteTheme.deepIndigo,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // English Subtitle
              Text(
                "Discovering the perfect path for your magical learning journey.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Subtle Progress Line
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  width: 120,
                  height: 4,
                  child: LinearProgressIndicator(
                    backgroundColor: PureWhiteTheme.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(PureWhiteTheme.deepIndigo),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
