import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cybercheck/model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id TEXT PRIMARY KEY,
        todoText TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future<void> insertToDo(ToDo todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ToDo>> todos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        todoText: maps[i]['todoText'],
        isDone: maps[i]['isDone'] == 1,
      );
    });
  }

  Future<void> updateToDo(ToDo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteToDo(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
