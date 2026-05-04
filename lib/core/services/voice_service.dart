import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:speech_to_text/speech_to_text.dart';
import 'api_service.dart';

class VoiceService {
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  final SpeechToText _speech = SpeechToText();
  final ApiService _apiService = ApiService();
  
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  final ValueNotifier<String> lastWords = ValueNotifier<String>("");
  
  bool _speechInitialized = false;

  VoiceService() {
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing && state.processingState != ProcessingState.completed;
    });
  }

  Future<void> speak(String text, {String lang = 'ha-NG'}) async {
    if (text.isEmpty) return;

    final uri = Uri.parse('${ApiService.baseUrl}/voice/synthesize').replace(queryParameters: {
      'text': text,
      'lang': lang,
    });
    
    await speakUrl(uri.toString());
  }

  Future<void> speakUrl(String url) async {
    if (url.isEmpty) return;

    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      debugPrint("Voice Synthesis Error: $e");
    }
  }

  // ─── STT (On-Device) ───────────────────────────────────────────────────────

  Future<void> initSpeech() async {
    if (!_speechInitialized) {
      _speechInitialized = await _speech.initialize(
        onStatus: (status) => debugPrint("STT Status: $status"),
        onError: (error) => debugPrint("STT Error: $error"),
      );
    }
  }

  Future<void> startListening({Function(String)? onResult}) async {
    await initSpeech();
    if (_speechInitialized) {
      isRecording.value = true;
      _speech.listen(
        onResult: (result) {
          lastWords.value = result.recognizedWords;
          if (onResult != null) onResult(result.recognizedWords);
        },
        localeId: "ha-NG", // specifically for Hausa
      );
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isRecording.value = false;
  }

  // ─── Recording Fallback (API ASR) ──────────────────────────────────────────

  Future<void> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = p.join(directory.path, 'voice_input.m4a');
        
        const config = RecordConfig();
        
        await _recorder.start(config, path: path);
        isRecording.value = true;
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }

  Future<String?> stopAndTranscribe() async {
    try {
      final path = await _recorder.stop();
      isRecording.value = false;
      
      if (path != null) {
        return await _apiService.transcribeAudio(path);
      }
    } catch (e) {
      debugPrint("Transcription Error: $e");
    }
    return null;
  }

  void dispose() {
    _player.dispose();
    _recorder.dispose();
  }
}
