import 'dart:developer';

import 'package:get/get.dart';
import 'package:todo_design/model/task.dart';
import 'package:todo_design/services/local_storage_service.dart';

class DashboardController extends GetxController {
  final tasks = <Task>[].obs;
  final isLoading = false.obs;
  final _storage = LocalStorageService();
  List<Task> get archiveTasks => tasks.where((t) => t.isArchived).toList();
  List<Task> get activeTasks =>
      tasks.where((task) => !task.isArchived).toList()..sort(_sortByPriority);

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  int _sortByPriority(Task a, Task b) =>
      a.priority.index.compareTo(b.priority.index);

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await _persistTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    try {
      tasks.assignAll(_storage.getTasks()..sort(_sortByPriority));
    } catch (e) {
      log("Error fetching tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(Task task) async {
    isLoading.value = true;
    try {
      final taskIndex =
          tasks.indexWhere((currentTask) => currentTask.id == task.id);
      if (taskIndex == -1) {
        return;
      }
      tasks[taskIndex] = task;
      tasks.refresh();
      await _persistTasks();
    } catch (e) {
      log("Error updating task: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFromArchive(Task task) async {
    tasks.removeWhere((t) => t.id == task.id);
    await _persistTasks();
  }

  Future<void> unarchiveTask(Task task) async {
    task.isArchived = false;
    tasks.refresh();
    try {
      await _persistTasks();
    } catch (e) {
      log("Error in unarchive task: $e");
    }
  }

  Future<void> toggleArchive(Task task) async {
    task.isArchived = !task.isArchived;
    tasks.refresh();
    try {
      await _persistTasks();
    } catch (e) {
      log("Error toggling archive: $e");
    }
  }

  Future<void> toggleChecked(Task task) async {
    task.isChecked = !task.isChecked;
    tasks.refresh();
    try {
      await _persistTasks();
    } catch (e) {
      log("Error toggling checked: $e");
    }
  }

  List<Task> get completedTasks => _filterTasks(
        (t) => t.isChecked && !t.isArchived,
      );

  List<Task> get incompleteTasks => _filterTasks(
        (t) => !t.isChecked && !t.isArchived,
      );

  List<Task> _filterTasks(bool Function(Task) predicate) =>
      tasks.where(predicate).toList()..sort(_sortByPriority);

  Future<void> _persistTasks() async {
    final sortedTasks = [...tasks]..sort(_sortByPriority);
    tasks.assignAll(sortedTasks);
    await _storage.saveTasks(sortedTasks);
  }
}
