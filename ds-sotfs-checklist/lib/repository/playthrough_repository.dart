import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/services/data_provider.dart';
import 'package:ds_soft_checklist/services/database.dart';

class PlaythroughRepository {
  final _dataProvider = DataProvider.instance;

  Future<List<ChecklistItem>> getData() async =>
      await _dataProvider.getNameFromPlaythrough(playthrough);

  Future<List<ChecklistItem>> getDataFromAchievement() async =>
      await _dataProvider.getNameFromPlaythrough(achievement);

  Future<int> selectCheckListInPlaythrough(String name) async =>
      await _dataProvider.selectChecklist(name, playthrough);

  Future<int> selectCheckListInAchievement(String name) async =>
      await _dataProvider.selectChecklist(name, achievement);
}
