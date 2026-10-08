import 'dart:convert';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retis/connections/models/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'connections';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDetails = 'details';
  static const columnIntervalInDays = 'intervalInDays';
  static const columnLastContactedDate = 'lastContactedDate';

  static List<String> get columns => [
        columnId,
        columnName,
        columnDetails,
        columnIntervalInDays,
        columnLastContactedDate
      ];

  DatabaseRepository._privateConstructor();
  static final DatabaseRepository instance =
      DatabaseRepository._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDetails TEXT NOT NULL,
            $columnIntervalInDays INTEGER NOT NULL,
            $columnLastContactedDate INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insertConnection(Connection connection) async {
    Database db = await instance.database;
    int id = await db.insert(
      table,
      connection.toMap(includeId: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final prefs = await SharedPreferences.getInstance();
    final connections = await queryAllConnections();
    prefs.setString(
      'connections',
      jsonEncode(connections.map((c) => c.toMap()).toList()),
    );

    return id;
  }

  Future<List<Connection>> queryAllConnections() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((map) => Connection.fromMap(map)).toList();
  }

  Future<Connection?> queryConnectionById(int id) async {
    final db = await database;
    final maps = await db.query(
      table,
      columns: [
        columnId,
        columnName,
        columnDetails,
        columnIntervalInDays,
        columnLastContactedDate
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Connection.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateConnection(Connection connection) async {
    Database db = await instance.database;
    int id = await db.update(
      table,
      connection.toMap(),
      where: 'id = ?',
      whereArgs: [connection.id],
    );

    final prefs = await SharedPreferences.getInstance();
    final connections = await queryAllConnections();
    prefs.setString(
      'connections',
      jsonEncode(connections.map((c) => c.toMap()).toList()),
    );

    return id;
  }

  Future<int> deleteConnection(int id) async {
    Database db = await instance.database;
    final int deletedId = await db.delete(table, where: 'id = ?', whereArgs: [id]);

    final prefs = await SharedPreferences.getInstance();
    final connections = await queryAllConnections();
    prefs.setString(
      'connections',
      jsonEncode(connections.map((c) => c.toMap()).toList()),
    );

    return deletedId;
  }

  Future<void> dropDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
  }
}
