import 'package:bloc/bloc.dart';
import 'package:ds_soft_checklist/pages/playthrough/playthrough_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../models/task.dart';
import '../../repository/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final _repository = TaskRepository.instance;
  final String name;
  final ChecklistPages page;
  TaskCubit(this.name, this.page)
      : super(
          TaskInitial([], TaskStates.initial, Filter.all),
        ) {
    _loadTasks(name);
  }

  Future<void> _loadTasks(String name) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    List<Task> list;
    if (page == ChecklistPages.playthrough) {
      list = await _repository.getAllTasksFromPlaythrough(name);
    } else {
      list = await _repository.getAllTasksFromAchievement(name);
    }
    emit(state.copyWith(tasks: list, taskStates: TaskStates.loaded));
  }

  Future<void> completeTask(int id) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    if (page == ChecklistPages.playthrough) {
      await _repository.completeTaskFromPlaythrough(id);
    } else {
      await _repository.completeTaskFromAchievement(id);
    }
    final list = await _filterData(state.filter);
    emit(state.copyWith(tasks: list, taskStates: TaskStates.complete));
  }

  Future<void> filter(Filter? filter) async {
    emit(state.copyWith(taskStates: TaskStates.loading));
    filter ??= state.filter;
    final data = await _filterData(filter);
    emit(state.copyWith(
        tasks: data, taskStates: TaskStates.completed, filter: filter));
  }

  Future<List<Task>> _filterData(Filter value) async {
    if (page == ChecklistPages.playthrough) {
      switch (value) {
        case Filter.all:
          return await _repository.getAllTasksFromPlaythrough(name);
        case Filter.completed:
          return await _repository.completedTasksFromPlaythrough(name);
        case Filter.uncompleted:
          return await _repository.uncompletedTasksFromPlaythrough(name);
      }
    } else {
      switch (value) {
        case Filter.all:
          return await _repository.getAllTasksFromAchievement(name);
        case Filter.completed:
          return await _repository.completedTasksFromAchievement(name);
        case Filter.uncompleted:
          return await _repository.uncompletedTasksFromAchievement(name);
      }
    }
  }

  Future<void> closeSearch() async {
    final data = await _filterData(state.filter);
    emit(state.copyWith(tasks: data, taskStates: TaskStates.loaded));
  }

  void startSearch() => emit(state.copyWith(taskStates: TaskStates.search));

  Future<void> search(String str) async {
    final data = await _filterData(state.filter);
    final filteringData = data
        .where(
            (element) => element.task.toLowerCase().contains(str.toLowerCase()))
        .toList();
    emit(state.copyWith(
        tasks: filteringData, taskStates: TaskStates.searchDone));
  }
}
