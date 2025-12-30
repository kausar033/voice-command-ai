import 'package:flutter_ai/data/datasources/task_database.dart';
import 'package:flutter_ai/domain/entities/task.dart';
import 'package:flutter_ai/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDatabase database;

  TaskRepositoryImpl(this.database);

  @override
  Future<void> addTask(String title) async {
    await database.insertTask(title);
  }

  @override
  Future<void> deleteTask(int id) async {
    await database.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks() async {
    final data = await database.getTasks();
    return data
        .map(
          (e) => Task(
            id: e['id'] as int,
            title: e['title'] as String,
            isCompleted: (e['isCompleted'] as int) == 1,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await database.updateTask(task.id!, task.isCompleted ? 1 : 0);
  }
}
