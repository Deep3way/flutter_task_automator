import 'package:flutter_task_automator/src/task.dart';

/// A task that can be scheduled with configurable properties such as periodicity,
/// priority, and retry behavior.
///
/// This class implements the [Task] interface and wraps a provided asynchronous
/// function, adding support for retries and periodic execution.
///
/// Example:
/// ```dart
/// var task = AutomatedTask(
///   id: 'poll',
///   task: () async => print('Polling'),
///   interval: Duration(seconds: 1),
///   retryOnFailure: true,
///   maxRetries: 3,
/// );
/// ```
class AutomatedTask implements Task {
  /// The unique identifier for the task.
  final String id;

  /// The asynchronous function that performs the task's operation.
  final Future<void> Function() task;

  /// The interval between executions for periodic tasks, or `null` for one-time tasks.
  final Duration? interval;

  /// The priority of the task (higher values indicate higher priority).
  ///
  /// Currently unused but available for future scheduling enhancements.
  final int priority;

  /// Whether to retry the task on failure.
  final bool retryOnFailure;

  /// The maximum number of retry attempts if [retryOnFailure] is `true`.
  final int maxRetries;

  /// Creates an [AutomatedTask] with the specified properties.
  ///
  /// * [id]: A unique identifier for the task.
  /// * [task]: The asynchronous function to execute.
  /// * [interval]: The interval for periodic execution, or `null` for one-time tasks.
  /// * [priority]: The task's priority (default: 0).
  /// * [retryOnFailure]: Whether to retry on failure (default: `false`).
  /// * [maxRetries]: The maximum number of retries (default: 0).
  AutomatedTask({
    required this.id,
    required this.task,
    this.interval,
    this.priority = 0,
    this.retryOnFailure = false,
    this.maxRetries = 0,
  });

  /// Executes the task, applying retry logic if configured.
  ///
  /// If [retryOnFailure] is `true`, the task will be retried up to [maxRetries]
  /// times with exponential backoff on failure. If all retries fail, the last
  /// exception is rethrown.
  ///
  /// Returns a [Future] that completes when the task succeeds or all retries are exhausted.
  @override
  Future<void> call() async {
    int retries = 0;
    while (true) {
      try {
        await task();
        break; // Success, exit retry loop
      } catch (e) {
        if (retryOnFailure && retries < maxRetries) {
          retries++;
          await Future.delayed(
              Duration(milliseconds: 100 * retries)); // Exponential backoff
          continue;
        }
        rethrow; // No more retries, propagate error
      }
    }
  }

  /// Whether the task is periodic (i.e., has a non-null [interval]).
  bool get isPeriodic => interval != null;
}
