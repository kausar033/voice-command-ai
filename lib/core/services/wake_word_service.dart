import 'package:flutter/foundation.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:flutter_ai/core/constants/app_constants.dart';

class WakeWordService {
  PorcupineManager? _porcupineManager;
  bool _isListening = false;
  Function? _onWake;

  Future<void> init(Function onWake) async {
    _onWake = onWake;
    try {
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        AppConstants.picovoiceAccessKey,
        [AppConstants.wakeWordPath],
        _wakeWordCallback,
      );
    } on PorcupineException catch (e) {
      debugPrint('Porcupine initialization error: $e');
      rethrow;
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      debugPrint('Wake word "Hey Man" detected!');
      _onWake?.call();
    }
  }

  Future<void> startListening() async {
    if (_porcupineManager == null) {
      debugPrint('PorcupineManager not initialized.');
      return;
    }

    // Explicitly check for internal state to avoid double-starting if the package throws
    // although PorcupineManager usually handles idempotent starts gracefully or throws,
    // we want to be safe.
    try {
      if (!_isListening) {
        await _porcupineManager!.start();
        _isListening = true;
      }
    } on PorcupineException catch (e) {
      debugPrint('Porcupine start error: $e');
    }
  }

  Future<void> stopListening() async {
    if (_porcupineManager == null) return;

    try {
      // Porcupine doesn't expose isListening directly in all versions,
      // but stopping while stopped is usually safe or we track it.
      await _porcupineManager!.stop();
      _isListening = false;
    } on PorcupineException catch (e) {
      debugPrint('Porcupine stop error: $e');
    }
  }

  Future<void> dispose() async {
    await _porcupineManager?.delete();
  }
}
