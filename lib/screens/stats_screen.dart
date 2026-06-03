import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;

    final byCategory = <TaskCategory, int>{};
    for (final c in TaskCategory.values) {
      byCategory[c] = tasks.where((t) => t.category == c).length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progreso general',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 8),
                  Text('${(progress * 100).toStringAsFixed(0)}% completado'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard(context, 'Total', total, Icons.list),
              const SizedBox(width: 12),
              _statCard(context, 'Pendientes', pending, Icons.pending_actions),
              const SizedBox(width: 12),
              _statCard(context, 'Completadas', completed, Icons.check_circle),
            ],
          ),
          const SizedBox(height: 16),
          Text('Por categoría',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...TaskCategory.values.map((c) {
            return ListTile(
              title: Text(_categoryLabel(c)),
              trailing: Text(
                '${byCategory[c]}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, int value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text('$value', style: Theme.of(context).textTheme.headlineMedium),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(TaskCategory category) {
    switch (category) {
      case TaskCategory.trabajo:
        return 'Trabajo';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.estudio:
        return 'Estudio';
      case TaskCategory.urgente:
        return 'Urgente';
    }
  }
}