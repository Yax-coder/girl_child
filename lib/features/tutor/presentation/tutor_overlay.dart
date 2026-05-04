import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/network/hausa_repository.dart';
import '../bloc/tutor_bloc.dart';

class TutorOverlay extends StatelessWidget {
  const TutorOverlay({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Tutor",
      pageBuilder: (context, _, __) => const TutorOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorBloc(
        context.read<HausaRepository>(),
        context.read<AudioService>(),
      ),
      child: const _TutorOverlayView(),
    );
  }
}

class _TutorOverlayView extends StatefulWidget {
  const _TutorOverlayView();

  @override
  State<_TutorOverlayView> createState() => _TutorOverlayViewState();
}

class _TutorOverlayViewState extends State<_TutorOverlayView> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlurryContainer(
        blur: 20,
        width: double.infinity,
        height: double.infinity,
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.zero,
        child: BlocBuilder<TutorBloc, TutorState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(LucideIcons.x, color: PureWhiteTheme.deepIndigo),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Spacer(),
                _buildAvatar(context, state),
                const SizedBox(height: 32),
                if (state.isProcessing)
                  const Text("Amira tana tunani...", 
                    style: TextStyle(color: PureWhiteTheme.deepIndigo, fontWeight: FontWeight.bold)
                  )
                else if (state.responseText != null)
                  _buildResponseCard(context, state.responseText!)
                else
                  _buildInitialPrompt(context),
                const Spacer(),
                _buildMicButton(context, state),
                const SizedBox(height: 48),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, TutorState state) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.05),
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: PureWhiteTheme.divider),
            ),
            child: Icon(LucideIcons.sparkles, size: 60, color: PureWhiteTheme.tarbiyaGold),
          ),
        );
      },
    );
  }

  Widget _buildInitialPrompt(BuildContext context) {
    return Text(
      "Tambayi Amira komai...",
      style: Theme.of(context).textTheme.displaySmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildResponseCard(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PureWhiteTheme.borderRadius),
        border: Border.all(color: PureWhiteTheme.divider),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMicButton(BuildContext context, TutorState state) {
    return GestureDetector(
      onTap: () {
        // Logic for recording start/stop
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: PureWhiteTheme.deepIndigo,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: PureWhiteTheme.deepIndigo.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Icon(LucideIcons.mic, color: Colors.white, size: 32),
      ),
    );
  }
}
