import 'package:get_it/get_it.dart';
import 'package:flutter_ai/core/services/permission_service.dart';
import 'package:flutter_ai/core/services/tts_service.dart';
import 'package:flutter_ai/core/services/stt_service.dart';
import 'package:flutter_ai/core/services/intent_service.dart';
import 'package:flutter_ai/core/services/notification_service.dart';
import 'package:flutter_ai/data/datasources/task_database.dart';
import 'package:flutter_ai/domain/repositories/task_repository.dart';
import 'package:flutter_ai/data/repositories/task_repository_impl.dart';
import 'package:flutter_ai/presentation/cubit/task_cubit.dart';
import 'package:flutter_ai/core/logic/command_processor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => PermissionService());
  sl.registerLazySingleton(() => TtsService());
  sl.registerLazySingleton(() => SttService());
  sl.registerLazySingleton(() => IntentService());
  sl.registerLazySingleton(() => TaskDatabase());
  sl.registerLazySingleton(() => NotificationService());

  // Repositories
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));

  // Bloc/Cubit
  sl.registerLazySingleton(() => TaskCubit(sl()));

  // Logic
  sl.registerLazySingleton(
    () => CommandProcessor(
      taskCubit: sl(),
      ttsService: sl(),
      intentService: sl(),
    ),
  );
}
