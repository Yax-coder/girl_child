import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/hausa_repository.dart';
import '../../../core/models/learning_models.dart';

// Events
abstract class OnboardingEvent {}
class IdentitySubmitted extends OnboardingEvent {
  final String name;
  IdentitySubmitted(this.name);
}
class AgeRangeSelected extends OnboardingEvent {
  final String ageRange;
  AgeRangeSelected(this.ageRange);
}
class MissionStarted extends OnboardingEvent {}

// State
class OnboardingState {
  final int step;
  final String? name;
  final String? ageRange;
  final bool isLoading;
  final String? error;
  final SessionStepResponse? firstLesson;

  OnboardingState({
    this.step = 0,
    this.name,
    this.ageRange,
    this.isLoading = false,
    this.error,
    this.firstLesson,
  });

  OnboardingState copyWith({
    int? step,
    String? name,
    String? ageRange,
    bool? isLoading,
    String? error,
    SessionStepResponse? firstLesson,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      name: name ?? this.name,
      ageRange: ageRange ?? this.ageRange,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      firstLesson: firstLesson ?? this.firstLesson,
    );
  }
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final HausaRepository _repository;

  OnboardingBloc(this._repository) : super(OnboardingState()) {
    on<IdentitySubmitted>((event, emit) {
      emit(state.copyWith(name: event.name, step: 1));
    });

    on<AgeRangeSelected>((event, emit) {
      emit(state.copyWith(ageRange: event.ageRange, step: 2));
    });

    on<MissionStarted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final learner = await _repository.registerLearner({
          'displayName': state.name,
          'ageRange': state.ageRange,
          // Defaults for speed-of-light onboarding
          'literacyLevel': 'EMERGING_READER',
          'learningGoal': 'READ_AND_UNDERSTAND',
        });

        // Auto-resolve proficiency and get first lesson
        final placement = await _repository.computePlacement(learner.id);
        final session = await _repository.startSession(learner.id, placement.lessonId);
        
        emit(state.copyWith(isLoading: false, firstLesson: session, step: 3));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
