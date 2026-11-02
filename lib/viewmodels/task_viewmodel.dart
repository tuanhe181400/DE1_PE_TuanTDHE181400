import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database_helper.dart';
import '../models/task_model.dart';

part 'task_viewmodel.g.dart';

@riverpod
class TaskViewModel extends _$TaskViewModel {
  @override
  FutureOr<List<TaskModel>> build() async {
    return await _loadTasks();
  }

  Future<List<TaskModel>> _loadTasks() async {
    return await DatabaseHelper.instance.getTasks();
  }

  Future<void> refreshTasks() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadTasks());
  }

  Future<void> updateTask(TaskModel task) async {
    await DatabaseHelper.instance.updateTask(task);
    await refreshTasks();
  }

  Future<void> addTask(TaskModel task) async {
    await DatabaseHelper.instance.insertTask(task);
    await refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await refreshTasks();
  }

  Future<void> toggleCompletion(TaskModel task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updated);
  }
}
