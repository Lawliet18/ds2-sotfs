import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:ds_soft_checklist/services/shared_preferences.dart';

import 'database.dart';
import 'json_parser.dart';

class DataProvider {
  final _db = DBProvider.instance;
  final _jsonParser = JsonParser.instance;
  final _sharedPreferences = MySharedPreferences.instance;

  Future<List<Playthrough>> getNameFromPlaythrough() async =>
      await _db.getPlaythroughName();

  Future<void> loadDataOnFirstStart() async => await _loadDataToPlaythrough();

  Future<void> initSharedPrefs() async => await _sharedPreferences.init();

  Future<List<Task>> getTasksFromDB(String name) async =>
      await _db.getTasksByName(name);

  Future<void> _loadDataToPlaythrough() async {
    final playthrough = await _jsonParser.parsePlaythrough();
    await _db.addDataToPlaythroughTable(playthrough);
  }

  Future<void> saveBool(String key, {bool value = false}) async =>
      await _sharedPreferences.saveBool(key, value: value);

  bool loadBoolValue(String key) => _sharedPreferences.loadBoolValue(key);

  Future<bool> get isDatabaseExists async => await _db.isDatabaseExists;
}
