import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart'; // Import for edit navigation
import '../themes/app_theme.dart'; // Import for theme access

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'high':
        return Colors.red; // High priority in red
      case 'medium':
        return Colors.orange; // Medium in orange
      case 'low':
      default:
        return Colors.green; // Low in green
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart, // Swipe from right to left to delete
      onDismissed: (direction) {
        Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${task.title} deleted')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white), // White icon for contrast
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
              color: task.status == 'completed' ? Colors.grey : AppTheme.rgbTheme.textTheme?.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: TextStyle(color: AppTheme.rgbTheme.textTheme?.bodyMedium?.color),
              ),
              Column(
                children: [
                  Text(
                    'Due: ${task.dueDate?.toLocal().toString().split(' ')[0] ?? 'No date'}',
                    style: TextStyle(color: AppTheme.rgbTheme.primaryColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Priority: ${task.priority.toUpperCase()}',
                    style: TextStyle(color: _getPriorityColor(), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          trailing: task.status == 'completed'
              ? null // No trailing actions for completed tasks
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: task.status == 'completed',
                activeColor: AppTheme.rgbTheme.colorScheme?.secondary,
                onChanged: (value) {
                  Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.rgbTheme.primaryColor),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}