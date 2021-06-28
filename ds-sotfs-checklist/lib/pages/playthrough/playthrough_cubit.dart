import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/repository/playthrough_repository.dart';
import 'package:ds_soft_checklist/services/database.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'playthrough_state.dart';

class PlaythroughCubit extends Cubit<PlaythroughState> {
  final _repository = PlaythroughRepository();
  final ChecklistPages page;
  PlaythroughCubit(this.page)
      : super(PlaythroughInitial(
            [], PlaythroughStates.initial, page, PlaythoughFilter.show,
            isSelected: false)) {
    loadPlaythrough();
  }

  Future<void> loadPlaythrough() async {
    emit(state.copyWith(playthroughStates: PlaythroughStates.loading));
    final list = await _choosedPage();
    final isSelected = list.every((element) => element.isSelected);
    emit(state.copyWith(
        list: list,
        playthroughStates: PlaythroughStates.loaded,
        isSelected: isSelected));
  }

  Future<List<ChecklistItem>> _choosedPage() async {
    if (page == ChecklistPages.playthrough) {
      return await _repository.getData();
    } else {
      return await _repository.getDataFromAchievement();
    }
  }

  Future<void> filter(PlaythoughFilter filter) async {
    final list = await _choosedPage();
    if (filter == PlaythoughFilter.hide) {
      final filtered = list
          .where((element) => element.completed != element.taskAmount)
          .toList();
      emit(state.copyWith(
        list: filtered,
        playthoughFilter: PlaythoughFilter.hide,
      ));
    } else {
      emit(state.copyWith(
        list: list,
        playthoughFilter: PlaythoughFilter.show,
      ));
    }
  }

  Future<void> selectChecklist(String name) async {
    if (page == ChecklistPages.playthrough) {
      await _repository.selectCheckListInPlaythrough(name);
    } else {
      await _repository.selectCheckListInAchievement(name);
    }
    final list = await _choosedPage();
    final isSelected = list.any((element) => element.isSelected);
    emit(state.copyWith(list: list, isSelected: isSelected));
  }
}
