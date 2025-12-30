import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ai/main.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_ai/presentation/cubit/task_cubit.dart';
import 'package:flutter_ai/core/services/stt_service.dart';
import 'package:flutter_ai/core/services/tts_service.dart';
import 'package:flutter_ai/core/logic/command_processor.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskCubit extends MockCubit<TaskState> implements TaskCubit {}

class MockSttService extends Mock implements SttService {}

class MockTtsService extends Mock implements TtsService {}

class MockCommandProcessor extends Mock implements CommandProcessor {}

void main() {
  setUpAll(() {
    registerFallbackValue(TaskInitial());
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    final sl = GetIt.instance;
    sl.reset();
    sl.registerLazySingleton<SttService>(() => MockSttService());
    sl.registerLazySingleton<TtsService>(() => MockTtsService());
    sl.registerLazySingleton<CommandProcessor>(() => MockCommandProcessor());
    sl.registerFactory<TaskCubit>(() => MockTaskCubit());
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Mock Cubit State & Methods
    final mockTaskCubit = GetIt.I<TaskCubit>();
    when(() => mockTaskCubit.state).thenReturn(TaskInitial());
    when(() => mockTaskCubit.loadTasks()).thenAnswer((_) async {});
    when(
      () => mockTaskCubit.close(),
    ).thenAnswer((_) async {}); // Cubit might be closed by BlocProvider

    try {
      await tester.pumpWidget(const MyApp());
    } catch (e) {
      debugPrint('TEST ERROR: $e');
      rethrow;
    }
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
