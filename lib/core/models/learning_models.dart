// ─── Backend Enums ────────────────────────────────────────────────────────────

enum AgeRange { AGE_8_12, AGE_13_17, AGE_18_PLUS }
enum LanguagePreference { HAUSA, ENGLISH, BILINGUAL }
enum LiteracyLevel { PRE_LITERATE, EMERGING_READER, READER }
enum SchoolExposure { NONE, BASIC, IN_SCHOOL, ADVANCED }
enum LearningGoal { READ_AND_UNDERSTAND, SCHOOL_SUPPORT, LEARN_A_SKILL, ALL_ROUND_GROWTH }
enum ConfidenceLevel { LOW, MEDIUM, HIGH }

// ─── Domain Models ───────────────────────────────────────────────────────────

class Learner {
  final String id;
  final String displayName;
  final String ageRange;

  Learner({
    required this.id,
    required this.displayName,
    required this.ageRange,
  });

  factory Learner.fromJson(Map<String, dynamic> json) {
    return Learner(
      id: json['id'],
      displayName: json['displayName'],
      ageRange: json['ageRange'],
    );
  }
}

// Result of computing placement
class PlacementResult {
  final String trackId;
  final String strandId;
  final String unitId;
  final String lessonId;
  final String rationale;

  PlacementResult({
    required this.trackId,
    required this.strandId,
    required this.unitId,
    required this.lessonId,
    required this.rationale,
  });

  factory PlacementResult.fromJson(Map<String, dynamic> json) {
    return PlacementResult(
      trackId: json['trackId'],
      strandId: json['strandId'],
      unitId: json['unitId'],
      lessonId: json['lessonId'],
      rationale: json['rationale'] ?? '',
    );
  }
}

class StepContent {
  // INTRO
  final String? lessonTitle;
  final String? lessonObjective;
  final String? hook;
  final String? hookVoiceUrl;
  
  // CONTENT
  final String? simpleExplanation;
  final String? explanationVoiceUrl;
  final String? localExample;
  final String? exampleVoiceUrl;
  final String? visualSupportHint;
  final String? audioFirstVersion;

  // PRACTICE
  final String? guidedPractice;
  final String? practiceVoiceUrl;

  // QUIZ
  final String? question;
  final String? questionVoiceUrl;
  final List<String>? options;

  // REFLECTION
  final String? recap;
  final String? recapVoiceUrl;
  final String? reflectionPrompt;

  // COMPLETE
  final String? completionMessage;
  final String? retryVoiceUrl;
  final String? simplifiedRetryVersion;

  final String? encouragement; // Backwards compatibility
  final String? encouragementVoiceUrl;

  StepContent({
    this.lessonTitle,
    this.lessonObjective,
    this.hook,
    this.hookVoiceUrl,
    this.simpleExplanation,
    this.explanationVoiceUrl,
    this.localExample,
    this.exampleVoiceUrl,
    this.visualSupportHint,
    this.audioFirstVersion,
    this.guidedPractice,
    this.practiceVoiceUrl,
    this.question,
    this.questionVoiceUrl,
    this.options,
    this.recap,
    this.recapVoiceUrl,
    this.reflectionPrompt,
    this.completionMessage,
    this.retryVoiceUrl,
    this.simplifiedRetryVersion,
    this.encouragement,
    this.encouragementVoiceUrl,
  });

  factory StepContent.fromJson(Map<String, dynamic> json) {
    return StepContent(
      lessonTitle: json['lessonTitle'],
      lessonObjective: json['lessonObjective'],
      hook: json['hook'],
      hookVoiceUrl: json['hookVoiceUrl'],
      simpleExplanation: json['simpleExplanation'] ?? json['explanation'] ?? json['instruction'],
      explanationVoiceUrl: json['explanationVoiceUrl'] ?? json['instructionVoiceUrl'],
      localExample: json['localExample'] ?? json['example'],
      exampleVoiceUrl: json['exampleVoiceUrl'],
      visualSupportHint: json['visualSupportHint'],
      audioFirstVersion: json['audioFirstVersion'],
      guidedPractice: json['guidedPractice'],
      practiceVoiceUrl: json['practiceVoiceUrl'],
      question: json['question'],
      questionVoiceUrl: json['questionVoiceUrl'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      recap: json['recap'],
      recapVoiceUrl: json['recapVoiceUrl'],
      reflectionPrompt: json['reflectionPrompt'],
      completionMessage: json['completionMessage'],
      retryVoiceUrl: json['retryVoiceUrl'],
      simplifiedRetryVersion: json['simplifiedRetryVersion'],
      encouragement: json['encouragement'],
      encouragementVoiceUrl: json['encouragementVoiceUrl'],
    );
  }
}

class SessionStepResponse {
  final String sessionId;
  final String currentStep; // INTRO, CONTENT, QUIZ, OUTRO
  final StepContent stepContent;
  final bool isComplete;

  SessionStepResponse({
    required this.sessionId,
    required this.currentStep,
    required this.stepContent,
    this.isComplete = false,
  });

  factory SessionStepResponse.fromJson(Map<String, dynamic> json) {
    return SessionStepResponse(
      sessionId: json['sessionId'] ?? '',
      currentStep: json['nextStep'] ?? json['currentStep'] ?? 'UNKNOWN',
      stepContent: StepContent.fromJson(json['stepContent'] ?? {}),
      isComplete: json['isComplete'] ?? false,
    );
  }
}
