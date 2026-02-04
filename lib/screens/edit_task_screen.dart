import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../themes/app_theme.dart'; // Import for theme access

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isNotEmpty) {
      await Provider.of<TaskProvider>(context, listen: false).updateTask(
        Task(
          id: widget.task.id,
          title: title,
          description: description,
          dueDate: _selectedDate,
          status: widget.task.status,
          priority: _priority,
        ),
      );
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      // Show error snackbar for validation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: AppTheme.rgbTheme.primaryColor, // Use theme primary
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Add scroll for small screens
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.rgbTheme.primaryColor!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.rgbTheme.primaryColor!),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No due date selected'
                          : 'Due: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(color: AppTheme.rgbTheme.primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(
                      'Pick Date',
                      style: TextStyle(color: AppTheme.rgbTheme.colorScheme?.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.rgbTheme.primaryColor!),
                  ),
                ),
                items: ['low', 'medium', 'high'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.rgbTheme.primaryColor, // Theme button color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}