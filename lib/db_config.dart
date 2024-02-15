import 'dart:developer';

import 'package:sqflite/sqflite.dart';

class DBConfig {
  static String tableName = "movie";

  Future<Database> init() async {
    final dbConfig = await openDatabase(
      "${getDatabasesPath()}/movie_db.db",
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, director TEXT, summary TEXT,genres TEXT, thumbnail TEXT)',
        );
      },
      onOpen: (db) {
        log("Open Database");
      },
      version: 1,
    );
    return dbConfig;
  }
}
