import 'package:ds_soft_checklist/services/database.dart';

import '../models/task.dart';
import '../services/data_provider.dart';

class TaskRepository {
  final _dataProvider = DataProvider();
  final _db = DBProvider.instance;

  Future<int> completeTask(int id) async => await _db.completeTask(id);

  Future<List<Task>> getAllTasks(String name) async =>
      await _dataProvider.getTasksFromDB(name);

  Future<List<Task>> completedTasks(String name) async =>
      await _db.completed(name);

  Future<List<Task>> uncompletedTasks(String name) async =>
      await _db.uncompleted(name);
}
