import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task; // null = crear, con valor = editar
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskCategory _category = TaskCategory.personal;
  TaskPriority _priority = TaskPriority.media;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Si venimos a editar, precargamos los datos de la tarea
    final task = widget.task;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _category = task.category;
      _priority = task.priority;
      _dueDate = task.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es obligatorio')),
      );
      return;
    }

    final provider = context.read<TaskProvider>();
    final editing = widget.task;

    if (editing == null) {
      // CREAR
      provider.addTask(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: _descriptionController.text.trim(),
        category: _category,
        priority: _priority,
        dueDate: _dueDate,
      ));
    } else {
      // EDITAR (conservamos id y si estaba completada)
      provider.updateTask(Task(
        id: editing.id,
        title: title,
        description: _descriptionController.text.trim(),
        category: _category,
        priority: _priority,
        dueDate: _dueDate,
        isCompleted: editing.isCompleted,
      ));
    }

    context.pop(); // volver a la lista
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarea' : 'Nueva Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: TaskCategory.values.map((c) {
                return DropdownMenuItem(value: c, child: Text(c.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: TaskPriority.values.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _priority = value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              title: const Text('Fecha límite'),
              subtitle: Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(isEditing ? 'Guardar cambios' : 'Crear tarea'),
            ),
          ],
        ),
      ),
    );
  }
}