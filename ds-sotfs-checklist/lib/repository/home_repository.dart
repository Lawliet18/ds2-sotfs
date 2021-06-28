import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/services/data_provider.dart';
import 'package:ds_soft_checklist/services/database.dart';

class HomeRepository {
  final _dataProvider = DataProvider.instance;

  Future<List<Task>> loadCurrentPlaythrough() async =>
      await _dataProvider.loadCurrentCheckList(playthrough);

  Future<List<Task>> loadCurrentAchievement() async =>
      await _dataProvider.loadCurrentCheckList(achievement);

  Future<int> completeTaskFromPlaythrough(int id) async =>
      await _dataProvider.completeTask(id, playthrough);

  Future<int> completeTaskFromAchievement(int id) async =>
      await _dataProvider.completeTask(id, achievement);
}
