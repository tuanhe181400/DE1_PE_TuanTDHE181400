import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    DatabaseFactory dbFactory;
    String path;

    if (kIsWeb) {
      dbFactory = databaseFactoryFfiWeb;
      path = filePath;
    } else {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        dbFactory = databaseFactoryFfi;
        final dbPath = await dbFactory.getDatabasesPath();
        path = join(dbPath, filePath);
      } else {
        final dbPath = await getDatabasesPath();
        path = join(dbPath, filePath);
        dbFactory = databaseFactory;
      }
    }

    return await dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        is_completed INTEGER DEFAULT 0,
        icon_type TEXT
      )
    ''');

    // Seed initial tasks
    await db.insert('tasks', {
      'title': 'Làm bài tập Flutter',
      'description': 'Hoàn thành trước thứ Sáu',
      'is_completed': 0,
      'icon_type': 'laptop',
    });
    await db.insert('tasks', {
      'title': 'Ôn tập Riverpod',
      'description': 'Xem lại bài giảng MVVM',
      'is_completed': 0,
      'icon_type': 'book',
    });
    await db.insert('tasks', {
      'title': 'Chuẩn bị bài thuyết trình',
      'description': 'Nhóm 4 - Chủ đề Firebase',
      'is_completed': 0,
      'icon_type': 'presentation',
    });
    await db.insert('tasks', {
      'title': 'Viết báo cáo môn học',
      'description': 'Nộp trên LMS',
      'is_completed': 0,
      'icon_type': 'document',
    });
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id ASC');
    return result.map((json) => TaskModel.fromMap(json)).toList();
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
