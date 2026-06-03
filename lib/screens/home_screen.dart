import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

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
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/stats'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/form'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: Column(
        children: [
          _progressHeader(context, provider.tasks),
          _buildFilters(context, provider),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.alta,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<TaskProvider>().deleteTask(task.id);
                        },
                        child: _taskCard(context, task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _progressHeader(BuildContext context, List<Task> allTasks) {
    final total = allTasks.length;
    final completed = allTasks.where((t) => t.isCompleted).length;
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progreso Hoy', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('$completed de $total tareas',
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCard(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) =>
              context.read<TaskProvider>().toggleComplete(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 6,
            children: [
              Chip(
                label: Text(_categoryLabel(task.category)),
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text(_priorityLabel(task.priority)),
                labelStyle: TextStyle(color: _priorityColor(task.priority)),
                side: BorderSide(color: _priorityColor(task.priority)),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        onTap: () => context.push('/form', extra: task),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, TaskProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.alta:
        return AppColors.alta;
      case TaskPriority.media:
        return AppColors.media;
      case TaskPriority.baja:
        return AppColors.baja;
    }
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.alta:
        return 'Alta';
      case TaskPriority.media:
        return 'Media';
      case TaskPriority.baja:
        return 'Baja';
    }
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