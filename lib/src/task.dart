/// An interface for tasks that can be scheduled and executed asynchronously.
///
/// Implementations of this interface must provide an asynchronous [call] method
/// that performs the task's operation.
///
/// Example:
/// ```dart
/// class MyTask implements Task {
///   @override
///   Future<void> call() async {
///     print('Task executed');
///   }
/// }
/// ```
abstract class Task {
  /// Executes the task's operation.
  ///
  /// Returns a [Future] that completes when the task is done.
  Future<void> call();
}
