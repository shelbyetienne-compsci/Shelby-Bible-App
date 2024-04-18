import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../controllers/verse_action_controller.dart';
import 'database.dart';

const String _kHighlightsDB = 'Highlights';
const String _kVerseId = 'verseId';
const String _kHighlightColor = 'highlightColor';

void registerHighlightSchema(Database db) async {
  await db.execute(
      'CREATE TABLE $_kHighlightsDB ($_kVerseId TEXT PRIMARY KEY, $_kHighlightColor INTEGER NOT NULL);');
}

class HighlightTable implements DatabaseSchema<VerseActionState> {
  final Database _db;

  const HighlightTable(this._db);

  @override
  Future<int> insert(VerseActionState data) {
    return _db.insert(
      _kHighlightsDB,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<VerseActionState>?> read() async {
    final maps = await _db.query(_kHighlightsDB);
    if (maps.isEmpty) return null;
    return List.generate(
      maps.length,
      (index) => VerseActionState.fromJson(
        maps[index],
      ),
    );
  }

  @override
  Future<int> delete({
    required String verseId,
  }) {
    return _db.delete(
      _kHighlightsDB,
      where: '$_kVerseId = ?',
      whereArgs: [
        verseId,
      ],
    );
  }

  @override
  Future<VerseActionState?> get({required String verseId}) async {
    final maps = await _db.query(
      _kHighlightsDB,
      where: '$_kVerseId = ?',
      whereArgs: [
        verseId,
      ],
    );
    if (maps.isEmpty) return null;
    return VerseActionState.fromJson(
      maps.first,
    );
  }
}

final highlightTableProvider = Provider<HighlightTable>(
  (ref) {
    return HighlightTable(
      ref.read(initialDatabaseProvider),
    );
  },
);
