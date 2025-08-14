import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _saveTask() {
    if (_titleController.text.isEmpty || _subjectController.text.isEmpty || _selectedDate == null) return;

    final newTask = Task(
      title: _titleController.text,
      subject: _subjectController.text,
      dueDate: _selectedDate!.toIso8601String(),
      category: '',
    );

    final box = Hive.box<Task>('tasks');
    box.add(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(_selectedDate == null
                    ? "No date picked"
                    : "Due: \${_selectedDate!.toLocal()}".split(' ')[0]),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _pickDate, child: const Text("Pick Date")),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: const Text("Save Task"),
            )
          ],
        ),
      ),
    );
  }
}
