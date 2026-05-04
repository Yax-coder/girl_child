import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  ValueNotifier<bool> get isPlaying => _player.playingStateNotifier; // Helper if we want to listen

  Stream<bool> get playingStream => _player.playingStream;

  Future<void> speakUrl(String url) async {
    try {
      final localPath = await _getCachedFilePath(url);
      
      if (await File(localPath).exists()) {
        debugPrint("Audio Cache HIT: $localPath");
        await _player.setFilePath(localPath);
      } else {
        debugPrint("Audio Cache MISS: Downloading $url");
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final file = File(localPath);
          await file.writeAsBytes(response.bodyBytes);
          await _player.setFilePath(localPath);
        } else {
          // Fallback to streaming if download fails
          await _player.setUrl(url);
        }
      }
      
      await _player.play();
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<String> _getCachedFilePath(String url) async {
    final directory = await getTemporaryDirectory();
    final hash = md5.convert(utf8.encode(url)).toString();
    return "${directory.path}/$hash.mp3";
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}

extension AudioPlayerExt on AudioPlayer {
  ValueNotifier<bool> get playingStateNotifier {
    final notifier = ValueNotifier<bool>(playing);
    playingStream.listen((p) => notifier.value = p);
    return notifier;
  }
}
