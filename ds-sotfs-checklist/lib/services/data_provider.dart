import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/services/shared_preferences.dart';

import 'database.dart';
import 'json_parser.dart';

class DataProvider {
  static final instance = DataProvider._();
  final _db = DBProvider.instance;
  final _jsonParser = JsonParser.instance;
  final _sharedPreferences = MySharedPreferences.instance;

  DataProvider._();

  Future<List<ChecklistItem>> getNameFromPlaythrough(String tableName) async =>
      await _db.getChecklistItemName(tableName);

  Future<void> loadDataOnFirstStart() async => await _loadData();

  Future<void> initSharedPrefs() async => await _sharedPreferences.init();

  Future<List<Task>> getTasksFromDB(String name, String tableName) async =>
      await _db.getTasksByName(name, tableName);

  Future<void> _loadData() async {
    final playthrough = await _jsonParser.parsePlaythrough();
    final achievement = await _jsonParser.parseAchievement();
    await _db.addDataToPlaythroughTable(playthrough);
    await _db.addDataToAchievementTable(achievement);
  }

  Future<void> saveBool(String key, {bool value = false}) async =>
      await _sharedPreferences.saveBool(key, value: value);

  bool loadBoolValue(String key) => _sharedPreferences.loadBoolValue(key);

  Future<List<Task>> loadCurrentCheckList(String tableNmae) async =>
      await _db.currentChecklist(tableNmae);

  Future<int> selectChecklist(String name, String tableName) async =>
      await _db.selectChecklist(name, tableName);

  Future<int> completeTask(int id, String tableName) async =>
      await _db.completeTask(id, tableName);

  Future<bool> get isDatabaseExists async => await _db.isDatabaseExists;
}
