import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const String _taskBoxName = 'tasksBox';
  late Box<Task> _taskBox;

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  int get taskCount => _tasks.length;

  int get completedTaskCount => _tasks.where((task) => task.isCompleted).length;

  // Initialize Hive and load tasks
  Future<void> initialize() async {
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _loadTasks();
  }

  // Load all tasks from Hive
  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    // Sort by creation date (newest first)
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  // Add a new task
  Future<void> addTask(String title, String description) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    await _taskBox.put(task.id, task);
    _loadTasks();
  }

  // Update an existing task
  Future<void> updateTask(String id, String title, String description) async {
    final task = _taskBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        title: title,
        description: description,
      );
      await _taskBox.put(id, updatedTask);
      _loadTasks();
    }
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
      );
      await _taskBox.put(id, updatedTask);
      _loadTasks();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    _loadTasks();
  }

  // Get a single task by ID
  Task? getTaskById(String id) {
    return _taskBox.get(id);
  }

  // Delete all tasks (optional - useful for testing)
  Future<void> deleteAllTasks() async {
    await _taskBox.clear();
    _loadTasks();
  }
}