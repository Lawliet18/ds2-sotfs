import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/task.dart';
import '../../repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final _repository = HomeRepository();
  HomeCubit() : super(const HomeInitial([], [], HomeStates.initial)) {
    loadCurrentChecklist();
  }

  Future<void> loadCurrentChecklist() async {
    emit(state.copyWith(homeStates: HomeStates.loading));
    final listOfCurrentPlaythrough = await _repository.loadCurrentPlaythrough();
    final listOfCurrentAchievement = await _repository.loadCurrentAchievement();
    if (listOfCurrentPlaythrough.isEmpty && listOfCurrentAchievement.isEmpty) {
      emit(state.copyWith(
        currentPlaythrough: [],
        currentAchievement: [],
        homeStates: HomeStates.initial,
      ));
    } else {
      emit(state.copyWith(
        currentPlaythrough: listOfCurrentPlaythrough,
        currentAchievement: listOfCurrentAchievement,
        homeStates: HomeStates.loaded,
      ));
    }
  }

  Future<void> completeTaskPlaythrough(int id) async {
    emit(state.copyWith(homeStates: HomeStates.loading));
    await _repository.completeTaskFromPlaythrough(id);
    final playthrough = await _repository.loadCurrentPlaythrough();
    emit(state.copyWith(
      currentPlaythrough: playthrough,
      homeStates: HomeStates.loaded,
    ));
  }

  Future<void> completeTaskAchievement(int id) async {
    emit(state.copyWith(homeStates: HomeStates.loading));
    await _repository.completeTaskFromAchievement(id);
    final achievement = await _repository.loadCurrentAchievement();
    emit(state.copyWith(
      currentAchievement: achievement,
      homeStates: HomeStates.loaded,
    ));
  }
}
