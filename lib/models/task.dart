import '../themes/app_theme.dart'; // Optional: Remove if not using theme in model

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String status; // 'pending' or 'completed'
  final String priority; // 'low', 'medium', 'high'

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.status = 'pending',
    this.priority = 'low',
  });

  // Create a copy with modified fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  // For debugging/logging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, status: $status, priority: $priority)';
  }

  // Basic validation
  bool isValid() {
    return title.trim().isNotEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'status': status,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      status: map['status'] ?? 'pending',
      priority: map['priority'] ?? 'low',
    );
  }
}