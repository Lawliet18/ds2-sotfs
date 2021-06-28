import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/playthrough.dart';
import '../models/task.dart';

const isCompleted = 'is_completed';

const playthrough = 'Playthrough';
const achievement = 'Achievement';

class DBProvider {
  static final instance = DBProvider._();
  Database? _database;

  DBProvider._();

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
      '''
      CREATE TABLE $playthrough(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      task TEXT,
      is_completed BIT,
      is_selected BIT
      )''',
    );
    await db.execute(
      '''
      CREATE TABLE $achievement(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      task TEXT,
      is_completed BIT,
      is_selected BIT
      )''',
    );
  }

  Future<void> addDataToPlaythroughTable(List<dynamic> playthroughItem) async {
    final db = await _db;
    final batch = db.batch();
    for (final items in playthroughItem) {
      for (final task in items['tasks']) {
        await db.rawInsert(
          'INSERT INTO $playthrough (name, task, is_completed,is_selected) VALUES(?, ?, ?,?)',
          [items['name'], task, 0, 0],
        );
      }
    }
    batch.commit();
  }

  Future<void> addDataToAchievementTable(List<dynamic> achievementItem) async {
    final db = await _db;
    final batch = db.batch();
    for (final items in achievementItem) {
      for (final task in items['tasks']) {
        await db.rawInsert(
          'INSERT INTO $achievement (name, task, is_completed,is_selected) VALUES(?, ?, ?, ?)',
          [items['name'], task, 0, 0],
        );
      }
    }
    batch.commit();
  }

  Future<List<ChecklistItem>> getChecklistItemName(String tableName) async {
    final db = await _db;
    final data = await db.rawQuery(
        'select name, count(task), sum(is_completed), is_selected from $tableName group by name');
    return data.isNotEmpty
        ? data.map((map) => ChecklistItem.fromMap(map)).toList()
        : [];
  }

  Future<List<Task>> getTasksByName(String name, String tableName) async {
    final db = await _db;
    final data =
        await db.query(tableName, where: 'name = ?', whereArgs: [name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<int> completeTask(int id, String tableName) async {
    final db = await _db;
    return db.rawUpdate(
      'UPDATE $tableName SET $isCompleted = CASE WHEN $isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [id],
    );
  }

  Future<List<Task>> completed(String name, String tableName) async {
    final db = await _db;
    final data = await db.query(tableName,
        where: '$isCompleted = ? AND name = ?', whereArgs: ['1', name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<List<Task>> uncompleted(String name, String tableName) async {
    final db = await _db;
    final data = await db.query(tableName,
        where: '$isCompleted = ? AND name = ?', whereArgs: ['0', name]);
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<List<Task>> currentChecklist(String tableName) async {
    final db = await _db;
    final data = await db.query(
      tableName,
      where: '$isCompleted = ? AND is_selected = ?',
      whereArgs: ['0', '1'],
      limit: 4,
    );
    return data.isNotEmpty ? data.map((map) => Task.fromMap(map)).toList() : [];
  }

  Future<int> selectChecklist(String name, String tableName) async {
    final db = await _db;
    return db.rawUpdate(
      'UPDATE $tableName SET is_selected = CASE WHEN name = ? THEN 1 ELSE 0 END',
      [name],
    );
  }

  Future<bool> get isDatabaseExists async {
    final path = await getDatabasesPath();
    return databaseExists(path);
  }
}
