import 'package:ds_soft_checklist/services/database.dart';

import '../models/task.dart';
import '../services/data_provider.dart';

class TaskRepository {
  static final instance = TaskRepository._();
  final _dataProvider = DataProvider.instance;
  final _db = DBProvider.instance;

  TaskRepository._();

  //Playthrough tasks
  Future<int> completeTaskFromPlaythrough(int id) async =>
      await _dataProvider.completeTask(id, playthrough);

  Future<List<Task>> getAllTasksFromPlaythrough(String name) async =>
      await _dataProvider.getTasksFromDB(name, playthrough);

  Future<List<Task>> completedTasksFromPlaythrough(String name) async =>
      await _db.completed(name, playthrough);

  Future<List<Task>> uncompletedTasksFromPlaythrough(String name) async =>
      await _db.uncompleted(name, playthrough);

  //Achievement tasks
  Future<int> completeTaskFromAchievement(int id) async =>
      await _dataProvider.completeTask(id, achievement);

  Future<List<Task>> getAllTasksFromAchievement(String name) async =>
      await _dataProvider.getTasksFromDB(name, achievement);

  Future<List<Task>> completedTasksFromAchievement(String name) async =>
      await _db.completed(name, achievement);

  Future<List<Task>> uncompletedTasksFromAchievement(String name) async =>
      await _db.uncompleted(name, achievement);
}
