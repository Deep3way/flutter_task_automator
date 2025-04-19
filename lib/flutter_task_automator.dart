/// The public API for the flutter_task_automator package.
///
/// This package provides utilities for scheduling and managing asynchronous tasks
/// in Flutter applications, including support for periodic and one-time tasks with
/// retry capabilities.
///
/// Key classes:
/// - [Task]: The interface for executable tasks.
/// - [AutomatedTask]: A configurable task with properties like periodicity and retries.
/// - [TaskScheduler]: Manages and schedules tasks.
export 'src/automated_task.dart';
export 'src/task.dart';
export 'src/task_scheduler.dart';
