import 'package:se_bible_project/databases/database.dart';
import 'package:sqflite/sqflite.dart';

import '../controllers/verse_action_controller.dart';

class HighlightTable implements DatabaseSchema<VerseActionState> {
  final String _tableName = 'Highlights';
  final Database _db;

  const HighlightTable(this._db);

  @override
  Future<int> insert(VerseActionState data) {
    return _db.insert(_tableName, data.toJson());
  }

  @override
  Future<List<VerseActionState>?> read() async {
    final maps = await _db.query(_tableName);
    if (maps.isEmpty) return null;
    return List.generate(
      maps.length,
      (index) => VerseActionState.fromJson(
        maps[index],
      ),
    );
  }

  @override
  Future<int> update(
    VerseActionState data, {
    String? where = 'verseId = ?',
    List? whereArgs,
  }) {
    return _db.update(
      _tableName,
      data.toJson(),
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> delete({String where = 'verseId = ?', required List whereArgs}) {
    return _db.delete(_tableName, where: where, whereArgs: whereArgs);
  }
}
