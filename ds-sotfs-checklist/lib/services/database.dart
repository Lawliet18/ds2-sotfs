import 'dart:async';

import 'package:ds_soft_checklist/models/playthrough.dart';
import 'package:ds_soft_checklist/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const isCompleted = 'is_completed';

class DBProvider {
  DBProvider._();

  final playthroughTableName = 'Playthrough';
  final playthroughTaskTableName = 'Task';

  static final instance = DBProvider._();

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final document = await getDatabasesPath();
    final path = join(document, 'ds2_database.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE Playthrough(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      task TEXT,
      is_completed BIT
      )''',
    );
    // await db.execute(
    //   '''CREATE TABLE $playthroughTaskTableName (
    //   id INTEGER PRIMARY KEY AUTOINCREMENT,
    //   playthrough_id INTEGER,
    //   task TEXT
    //   )''',
    // );
  }

  Future<void> addDataToPlaythroughTable(List<dynamic> playthrough) async {
    final db = await _db;
    var batch = db.batch();
    for (var items in playthrough) {
      for (var task in items['tasks']) {
        await db.rawInsert(
          'INSERT INTO $playthroughTableName (name, task, is_completed) VALUES(?, ?, ?)',
          [items['name'], task, 0],
        );
      }
    }
    batch.commit();
  }

  Future<List<Playthrough>> getPlaythroughName() async {
    final db = await _db;
    final data = await db.rawQuery(
        'select name, count(task), sum(is_completed) from $playthroughTableName group by name');
    print(data.length);
    return data.isNotEmpty
        ? data.map((map) => Playthrough.fromMap(map)).toList()
        : [];
  }

  Future<List<Task>> getTasksByName(String name) async {
    final db = await _db;
    final data = await db
        .query(playthroughTableName, where: 'name = ?', whereArgs: [name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<int> completeTask(int id) async {
    final db = await _db;
    return await db.rawUpdate(
      'UPDATE $playthroughTableName SET $isCompleted = CASE WHEN $isCompleted = 1 THEN 0 ELSE 1 END WHERE id = $id',
    );
  }

  Future<List<Task>> completed(String name) async {
    final db = await _db;
    final data = await db.query(playthroughTableName,
        where: '$isCompleted = ? AND name = ?', whereArgs: ['1', name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<List<Task>> uncompleted(String name) async {
    final db = await _db;
    final data = await db.query(playthroughTableName,
        where: '$isCompleted = ? AND name = ?', whereArgs: ['0', name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<bool> get isDatabaseExists async {
    final path = await getDatabasesPath();
    return databaseExists(path);
  }
}
