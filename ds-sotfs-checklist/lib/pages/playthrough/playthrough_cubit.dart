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
  PlaythroughCubit()
      : super(PlaythroughInitial([], PlaythroughStates.initial)) {
    _loadPlaythrough();
  }

  Future<void> _loadPlaythrough() async {
    emit(state.copyWith(playthroughStates: PlaythroughStates.loading));
    final list = await _repository.getData();
    emit(state.copyWith(
        list: list, playthroughStates: PlaythroughStates.loaded));
  }
}
