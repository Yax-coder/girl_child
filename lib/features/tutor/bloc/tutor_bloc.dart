import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/hausa_repository.dart';
import '../../../core/audio/audio_service.dart';

// Events
abstract class TutorEvent {}
class UserSentenceRecorded extends TutorEvent {
  final String filePath;
  UserSentenceRecorded(this.filePath);
}
class ResetTutor extends TutorEvent {}

// State
class TutorState {
  final bool isRecording;
  final bool isProcessing;
  final String? transcript;
  final String? responseText;
  final String? error;

  TutorState({
    this.isRecording = false,
    this.isProcessing = false,
    this.transcript,
    this.responseText,
    this.error,
  });

  TutorState copyWith({
    bool? isRecording,
    bool? isProcessing,
    String? transcript,
    String? responseText,
    String? error,
  }) {
    return TutorState(
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      transcript: transcript ?? this.transcript,
      responseText: responseText ?? this.responseText,
      error: error ?? this.error,
    );
  }
}

class TutorBloc extends Bloc<TutorEvent, TutorState> {
  final HausaRepository _repository;
  final AudioService _audioService;

  TutorBloc(this._repository, this._audioService) : super(TutorState()) {
    on<UserSentenceRecorded>((event, emit) async {
      emit(state.copyWith(isProcessing: true, error: null));
      try {
        final text = await _repository.transcribeAudio(event.filePath);
        emit(state.copyWith(transcript: text));
        
        // Mocking Tutor Response for now - In full build this would call /tutor/ask
        final response = "Sannu! Shi wannan wasali ne mai fita a baki.";
        final voiceUrl = "http://146.190.153.125:3001/voice/synthesize?text=${Uri.encodeComponent(response)}&lang=ha-NG";
        
        emit(state.copyWith(
          isProcessing: false, 
          responseText: response,
        ));
        
        _audioService.speakUrl(voiceUrl);
      } catch (e) {
        emit(state.copyWith(isProcessing: false, error: e.toString()));
      }
    });

    on<ResetTutor>((event, emit) {
      emit(TutorState());
    });
  }
}
