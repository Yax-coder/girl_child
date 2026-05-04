import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/learning_models.dart';

class ApiService {
  static String get baseUrl {
    // Production Live Server
    return 'http://146.190.153.125:3001';
  }

  Future<Learner> registerLearner(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guided/learners'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Learner.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register learner: ${response.body}');
    }
  }

  Future<PlacementResult> computePlacement(String learnerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guided/placement/$learnerId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PlacementResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to compute placement: ${response.body}');
    }
  }

  Future<List<dynamic>> startDiagnostic(String learnerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/guided/placement/$learnerId/start'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['questions'] ?? [];
    } else {
      throw Exception('Failed to start diagnostic: ${response.body}');
    }
  }

  Future<PlacementResult> submitDiagnostic(String learnerId, List<String> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guided/placement/$learnerId/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'answers': answers}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PlacementResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to submit diagnostic: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getNextLesson(String learnerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/guided/curriculum/next-lesson/$learnerId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get next lesson: ${response.body}');
    }
  }

  Future<List<dynamic>> getTracks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/guided/curriculum/tracks'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get tracks: ${response.body}');
    }
  }

  Future<SessionStepResponse> startSession(String learnerId, String lessonId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guided/sessions/start'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'learnerId': learnerId,
        'lessonId': lessonId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return SessionStepResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to start session: ${response.body}');
    }
  }

  Future<SessionStepResponse> submitStep(
    String sessionId,
    String currentStep, {
    dynamic data,
  }) async {
    final Map<String, dynamic> payload = {'currentStep': currentStep};
    if (data is Map<String, dynamic>) {
      payload.addAll(data);
    }

    final response = await http.post(
      Uri.parse('$baseUrl/guided/sessions/$sessionId/submit-step'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return SessionStepResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to submit step: ${response.body}');
    }
  }

  Future<String> askAssistant(String sessionId, String question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guided/sessions/$sessionId/ask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'] ?? '';
    } else {
      throw Exception('Failed to ask assistant: ${response.body}');
    }
  }

  Future<String> aiChatMessage(String? sessionId, String text, {String? userId}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai-chat/message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionId': sessionId ?? 'default-session',
        'userId': userId ?? 'guest-user',
        'text': text,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text'] ?? '';
    } else {
      throw Exception('Failed to send AI message: ${response.body}');
    }
  }

  Future<String> transcribeAudio(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/voice/transcribe'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        filePath,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text'] ?? '';
    } else {
      throw Exception('Failed to transcribe audio: ${response.body}');
    }
  }
}
