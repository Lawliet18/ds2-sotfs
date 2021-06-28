import '../models/playthrough.dart';
import '../models/task.dart';
import 'database.dart';
import 'json_parser.dart';
import 'shared_preferences.dart';

class DataProvider {
  static final instance = DataProvider._();
  final _db = DBProvider.instance;
  final _jsonParser = JsonParser.instance;
  final _sharedPreferences = MySharedPreferences.instance;

  DataProvider._();

  Future<List<ChecklistItem>> getNameFromPlaythrough(String tableName) =>
      _db.getChecklistItemName(tableName);

  Future<void> loadDataOnFirstStart() => _loadData();

  Future<void> initSharedPrefs() => _sharedPreferences.init();

  Future<List<Task>> getTasksFromDB(String name, String tableName) =>
      _db.getTasksByName(name, tableName);

  Future<void> _loadData() async {
    final playthrough = await _jsonParser.parsePlaythrough();
    final achievement = await _jsonParser.parseAchievement();
    _db.addDataToPlaythroughTable(playthrough);
    _db.addDataToAchievementTable(achievement);
  }

  Future<void> saveBool(String key, {bool value = false}) =>
      _sharedPreferences.saveBool(key, value: value);

  bool loadBoolValue(String key) => _sharedPreferences.loadBoolValue(key);

  Future<List<Task>> loadCurrentCheckList(String tableNmae) =>
      _db.currentChecklist(tableNmae);

  Future<int> selectChecklist(String name, String tableName) =>
      _db.selectChecklist(name, tableName);

  Future<int> completeTask(int id, String tableName) =>
      _db.completeTask(id, tableName);

  Future<bool> get isDatabaseExists => _db.isDatabaseExists;
}
