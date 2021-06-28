import '../models/playthrough.dart';
import '../services/data_provider.dart';
import '../services/database.dart';

class PlaythroughRepository {
  final _dataProvider = DataProvider.instance;

  Future<List<ChecklistItem>> getData() =>
      _dataProvider.getNameFromPlaythrough(playthrough);

  Future<List<ChecklistItem>> getDataFromAchievement() =>
      _dataProvider.getNameFromPlaythrough(achievement);

  Future<int> selectCheckListInPlaythrough(String name) =>
      _dataProvider.selectChecklist(name, playthrough);

  Future<int> selectCheckListInAchievement(String name) =>
      _dataProvider.selectChecklist(name, achievement);
}
