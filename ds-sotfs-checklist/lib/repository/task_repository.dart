import '../models/task.dart';
import '../services/data_provider.dart';
import '../services/database.dart';

class TaskRepository {
  static final instance = TaskRepository._();
  final _dataProvider = DataProvider.instance;
  final _db = DBProvider.instance;

  TaskRepository._();

  //Playthrough tasks
  Future<int> completeTaskFromPlaythrough(int id) =>
      _dataProvider.completeTask(id, playthrough);

  Future<List<Task>> getAllTasksFromPlaythrough(String name) =>
      _dataProvider.getTasksFromDB(name, playthrough);

  Future<List<Task>> completedTasksFromPlaythrough(String name) =>
      _db.completed(name, playthrough);

  Future<List<Task>> uncompletedTasksFromPlaythrough(String name) =>
      _db.uncompleted(name, playthrough);

  //Achievement tasks
  Future<int> completeTaskFromAchievement(int id) =>
      _dataProvider.completeTask(id, achievement);

  Future<List<Task>> getAllTasksFromAchievement(String name) =>
      _dataProvider.getTasksFromDB(name, achievement);

  Future<List<Task>> completedTasksFromAchievement(String name) =>
      _db.completed(name, achievement);

  Future<List<Task>> uncompletedTasksFromAchievement(String name) =>
      _db.uncompleted(name, achievement);
}
