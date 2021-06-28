import '../models/task.dart';
import '../services/data_provider.dart';
import '../services/database.dart';

class HomeRepository {
  final _dataProvider = DataProvider.instance;

  Future<List<Task>> loadCurrentPlaythrough() =>
      _dataProvider.loadCurrentCheckList(playthrough);

  Future<List<Task>> loadCurrentAchievement() =>
      _dataProvider.loadCurrentCheckList(achievement);

  Future<int> completeTaskFromPlaythrough(int id) =>
      _dataProvider.completeTask(id, playthrough);

  Future<int> completeTaskFromAchievement(int id) =>
      _dataProvider.completeTask(id, achievement);
}
