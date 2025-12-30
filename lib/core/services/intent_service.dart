import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart'; // We might need this for web or general URLs, but for now specific intents.

class IntentService {
  Future<void> openCalculator() async {
    if (!kIsWeb && Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_CALCULATOR',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } else {
      debugPrint("Calculater launching not supported on this platform");
    }
  }

  Future<void> openBrowser(String url) async {
    // Use url_launcher or android intent
    final uri = Uri.parse(url.isEmpty ? 'https://google.com' : url);
    if (!kIsWeb && Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_view',
        data: uri.toString(),
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } else {
      // Web or other platforms
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint("Could not launch $uri");
      }
    }
  }

  Future<void> openPhone() async {
    if (!kIsWeb && Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.DIAL',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    }
  }
}
