import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/task.dart';
import '../../repository/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final _repository = TaskRepository();
  final String playthroughName;
  TaskCubit(this.playthroughName)
      : super(
          TaskInitial([], TaskStates.initial, Filter.all),
        ) {
    _loadTasks(playthroughName);
  }

  Future<void> _loadTasks(String name) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    final list = await _repository.getAllTasks(name);
    emit(state.copyWith(tasks: list, taskStates: TaskStates.loaded));
  }

  Future<void> completeTask(int id) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    await _repository.completeTask(id);
    final list = await _repository.getAllTasks(playthroughName);
    emit(state.copyWith(tasks: list, taskStates: TaskStates.complete));
  }

  Future<void> filter(Filter? value) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    value ??= state.filter;
    List<Task> data;
    switch (value) {
      case Filter.all:
        data = await _repository.getAllTasks(playthroughName);
        break;
      case Filter.completed:
        data = await _repository.completedTasks(playthroughName);
        break;
      case Filter.uncompleted:
        data = await _repository.uncompletedTasks(playthroughName);
        break;
    }
    emit(state.copyWith(tasks: data, taskStates: TaskStates.completed));
  }
}
