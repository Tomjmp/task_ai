import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'screens/task_form_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const TaskAIApp(),
    ),
  );
}

// Rutas de la app con go_router
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) {
        final task = state.extra as Task?; // la tarea a editar, o null para crear
        return TaskFormScreen(task: task);
      },
    ),
  ],
);

class TaskAIApp extends StatelessWidget {
  const TaskAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TaskAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C4DF6),
        ),
      ),
      routerConfig: _router,
    );
  }
}