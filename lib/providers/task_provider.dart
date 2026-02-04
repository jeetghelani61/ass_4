import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _filter = 'all'; // 'all', 'pending', 'completed'
  String _searchQuery = '';

  List<Task> get tasks => _filteredTasks;

  Future<Database> get database async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, due_date TEXT, status TEXT, priority TEXT)',
        );
      },
    );
  }

  Future<void> loadTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    _tasks = List.generate(maps.length, (i) => Task.fromMap(maps[i]));
    _applyFilters();
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks = _tasks.where((task) {
      bool matchesFilter = _filter == 'all' ||
          (_filter == 'pending' && task.status == 'pending') ||
          (_filter == 'completed' && task.status == 'completed');
      bool matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery) ||
          task.description.toLowerCase().contains(_searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      status: task.status == 'pending' ? 'completed' : 'pending',
      priority: task.priority,
    );
    await updateTask(updatedTask);
  }
}