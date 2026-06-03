import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final productivity = total == 0 ? 0 : ((completed / total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          const Center(
            child: CircleAvatar(
              radius: 48,
              child: Text('N', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Estudiante',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat(context, '$completed', 'Completadas'),
                  _stat(context, '$total', 'Total'),
                  _stat(context, '$productivity%', 'Productividad'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notificaciones'),
          ),
          const ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text('Categorías personalizadas'),
          ),
          const ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Seguridad'),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label),
      ],
    );
  }
}