import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/playthrough.dart';
import '../../repository/playthrough_repository.dart';

part 'playthrough_state.dart';

class PlaythroughCubit extends Cubit<PlaythroughState> {
  final _repository = PlaythroughRepository();
  final ChecklistPages page;
  PlaythroughCubit(this.page)
      : super(PlaythroughInitial(
            const [], PlaythroughStates.initial, page, PlaythoughFilter.show,
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

  Future<List<ChecklistItem>> _choosedPage() {
    if (page == ChecklistPages.playthrough) {
      return _repository.getData();
    } else {
      return _repository.getDataFromAchievement();
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
