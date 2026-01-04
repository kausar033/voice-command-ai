import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    Completer<void> completer = Completer<void>();
    _flutterTts.setCompletionHandler(() {
      completer.complete();
    });
    await _flutterTts.speak(text);
    return completer.future;
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
