import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Estadísticas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _progressCard(progress, completed, total),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard(context, 'Total', total, Icons.list_rounded,
                  AppColors.primary, const Color(0x1A7C5CFF)),
              const SizedBox(width: 10),
              _statCard(context, 'Pendientes', pending,
                  Icons.pending_actions_rounded, AppColors.media, const Color(0x1AF59E0B)),
              const SizedBox(width: 10),
              _statCard(context, 'Completadas', completed,
                  Icons.check_circle_outline_rounded, AppColors.baja, const Color(0x1A10B981)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Por categoría',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          ...TaskCategory.values.map((c) => _categoryRow(c, byCategory[c]!)),
        ],
      ),
    );
  }

  Widget _progressCard(double progress, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progreso general',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text('$completed de $total completadas',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, int value,
      IconData icon, Color color, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
    );
  }

  Widget _categoryRow(TaskCategory category, int count) {
    final (label, icon, color) = _categoryMeta(category);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  (String, String, Color) _categoryMeta(TaskCategory c) {
    switch (c) {
      case TaskCategory.trabajo:
        return ('Trabajo', '💼', AppColors.primary);
      case TaskCategory.personal:
        return ('Personal', '🙂', AppColors.cyan);
      case TaskCategory.estudio:
        return ('Estudio', '🎓', AppColors.media);
      case TaskCategory.urgente:
        return ('Urgente', '⚡', AppColors.alta);
    }
  }
}
