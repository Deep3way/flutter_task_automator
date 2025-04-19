# Flutter Task Automator 🚀

A Flutter library for automating repetitive tasks with scheduling, prioritization, and error
handling. Simplify tasks like periodic API polling, data syncing, or UI updates in your Flutter
applications.

## Features ✨

- ⏰ **Scheduled Execution**: Run tasks periodically or as one-time operations.
- 🔢 **Task Prioritization**: Control execution order with priority settings.
- 🛡️ **Error Handling**: Configure retries for failed tasks.
- 🪶 **Lightweight**: Minimal dependencies for easy integration.

## Installation 📦

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_task_automator: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## Usage 🛠️

```dart
import 'package:flutter_task_automator/flutter_task_automator.dart';

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
    // Add tasks to scheduler
    scheduler.addTask(periodicTask);
    scheduler.addTask(oneTimeTask);

    // Wait to observe task execution
    await Future.delayed(const Duration(seconds: 5));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error during task execution: $e\n$stackTrace');
    }
  } finally {
    // Stop all tasks
    scheduler.stopAllTasks();
    if (kDebugMode) {
      print('All tasks stopped');
    }
  }
}
```

## Usage Roadmap 🗺️

- 🔄 **Task Dependencies**: Enable tasks to wait for others to complete.
- 📊 **Task Monitoring**: Add callbacks for success, failure, or retry events.
- ⚙️ **Pause/Resume**: Support pausing and resuming individual tasks.
- 🌐 **Background Tasks**: Integrate with Flutter’s background processing.
- 📚 **More Examples**: Include Flutter-specific examples, like REST API syncing.

## Running Tests ✅

To run the tests, ensure `mockito` is included in your `dev_dependencies` and use:

```bash
flutter test
```

## Contributing 🤝

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License 📜

MIT License