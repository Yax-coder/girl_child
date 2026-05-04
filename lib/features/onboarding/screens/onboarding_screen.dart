import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/pure_white_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../../learning_session/screens/lesson_player_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(context.read()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state.step == 3 && state.firstLesson != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LessonPlayerScreen(
                    initialSession: state.firstLesson!,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildProgressIndicator(state.step),
                  const SizedBox(height: 48),
                  Expanded(
                    child: _buildStepContent(context, state),
                  ),
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.error != null)
                    Text(state.error!, style: const TextStyle(color: Colors.red)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int step) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: index <= step 
                ? PureWhiteTheme.deepIndigo 
                : PureWhiteTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(BuildContext context, OnboardingState state) {
    switch (state.step) {
      case 0:
        return _buildIdentityStep(context);
      case 1:
        return _buildAgeStep(context);
      default:
        return const Center(child: Text("Preparing your magic mission..."));
    }
  }

  Widget _buildIdentityStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ina kwana! \nWhat is your name?",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameController,
          autofocus: true,
          style: Theme.of(context).textTheme.headlineMedium,
          decoration: const InputDecoration(
            hintText: "Enter name",
            border: InputBorder.none,
          ),
          onSubmitted: (val) {
            if (val.isNotEmpty) {
              context.read<OnboardingBloc>().add(IdentitySubmitted(val));
            }
          },
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                context.read<OnboardingBloc>().add(IdentitySubmitted(_nameController.text));
              }
            },
            child: const Text("Next Step"),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeStep(BuildContext context) {
    final ages = [
      {'label': '8 - 12', 'val': 'AGE_8_12', 'icon': LucideIcons.baby},
      {'label': '13 - 17', 'val': 'AGE_13_17', 'icon': LucideIcons.smile},
      {'label': '18 +', 'val': 'AGE_18_PLUS', 'icon': LucideIcons.user},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How old are you?",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 32),
        ...ages.map((age) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              context.read<OnboardingBloc>().add(AgeRangeSelected(age['val'] as String));
              context.read<OnboardingBloc>().add(MissionStarted());
            },
            borderRadius: BorderRadius.circular(PureWhiteTheme.borderRadius),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: PureWhiteTheme.divider),
                borderRadius: BorderRadius.circular(PureWhiteTheme.borderRadius),
              ),
              child: Row(
                children: [
                  Icon(age['icon'] as IconData, color: PureWhiteTheme.deepIndigo),
                  const SizedBox(width: 16),
                  Text(
                    age['label'] as String,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Icon(LucideIcons.chevronRight, color: PureWhiteTheme.divider),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}
