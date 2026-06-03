import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider: si la lista cambia, esta pantalla se redibuja sola
    final tasks = context.watch<TaskProvider>().tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No hay tareas todavía'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      context.read<TaskProvider>().toggleComplete(task.id);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(_categoryLabel(task.category)),
                );
              },
            ),
    );
  }

  // Convierte el enum de categoría en texto legible
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