import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseSchema<T> {
  Future<int> insert(T data);

  Future<List<T>?> read();

  Future<int> update(
    T data, {
    String? where,
    List<dynamic>? whereArgs,
  });

  Future<int> delete({required String where, required List<dynamic> whereArgs});
}

class DatabaseManager {
  static const int _version = 1;
  static const String _dbName = 'study_bible.db';

  static Future<Database> _getDb({
    FutureOr<void> Function(Database, int)? onCreate,
  }) async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: onCreate,
      version: _version,
    );
  }
}

final databaseManagerProvider = FutureProvider<Database>(
  (ref) async => DatabaseManager._getDb(
    onCreate: (db, version) {

    },
  ),
);
