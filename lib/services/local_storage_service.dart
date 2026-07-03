import 'dart:convert';

import 'package:todo_design/model/task.dart';
import 'package:todo_design/constant/storage_keys.dart';
import 'package:todo_design/services/preference.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();
  factory LocalStorageService() => instance;

  final Preferences _preferences = Preferences();

  List<Task> getTasks() {
    final savedTasks = _preferences.getData(StorageKeys.tasks);
    if (savedTasks is! List<String>) {
      return [];
    }

    return savedTasks
        .map((item) => Task.fromMap(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final encodedTasks = tasks.map((task) => jsonEncode(task.toMap())).toList();
    await _preferences.setData(StorageKeys.tasks, encodedTasks);
  }
}
