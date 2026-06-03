import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/task_provider.dart';
import '../theme/app_colors.dart';

const _userName = 'Tomás';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    final productivity = total == 0 ? 0 : ((completed / total) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildStatsRow(completed, productivity),
          const SizedBox(height: 16),
          _buildSettingsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.profileGradient),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_outlined,
                      size: 18, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 32),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFEF3C7), Color(0xFFFBBF24)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'T',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check,
                            size: 12, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${_userName.toLowerCase()} · Estudiante',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int completed, int productivity) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('$completed', 'Completas', const Color(0xFF0F172A)),
          _divider(),
          _statItem('20', 'Racha 🔥', const Color(0xFFF59E0B)),
          _divider(),
          _statItem('$productivity%', 'Productiv.', AppColors.primary),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: const Color(0xFFE2E8F0));
  }

  Widget _buildSettingsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _settingsTile(
            icon: Icons.cloud_outlined,
            iconBg: const Color(0x1A7C5CFF),
            iconColor: AppColors.primary,
            title: 'Sincronización en nube',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, size: 8, color: Color(0xFF10B981)),
                SizedBox(width: 4),
                Text('Conectado',
                    style: TextStyle(fontSize: 12, color: Color(0xFF10B981))),
                SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFCBD5E1), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.notifications_outlined,
            iconBg: const Color(0x1AEC4899),
            iconColor: AppColors.pink,
            title: 'Notificaciones',
            subtitle: '8 notificaciones',
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.category_outlined,
            iconBg: const Color(0x1A00D4FF),
            iconColor: AppColors.cyan,
            title: 'Categorías personalizadas',
            subtitle: '2 categorías',
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    )),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ],
            ),
          ),
          trailing ??
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFCBD5E1), size: 20),
        ],
      ),
    );
  }
}
