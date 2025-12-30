import 'package:flutter_ai/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(String title);
  Future<void> deleteTask(int id);
  Future<void> updateTask(Task task);
}
