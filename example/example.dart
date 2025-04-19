import 'package:flutter/foundation.dart';
import 'package:flutter_task_automator/flutter_task_automator.dart';

/// Demonstrates usage of the [TaskScheduler] with [AutomatedTask].
///
/// This example schedules a periodic task to poll an API and a one-time task to
/// sync data, runs them for 5 seconds, and then stops all tasks.
void main() async {
  final scheduler = TaskScheduler();

  // Define a periodic task
  final periodicTask = AutomatedTask(
    id: 'api_poll',
    task: () async {
      if (kDebugMode) {
        print('Polling API at ${DateTime.now()}');
      }
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 100));
    },
    interval: const Duration(seconds: 2),
    priority: 1,
    retryOnFailure: true,
    maxRetries: 2,
  );

  // Define a one-time task
  final oneTimeTask = AutomatedTask(
    id: 'data_sync',
    task: () async {
      if (kDebugMode) {
        print('Syncing data at ${DateTime.now()}');
      }
      // Simulate data sync
      await Future.delayed(const Duration(milliseconds: 100));
    },
    priority: 2,
  );

  try {
    /// Add tasks to the scheduler
    scheduler.addTask(periodicTask);
    scheduler.addTask(oneTimeTask);

    /// Wait to observe task execution
    await Future.delayed(const Duration(seconds: 5));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error during task execution: $e\n$stackTrace');
    }
  } finally {
    /// Stop all tasks
    scheduler.stopAllTasks();
    if (kDebugMode) {
      print('All tasks stopped');
    }
  }
}
