import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SttService {
  final SpeechToText _speechToText = SpeechToText();
  final ValueNotifier<String> statusNotifier = ValueNotifier("");
  bool _isAvailable = false;

  Future<bool> init() async {
    _isAvailable = await _speechToText.initialize(
      onError: (val) {
        debugPrint('onError: $val');
        statusNotifier.value = "error";
      },
      onStatus: (val) {
        debugPrint('onStatus: $val');
        statusNotifier.value = val;
      },
    );
    return _isAvailable;
  }

  Future<void> listen({
    required Function(String text, bool isFinal) onResult,
    required String localeId,
  }) async {
    if (!_isAvailable) {
      bool initialized = await init();
      if (!initialized) return;
    }

    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 10),
      cancelOnError: false,
      partialResults: true,
    );
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
}
