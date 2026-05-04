import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/models/learning_models.dart';

class SessionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final VoiceService _voiceService = VoiceService();

  SessionStepResponse? _currentStepResponse;
  bool _isLoading = false;
  String? _error;

  SessionStepResponse? get currentStepResponse => _currentStepResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ValueNotifier<bool> get isSpeaking => _voiceService.isPlaying;

  Future<void> startLesson(String lessonId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final learnerId = prefs.getString('learnerId');

      if (learnerId == null) {
        throw Exception('Learner ID not found. Please complete onboarding.');
      }

      _currentStepResponse = await _apiService.startSession(learnerId, lessonId);
      _speakCurrentStep();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitStep({dynamic data}) async {
    if (_currentStepResponse == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentStepResponse = await _apiService.submitStep(
        _currentStepResponse!.sessionId,
        _currentStepResponse!.currentStep,
        data: data,
      );

      _speakCurrentStep();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _speakCurrentStep() {
    if (_currentStepResponse == null) return;
    
    final content = _currentStepResponse!.stepContent;
    final step = _currentStepResponse!.currentStep;
    
    if (step == "INTRO" && content.hookVoiceUrl != null) {
      _voiceService.speakUrl(content.hookVoiceUrl!);
    } else if (step == "CONTENT" && content.explanationVoiceUrl != null) {
      _voiceService.speakUrl(content.explanationVoiceUrl!).then((_) {
        if (content.exampleVoiceUrl != null) {
          _voiceService.speakUrl(content.exampleVoiceUrl!);
        }
      });
    } else if (step == "PRACTICE" && content.practiceVoiceUrl != null) {
      _voiceService.speakUrl(content.practiceVoiceUrl!);
    } else if (step == "QUIZ" && content.questionVoiceUrl != null) {
      _voiceService.speakUrl(content.questionVoiceUrl!);
    } else if (step == "REFLECTION" && content.recapVoiceUrl != null) {
      _voiceService.speakUrl(content.recapVoiceUrl!);
    } else if ((step == "COMPLETE" || step == "OUTRO")) {
      if (content.retryVoiceUrl != null) {
        _voiceService.speakUrl(content.retryVoiceUrl!);
      } else if (content.encouragementVoiceUrl != null) {
        _voiceService.speakUrl(content.encouragementVoiceUrl!);
      }
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
