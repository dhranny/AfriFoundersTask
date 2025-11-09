import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state_managers/task_provider.dart';
import '../models/task.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTaskScreen extends StatefulWidget {
  final String? taskId; // null means we're adding a new task

  const EditTaskScreen({Key? key, this.taskId}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = true;
  bool get _isEditing => widget.taskId != null;
  @override
  void initState() {
    super.initState();
    _loadTask();
  }
  void _loadTask() {
    if (_isEditing) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final task = taskProvider.getTaskById(widget.taskId!);
      if (task != null) {
        _titleController.text = task.title;
        _descriptionController.text = task.description;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (_isEditing) {
        await taskProvider.updateTask(
          widget.taskId!,
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
      } else {
        await taskProvider.addTask(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Task updated successfully!' : 'Task added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTask,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Title',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextFormField(
              controller: _titleController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              autofocus: !_isEditing,
            ),

            const SizedBox(height: 30),
            Text('Description',
              style: Theme.of(context).textTheme.bodyLarge,         ),
            TextFormField(
              controller: _descriptionController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: 'Enter task description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 40),

            // Save button
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isEditing ? 'Update Task' : 'Add Task'),
              ),

            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && mounted) {
                    final taskProvider = Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    );
                    await taskProvider.deleteTask(widget.taskId!);

                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task deleted successfully!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Delete Task'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}