import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseSchema<T> {
  final Database db;

  const DatabaseSchema(this.db);

  Future<int> insert(T data);

  Future<int> update(T data);

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
    final dir = await getApplicationDocumentsDirectory();
    return openDatabase(
      join(dir.path, _dbName),
      onCreate: onCreate,
      version: _version,
    );
  }
}

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('You must override initialDatabaseProvider');
});

final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must override preferencesProvider');
});
