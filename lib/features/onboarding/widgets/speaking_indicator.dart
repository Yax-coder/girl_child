import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SpeakingIndicator extends StatefulWidget {
  final ValueNotifier<bool> isSpeaking;

  const SpeakingIndicator({super.key, required this.isSpeaking});

  @override
  State<SpeakingIndicator> createState() => _SpeakingIndicatorState();
}

class _SpeakingIndicatorState extends State<SpeakingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isSpeaking,
      builder: (context, speaking, child) {
        if (!speaking) return const SizedBox.shrink();
        
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.sunsetOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(3, (index) {
                    final height = 10 + (index * 4) + (8 * _controller.value);
                    return Container(
                      width: 4,
                      height: index == 1 ? height : height * 0.7,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.sunsetOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  const Text(
                    "Speaking...",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.sunsetOrange,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
