import 'package:flutter_ai/core/services/intent_service.dart';
import 'package:flutter_ai/core/services/tts_service.dart';
import 'package:flutter_ai/presentation/cubit/task_cubit.dart';

class CommandProcessor {
  final TaskCubit taskCubit;
  final TtsService ttsService;
  final IntentService intentService;

  CommandProcessor({
    required this.taskCubit,
    required this.ttsService,
    required this.intentService,
  });

  Future<void> processCommand(String command, String languageCode) async {
    final lowerCommand = command.toLowerCase();

    // English Logic
    if (languageCode.startsWith('en')) {
      if (lowerCommand.contains("add task")) {
        final title = _extractTaskTitle(lowerCommand, "add task");
        if (title.isNotEmpty) {
          await taskCubit.addTask(title);
          await ttsService.speak("Task added: $title");
        } else {
          await ttsService.speak("What should the task say?");
        }
      } else if (lowerCommand.contains("delete task")) {
        // Logic to find task ID... "Delete task 1"
        // This is simple parsing.
        // We might need to map numbers.
        // For MVP, "delete task number X"
        final id = _extractId(lowerCommand);
        if (id != null) {
          // We need to map visual index to DB id properly if needed.
          // For now assuming ID directly.
          // Or we can modify delete to take visual index if we have current state.
          // But Cubit access to state is easier.
          // Let's assume ID for now, or match title.

          await taskCubit.deleteTask(id);
          await ttsService.speak("Task deleted");
        } else {
          await ttsService.speak("Which task should I delete?");
        }
      } else if (lowerCommand.contains("show tasks") ||
          lowerCommand.contains("show my tasks")) {
        await taskCubit.loadTasks(); // Although UI should react.
        await ttsService.speak("Here are your tasks");
      } else if (lowerCommand.contains("open calculator")) {
        await intentService.openCalculator();
      } else if (lowerCommand.contains("open browser")) {
        await intentService.openBrowser("");
      }
    }
    // Bangla Logic
    else if (languageCode.startsWith('bn')) {
      if (lowerCommand.contains("যোগ করুন") ||
          lowerCommand.contains("কাজ যোগ")) {
        // "কাজ যোগ করুন বাজার করা" -> add task do marketing
        // Extract after "যোগ করুন" or "কাজ যোগ করুন"
        // Simplify: Assume command ends with logic if complex, but simple suffix split for now.
        String title = "";
        if (lowerCommand.contains("যোগ করুন")) {
          title = _extractTaskTitle(lowerCommand, "যোগ করুন");
        }

        if (title.isNotEmpty) {
          await taskCubit.addTask(title);
          await ttsService.speak("কাজ যোগ করা হয়েছে: $title");
        } else {
          await ttsService.speak("কি কাজ যোগ করব?");
        }
      } else if (lowerCommand.contains("মুছে ফেলুন") ||
          lowerCommand.contains("ডিলিট")) {
        // "১ নম্বর কাজ মুছে ফেলুন" -> delete 1 number task
        // Parse Bangla numbers if needed or expecting digits
        final id = _extractId(
          lowerCommand,
        ); // digits often come as digits even in Bangla STT sometimes, or we map.
        if (id != null) {
          await taskCubit.deleteTask(id);
          await ttsService.speak("কাজ মুছে ফেলা হয়েছে");
        } else {
          await ttsService.speak("কোন কাজটি মুছব?");
        }
      } else if (lowerCommand.contains("দেখাও") ||
          lowerCommand.contains("সব কাজ")) {
        await taskCubit.loadTasks();
        await ttsService.speak("আপনার কাজগুলো এখানে");
      } else if (lowerCommand.contains("ক্যালকুলেটর")) {
        await intentService
            .openCalculator(); // might fail if localized app name differs but intent is same
      }
    }
    // Add more commands
  }

  String _extractTaskTitle(String command, String trigger) {
    final index = command.indexOf(trigger);
    if (index != -1) {
      return command.substring(index + trigger.length).trim();
    }
    return "";
  }

  int? _extractId(String command) {
    // "delete task number 2"
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(command);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }
}
