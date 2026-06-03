import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

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
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: const BoxDecoration(gradient: AppColors.profileGradient),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: Text('N',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 12),
                Text('Estudiante',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('$completed', 'Completadas'),
                    _stat('$total', 'Total'),
                    _stat('$productivity%', 'Productividad'),
                  ],
                ),
              ),
            ),
          ),
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

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}