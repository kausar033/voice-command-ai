import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SttService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isAvailable = false;

  Future<bool> init() async {
    _isAvailable = await _speechToText.initialize(
      onError: (val) => debugPrint('onError: $val'),
      onStatus: (val) => debugPrint('onStatus: $val'),
    );
    return _isAvailable;
  }

  Future<void> listen({
    required Function(String) onResult,
    required String localeId,
  }) async {
    if (!_isAvailable) {
      bool initialized = await init();
      if (!initialized) return;
    }

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: localeId,
    );
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
}
