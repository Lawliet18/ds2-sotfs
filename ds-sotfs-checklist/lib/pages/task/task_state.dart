part of 'task_cubit.dart';

enum Filter { all, completed, uncompleted }
enum TaskStates {
  initial,
  loading,
  loaded,
  uncompleted,
  complete,
  completed,
  searchDone,
  search
}

@immutable
abstract class TaskState extends Equatable {
  final TaskStates taskStates;
  final List<Task> tasks;
  final Filter filter;

  const TaskState(this.tasks, this.taskStates, this.filter);

  TaskState copyWith({
    final TaskStates? taskStates,
    final List<Task>? tasks,
    final Filter? filter,
  });

  @override
  List<Object?> get props => [tasks, taskStates, filter];
}

class TaskInitial extends TaskState {
  const TaskInitial(List<Task> tasks, TaskStates taskStates, Filter filter)
      : super(tasks, taskStates, filter);

  @override
  TaskState copyWith({
    TaskStates? taskStates,
    List<Task>? tasks,
    Filter? filter,
  }) {
    return TaskInitial(tasks ?? this.tasks, taskStates ?? this.taskStates,
        filter ?? this.filter);
  }
}
