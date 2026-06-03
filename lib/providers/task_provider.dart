import 'package:flutter/foundation.dart';
import '../models/task.dart';

enum StatusFilter { todas, pendientes, completadas }

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Entregar proyecto final',
      description: 'Exposición de marketing',
      category: TaskCategory.estudio,
      priority: TaskPriority.alta,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      id: '2',
      title: 'Reunión de trabajo',
      category: TaskCategory.trabajo,
      priority: TaskPriority.media,
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  TaskCategory? _categoryFilter; // null = todas las categorías
  StatusFilter _statusFilter = StatusFilter.todas;

  TaskCategory? get categoryFilter => _categoryFilter;
  StatusFilter get statusFilter => _statusFilter;

  // Lista completa, sin filtrar (la usaremos en estadísticas)
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Lista filtrada que muestra el Dashboard
  List<Task> get filteredTasks {
    return _tasks.where((t) {
      final matchCategory =
          _categoryFilter == null || t.category == _categoryFilter;
      final matchStatus = switch (_statusFilter) {
        StatusFilter.todas => true,
        StatusFilter.pendientes => !t.isCompleted,
        StatusFilter.completadas => t.isCompleted,
      };
      return matchCategory && matchStatus;
    }).toList();
  }

  void setCategoryFilter(TaskCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setStatusFilter(StatusFilter status) {
    _statusFilter = status;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleComplete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }
}