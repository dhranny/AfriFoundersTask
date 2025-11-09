import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'state_managers/task_provider.dart';
import 'state_managers/theme_manager.dart';
import '../widgets/task_item.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager',
        ),
        actions: [
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: 'Toggle Theme',
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Empty state
          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new task',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total',
                      taskProvider.taskCount.toString(),
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Completed',
                      taskProvider.completedTaskCount.toString(),
                      Colors.green,
                    ),
                    _buildStatItem(
                      'Pending',
                      (taskProvider.taskCount - taskProvider.completedTaskCount)
                          .toString(),
                      Colors.orange,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Task list
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];

                    // Dismissible widget for swipe-to-delete
                    return Dismissible(
                      key: Key(task.id),
                      background: _buildSwipeBackground(Alignment.centerLeft),
                      secondaryBackground: _buildSwipeBackground(Alignment.centerRight),
                      direction: DismissDirection.horizontal,
                      confirmDismiss: (direction) async {
                        // Show confirmation dialog
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Task'),
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
                      },
                      onDismissed: (direction) {
                        taskProvider.deleteTask(task.id);

                        // Show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.title} deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Note: For a full undo feature, you'd need to
                                // store the deleted task and re-add it
                              },
                            ),
                          ),
                        );
                      },
                      child: TaskItem(
                        task: task,
                        onTap: () {
                          // Navigate to edit screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(taskId: task.id),
                            ),
                          );
                        },
                        onToggle: () {
                          taskProvider.toggleTaskCompletion(task.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // Floating Action Button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add,
        ),
      ),
    );
  }

  // Helper widget for statistics
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Helper widget for swipe background
  Widget _buildSwipeBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}