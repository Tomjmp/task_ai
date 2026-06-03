import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/stats'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/form'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilters(context, provider),
          const Divider(height: 1),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<TaskProvider>().deleteTask(task.id);
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              context
                                  .read<TaskProvider>()
                                  .toggleComplete(task.id);
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
                          onTap: () => context.push('/form', extra: task),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, TaskProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: provider.statusFilter == StatusFilter.todas,
                onSelected: (_) => provider.setStatusFilter(StatusFilter.todas),
              ),
              ChoiceChip(
                label: const Text('Pendientes'),
                selected: provider.statusFilter == StatusFilter.pendientes,
                onSelected: (_) =>
                    provider.setStatusFilter(StatusFilter.pendientes),
              ),
              ChoiceChip(
                label: const Text('Completadas'),
                selected: provider.statusFilter == StatusFilter.completadas,
                onSelected: (_) =>
                    provider.setStatusFilter(StatusFilter.completadas),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Todas las categorías'),
                selected: provider.categoryFilter == null,
                onSelected: (_) => provider.setCategoryFilter(null),
              ),
              ...TaskCategory.values.map((c) {
                return ChoiceChip(
                  label: Text(_categoryLabel(c)),
                  selected: provider.categoryFilter == c,
                  onSelected: (_) => provider.setCategoryFilter(c),
                );
              }),
            ],
          ),
        ],
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