import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_payload.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/learning_models.dart';

enum DiagnosticStage { intro, questions, computing, summary }

class OnboardingProvider extends ChangeNotifier {
  final OnboardingPayload _payload = OnboardingPayload();
  final VoiceService _voiceService = VoiceService();
  final ApiService _apiService = ApiService();

  Learner? _learner;
  PlacementResult? _placement;
  bool _isLoading = false;
  String? _error;
  
  DiagnosticStage _stage = DiagnosticStage.intro;
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  final List<String> _answers = [];

  // Getters
  OnboardingPayload get payload => _payload;
  Learner? get learner => _learner;
  PlacementResult? get placement => _placement;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DiagnosticStage get stage => _stage;
  List<dynamic> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  ValueNotifier<bool> get isSpeaking => _voiceService.isPlaying;

  // ─── Actions ───────────────────────────────────────────────────────────────

  void setDisplayName(String name) {
    _payload.displayName = name;
    notifyListeners();
  }

  Future<void> startDiagnosticFlow() async {
    if (_payload.displayName.isEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Register Learner
      try {
        _learner = await _apiService.registerLearner(_payload.toJson());
      } catch (e) {
        debugPrint("API Registration failed, using emergency demo mode: $e");
        _learner = Learner(
          id: "demo-learner-id",
          displayName: _payload.displayName.isNotEmpty ? _payload.displayName : "Gimbiya",
          ageRange: _payload.ageRange.name,
        );
      }
      
      // Persist ID if not demo
      if (_learner!.id != "demo-learner-id") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('learnerId', _learner!.id);
      }

      try {
        // 2. Try New Diagnostic Questions
        _questions = await _apiService.startDiagnostic(_learner!.id);
        
        if (_questions.isNotEmpty) {
          _stage = DiagnosticStage.questions;
          _currentQuestionIndex = 0;
          _answers.clear();
          _speakQuestion();
        } else {
          // No questions, fallback to direct placement
          _placement = await _apiService.computePlacement(_learner!.id);
          _stage = DiagnosticStage.summary;
        }
      } catch (e) {
        // If 404 Not Found (endpoint not on server), fallback to legacy algorithm
        if (e.toString().contains('404') || _learner?.id == "demo-learner-id") {
          _placement = await _apiService.computePlacement(_learner!.id);
          _stage = DiagnosticStage.summary;
        } else {
          rethrow;
        }
      }
    } catch (e) {
      _error = e.toString();
      _stage = DiagnosticStage.intro; // Reset to start
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void submitAnswer(String answer) {
    _answers.add(answer);
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _speakQuestion();
      notifyListeners();
    } else {
      _finalizeDiagnostic();
    }
  }

  Future<void> _finalizeDiagnostic() async {
    _isLoading = true;
    _stage = DiagnosticStage.computing;
    notifyListeners();

    try {
      if (_learner?.id == "demo-learner-id") {
        // Mock placement for demo mode
        _placement = PlacementResult(
          trackId: "lith-id",
          strandId: "strand-id",
          unitId: "unit-id",
          lessonId: "lesson-id",
          rationale: "Bisa bayanan ki, muna ba ki shawarar fara da darasin haruffa. (Based on your answers, we recommend starting with the Alphabet lessons.)",
        );
      } else {
        _placement = await _apiService.submitDiagnostic(_learner!.id, _answers);
      }
      _stage = DiagnosticStage.summary;
    } catch (e) {
      debugPrint("Diagnostic finalization failed: $e");
      _error = e.toString();
      _stage = DiagnosticStage.intro; // Go back on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void playGreeting() {
     _voiceService.speak("Suna na Jidda. Ke meye sunanki?");
  }

  void _speakQuestion() {
    if (_questions.isNotEmpty && _currentQuestionIndex < _questions.length) {
      final q = _questions[_currentQuestionIndex];
      final text = q['text'] ?? "";
      _voiceService.speak(text);
    }
  }

  // ─── Voice Controls (On-Device STT) ────────────────────────────────────────

  Future<void> startListening({Function(String)? onResult}) => 
      _voiceService.startListening(onResult: onResult);
  
  Future<void> stopListening() => _voiceService.stopListening();

  // Legacy fallback if needed
  Future<void> startRecording() => _voiceService.startRecording();
  Future<String?> stopAndTranscribe() => _voiceService.stopAndTranscribe();

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
