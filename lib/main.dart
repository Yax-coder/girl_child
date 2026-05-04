import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/pure_white_theme.dart';
import 'core/network/hausa_repository.dart';
import 'core/audio/audio_service.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/onboarding/screens/diagnostic_voice_screen.dart';

void main() {
  runApp(const TarbiyaApp());
}

class TarbiyaApp extends StatelessWidget {
  const TarbiyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => HausaRepository()),
        Provider(create: (_) => AudioService()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp(
        title: 'Tarbiya',
        theme: PureWhiteTheme.light,
        home: const DiagnosticVoiceScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
