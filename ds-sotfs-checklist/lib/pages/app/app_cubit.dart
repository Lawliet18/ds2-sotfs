import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/app_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final _repository = AppRepository();
  AppCubit() : super(AppInitial(AppStates.initial)) {
    _firstLoad();
  }

  Future<void> _firstLoad() async {
    await _repository.initSharedPrefs();
    if (_repository.isDatabaseLoad) {
      emit(state.copyWith(appStates: AppStates.loaded));
    } else {
      _repository.saveDatabaseLoadKey();
      emit(state.copyWith(appStates: AppStates.loading));
      _repository.loadDataFromDataBase();
      emit(state.copyWith(appStates: AppStates.loaded));
    }
  }
}
