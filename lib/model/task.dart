import 'package:todo_design/config/app_enums.dart';

class Task {
  final String id;
  String title;
  String description;
  Priorities priority;
  bool isChecked;
  bool isArchived;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priorities.low,
    this.isChecked = false,
    this.isArchived = false,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      priority: data['priority'] != null
          ? Priorities.values.firstWhere(
              (e) => e.toString() == 'Priorities.${data['priority']}',
              orElse: () => Priorities.low,
            )
          : Priorities.low,
      isChecked: data['isChecked'] ?? false,
      isArchived: data['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.toString().split('.').last,
      'isChecked': isChecked,
      'isArchived': isArchived,
    };
  }
}
