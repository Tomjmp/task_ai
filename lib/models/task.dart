enum TaskCategory { trabajo, personal, estudio, urgente }

enum TaskPriority { alta, media, baja }

class Task {
  final String id;
  String title;
  String description;
  TaskCategory category;
  TaskPriority priority;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });
}