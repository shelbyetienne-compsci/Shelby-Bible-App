import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseSchema<T> {
  Future<int> insert(T data);

  Future<List<T>?> read();

  Future<T?> get({
    required String whereArg,
  });

  Future<int> delete({required String whereArg});
}

class DatabaseManager {
  static const int _version = 1;
  static const String _dbName = 'study_bible.db';

  static Future<Database> initDb({
    FutureOr<void> Function(Database, int)? onCreate,
  }) async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: onCreate,
      version: _version,
    );
  }
}

final initialDatabaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('You must override initialDatabaseProvider');
});
