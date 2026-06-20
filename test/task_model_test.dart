import 'package:flutter_test/flutter_test.dart';
import 'package:task_ai/models/task.dart';

void main() {
  group('Task (modelo)', () {
    final task = Task(
      id: 'abc-123',
      userId: 'user-1',
      title: 'Estudiar para el examen',
      description: 'Capítulo 5',
      category: TaskCategory.estudio,
      priority: TaskPriority.alta,
      dueDate: DateTime.parse('2026-06-30T08:00:00.000'),
      createdAt: DateTime.parse('2026-06-20T10:00:00.000'),
      updatedAt: DateTime.parse('2026-06-20T10:00:00.000'),
    );

    test('toJson usa las claves del backend (snake_case)', () {
      final json = task.toJson();
      expect(json['user_id'], 'user-1');
      expect(json['category'], 'estudio');
      expect(json['priority'], 'alta');
      expect(json['completed'], false);
      expect(json['due_date'], '2026-06-30T08:00:00.000');
    });

    test('round-trip toJson -> fromJson conserva los datos', () {
      final restored = Task.fromJson(task.toJson());
      expect(restored.id, task.id);
      expect(restored.userId, task.userId);
      expect(restored.title, task.title);
      expect(restored.category, task.category);
      expect(restored.priority, task.priority);
      expect(restored.isCompleted, task.isCompleted);
      expect(restored.dueDate, task.dueDate);
    });

    test('fromJson aplica valores por defecto ante datos inválidos', () {
      final restored = Task.fromJson({
        'id': 'x',
        'user_id': 'u',
        'title': 'Sin categoría válida',
        'category': 'inexistente',
        'priority': 'inexistente',
        'due_date': '2026-01-01T00:00:00.000',
      });
      expect(restored.category, TaskCategory.personal);
      expect(restored.priority, TaskPriority.media);
      expect(restored.description, '');
      expect(restored.isCompleted, false);
    });

    test('copyWith solo cambia los campos indicados', () {
      final done = task.copyWith(isCompleted: true, synced: false);
      expect(done.isCompleted, true);
      expect(done.synced, false);
      expect(done.id, task.id);
      expect(done.title, task.title);
    });
  });
}
