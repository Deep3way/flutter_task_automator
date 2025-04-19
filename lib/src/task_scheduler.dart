import 'dart:async';

import 'automated_task.dart';
import 'task.dart';

/// A scheduler for managing and executing asynchronous tasks.
///
/// The [TaskScheduler] supports both one-time and periodic tasks, represented by
/// [AutomatedTask] instances. Tasks can be added, removed, and stopped, with
/// automatic timer management for periodic execution.
///
/// Example:
/// ```dart
/// final scheduler = TaskScheduler();
/// scheduler.addTask(AutomatedTask(
///   id: 'example',
///   task: () async => print('Task running'),
///   interval: Duration(seconds: 1),
/// ));
/// await Future.delayed(Duration(seconds: 5));
/// scheduler.stopAllTasks();
/// ```
class TaskScheduler {
  /// The map of task IDs to their associated timers.
  final Map<String, Timer> _timers = {};

  /// The map of task IDs to their associated tasks.
  final Map<String, AutomatedTask> _tasks = {};

  /// Adds a task to the scheduler.
  ///
  /// The task is scheduled according to its [AutomatedTask.isPeriodic] property:
  /// periodic tasks run at the specified [AutomatedTask.interval], while one-time
  /// tasks run immediately.
  ///
  /// * [task]: The task to schedule.
  /// Returns the task's ID.
  String addTask(AutomatedTask task) {
    final taskId = task.id; // Use the task's ID
    _tasks[taskId] = task;
    _scheduleTask(task, taskId);
    return taskId;
  }

  /// Schedules a task for execution.
  ///
  /// * [task]: The task to schedule.
  /// * [taskId]: The unique ID of the task.
  ///
  /// Periodic tasks are scheduled with a [Timer.periodic], while one-time tasks
  /// use a single [Timer].
  void _scheduleTask(AutomatedTask task, String taskId) {
    if (task.isPeriodic) {
      _timers[taskId] = Timer.periodic(task.interval!, (_) async {
        await _executeTask(task, taskId);
      });
    } else {
      _timers[taskId] = Timer(Duration.zero, () async {
        await _executeTask(task, taskId);
        _timers.remove(taskId);
        _tasks.remove(taskId);
      });
    }
  }

  /// Executes a task and handles any errors.
  ///
  /// * [task]: The task to execute.
  /// * [taskId]: The unique ID of the task.
  ///
  /// Errors are logged and rethrown to allow calling code to handle them.
  Future<void> _executeTask(Task task, String taskId) async {
    try {
      await task.call();
    } catch (e, stackTrace) {
      print('Task $taskId failed: $e\n$stackTrace');
      rethrow;
    }
  }

  /// Removes a task and cancels its timer.
  ///
  /// * [taskId]: The ID of the task to remove.
  ///
  /// If the task does not exist, this method has no effect.
  void removeTask(String taskId) {
    final timer = _timers.remove(taskId);
    timer?.cancel();
    _tasks.remove(taskId);
  }

  /// Stops all tasks and clears the scheduler.
  ///
  /// Cancels all active timers and removes all tasks from the scheduler.
  void stopAllTasks() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _tasks.clear();
  }

  /// Disposes of the scheduler, stopping all tasks.
  ///
  /// This is an alias for [stopAllTasks].
  void dispose() => stopAllTasks();
}
