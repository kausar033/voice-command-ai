import 'package:get_it/get_it.dart';
import 'package:flutter_ai/core/services/stt_service.dart';
import 'package:flutter_ai/core/services/notification_service.dart';
import 'package:flutter_ai/core/services/tts_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => SttService());
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => TtsService());
}
