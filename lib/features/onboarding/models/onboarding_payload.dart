import '../../../core/models/learning_models.dart';

class ParentSettings {
  String preferredPath;
  List<String> restrictions;

  ParentSettings({
    this.preferredPath = '',
    List<String>? restrictions,
  }) : restrictions = restrictions ?? [];

  Map<String, dynamic> toJson() {
    return {
      'preferredPath': preferredPath,
      'restrictions': restrictions,
    };
  }
}

class OnboardingPayload {
  String userType = "SELF"; // "CHILD" | "SELF"
  String displayName = "";
  
  // Enums matching backend
  AgeRange ageRange = AgeRange.AGE_8_12;
  LanguagePreference languagePreference = LanguagePreference.HAUSA;
  LiteracyLevel literacyLevel = LiteracyLevel.PRE_LITERATE;
  SchoolExposure schoolExposure = SchoolExposure.NONE;
  LearningGoal learningGoal = LearningGoal.READ_AND_UNDERSTAND;
  ConfidenceLevel confidenceLevel = ConfidenceLevel.MEDIUM;

  ParentSettings? parentSettings;

  OnboardingPayload();

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName.isNotEmpty ? displayName : (userType == "SELF" ? "Learner" : "Child"),
      'ageRange': ageRange.name,
      'languagePreference': languagePreference.name,
      'literacyLevel': literacyLevel.name,
      'schoolExposure': schoolExposure.name,
      'learningGoal': learningGoal.name,
      'confidenceLevel': confidenceLevel.name,
      'supervisionMode': userType == "CHILD" ? "PARENT_GUIDED" : "SELF_GUIDED",
    };
  }
}
