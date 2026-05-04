import 'dart:io';
import 'package:dio/dio.dart';
import '../models/learning_models.dart';
import 'network_client.dart';

class HausaRepository {
  final NetworkClient _networkClient;

  HausaRepository({NetworkClient? client}) : _networkClient = client ?? NetworkClient();

  Future<Learner> registerLearner(Map<String, dynamic> payload) async {
    try {
      final response = await _networkClient.dio.post(
        '/guided/learners',
        data: payload,
      );
      return Learner.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to register learner: ${e.response?.data}');
    }
  }

  Future<PlacementResult> computePlacement(String learnerId) async {
    try {
      final response = await _networkClient.dio.post('/guided/placement/$learnerId');
      return PlacementResult.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to compute placement: ${e.response?.data}');
    }
  }

  Future<Map<String, dynamic>> getNextLesson(String learnerId) async {
    try {
      final response = await _networkClient.dio.get('/guided/curriculum/next-lesson/$learnerId');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get next lesson: ${e.response?.data}');
    }
  }

  Future<List<dynamic>> getTracks() async {
    try {
      final response = await _networkClient.dio.get('/guided/curriculum/tracks');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get tracks: ${e.response?.data}');
    }
  }

  Future<SessionStepResponse> startSession(String learnerId, String lessonId) async {
    try {
      final response = await _networkClient.dio.post(
        '/guided/sessions/start',
        data: {
          'learnerId': learnerId,
          'lessonId': lessonId,
        },
      );
      return SessionStepResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to start session: ${e.response?.data}');
    }
  }

  Future<SessionStepResponse> submitStep(
    String sessionId,
    String currentStep, {
    dynamic data,
  }) async {
    try {
      final Map<String, dynamic> payload = {'currentStep': currentStep};
      if (data is Map<String, dynamic>) {
        payload.addAll(data);
      }

      final response = await _networkClient.dio.post(
        '/guided/sessions/$sessionId/submit-step',
        data: payload,
      );
      return SessionStepResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to submit step: ${e.response?.data}');
    }
  }

  Future<String> transcribeAudio(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(filePath, filename: 'audio.m4a'),
      });

      final response = await _networkClient.dio.post(
        '/voice/transcribe',
        data: formData,
      );
      return response.data['text'] ?? '';
    } on DioException catch (e) {
      throw Exception('Failed to transcribe audio: ${e.response?.data}');
    }
  }
}
