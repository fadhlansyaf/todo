import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String todoTable = 'Todo';

class DatabaseProvider{
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }else {
      _database = await createDatabase();
      return _database!;
    }
  }

  createDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    Database database = await openDatabase(path, version: 1, onCreate: onCreate, onUpgrade: onUpgrade);
    return database;
  }


  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  Future<void> onCreate(Database db, int version) async {
    Batch batch = db.batch();
    for (var script in initScript) {
      batch.execute(script);
    }
    await batch.commit(noResult: true);
  }

  List<String> initScript = [
    'CREATE TABLE Todo ('
        'PID INTEGER PRIMARY KEY,'
        'ID INTEGER,'
        'SUBJECT TEXT,'
        'DESC TEXT,'
        'DATE TEXT,'
        'TIME TEXT'
        ')',
  ];
}