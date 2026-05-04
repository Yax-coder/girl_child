import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/hausa_repository.dart';
import '../../../core/models/learning_models.dart';
import '../../../core/audio/audio_service.dart';

// Events
abstract class SessionEvent {}
class SessionStarted extends SessionEvent {
  final SessionStepResponse initialSession;
  SessionStarted(this.initialSession);
}
class StepSubmitted extends SessionEvent {
  final dynamic data;
  StepSubmitted({this.data});
}

// State
class SessionState {
  final SessionStepResponse? currentStep;
  final bool isLoading;
  final String? error;

  SessionState({
    this.currentStep,
    this.isLoading = false,
    this.error,
  });

  SessionState copyWith({
    SessionStepResponse? currentStep,
    bool? isLoading,
    String? error,
  }) {
    return SessionState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final HausaRepository _repository;
  final AudioService _audioService;

  SessionBloc(this._repository, this._audioService) : super(SessionState()) {
    on<SessionStarted>((event, emit) {
      emit(state.copyWith(currentStep: event.initialSession));
      _speakCurrentStep(event.initialSession);
    });

    on<StepSubmitted>((event, emit) async {
      if (state.currentStep == null) return;
      
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final nextStep = await _repository.submitStep(
          state.currentStep!.sessionId,
          state.currentStep!.currentStep,
          data: event.data,
        );
        emit(state.copyWith(isLoading: false, currentStep: nextStep));
        _speakCurrentStep(nextStep);
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }

  void _speakCurrentStep(SessionStepResponse step) {
    final content = step.stepContent;
    final stage = step.currentStep;

    if (stage == "INTRO" && content.hookVoiceUrl != null) {
      _audioService.speakUrl(content.hookVoiceUrl!);
    } else if (stage == "CONTENT" && content.explanationVoiceUrl != null) {
      _audioService.speakUrl(content.explanationVoiceUrl!);
    } else if (stage == "PRACTICE" && content.practiceVoiceUrl != null) {
      _audioService.speakUrl(content.practiceVoiceUrl!);
    } else if (stage == "QUIZ" && content.questionVoiceUrl != null) {
      _audioService.speakUrl(content.questionVoiceUrl!);
    } else if (stage == "REFLECTION" && content.recapVoiceUrl != null) {
      _audioService.speakUrl(content.recapVoiceUrl!);
    }
  }
}
