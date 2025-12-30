import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ai/domain/entities/task.dart';
import 'package:flutter_ai/domain/repositories/task_repository.dart';

// States
abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit(this.repository) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to load tasks: $e"));
    }
  }

  Future<void> addTask(String title) async {
    try {
      await repository.addTask(title);
      await loadTasks();
    } catch (e) {
      emit(TaskError("Failed to add task: $e"));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await repository.updateTask(task);
      await loadTasks();
    } catch (e) {
      emit(TaskError("Failed to update task: $e"));
    }
  }
}
