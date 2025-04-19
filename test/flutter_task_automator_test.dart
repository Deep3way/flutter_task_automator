import 'dart:async';

import 'package:flutter_task_automator/src/automated_task.dart';
import 'package:flutter_task_automator/src/task.dart';
import 'package:flutter_task_automator/src/task_scheduler.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'flutter_task_automator_test.mocks.dart';

// Generate mocks for the Task interface
@GenerateMocks([Task])
void main() {
  late TaskScheduler scheduler;
  late MockTask mockTask;

  /// Sets up the test environment before each test.
  ///
  /// Initializes a new [TaskScheduler] and a mocked [Task] with a stubbed [call]
  /// method that returns a completed [Future].
  setUp(() {
    scheduler = TaskScheduler();
    mockTask = MockTask();
    when(mockTask.call()).thenAnswer((_) async => Future.value());
  });

  /// Cleans up the test environment after each test.
  ///
  /// Stops all tasks in the [TaskScheduler] to prevent state leakage.
  tearDown(() {
    scheduler.stopAllTasks();
  });

  /// Tests that a one-time task is added and executed exactly once.
  test('TaskScheduler adds and executes one-time task', () async {
    final task = AutomatedTask(
      id: 'one_time',
      task: mockTask.call,
    );

    scheduler.addTask(task);

    await Future.delayed(const Duration(milliseconds: 100));

    verify(mockTask.call()).called(1);
  });

  /// Tests that a periodic task is added and executed multiple times.
  test('TaskScheduler adds and executes periodic task', () async {
    final task = AutomatedTask(
      id: 'periodic',
      task: mockTask.call,
      interval: const Duration(milliseconds: 50),
    );

    scheduler.addTask(task);

    await Future.delayed(const Duration(milliseconds: 200));

    verify(mockTask.call()).called(greaterThanOrEqualTo(3));
  });

  /// Tests that removing a task stops its execution.
  test('TaskScheduler removes task and stops execution', () async {
    final task = AutomatedTask(
      id: 'periodic',
      task: mockTask.call,
      interval: const Duration(milliseconds: 50),
    );

    final taskId = scheduler.addTask(task);

    await Future.delayed(const Duration(milliseconds: 150));

    scheduler.removeTask(taskId);

    reset(mockTask);
    when(mockTask.call()).thenAnswer((_) async => Future.value());

    await Future.delayed(const Duration(milliseconds: 150));

    verifyNever(mockTask.call());
  });

  /// Tests that a task with retries executes the correct number of times on failure.
  test('TaskScheduler handles task retries on failure', () async {
    int callCount = 0;
    final task = AutomatedTask(
      id: 'retry_task',
      task: () async {
        callCount++;
        if (callCount <= 2) {
          throw Exception('Simulated failure');
        }
      },
      retryOnFailure: true,
      maxRetries: 2,
    );

    scheduler.addTask(task);

    await Future.delayed(const Duration(milliseconds: 500));

    expect(callCount, equals(3));
  });
}
