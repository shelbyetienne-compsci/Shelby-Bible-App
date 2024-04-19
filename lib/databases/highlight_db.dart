import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

const String _kHighlightsDB = 'Highlights';
const String _kVerseId = 'verseId';
const String _kHighlightColor = 'highlightColor';

void registerHighlightSchema(Database db) async {
  await db.execute(
      'CREATE TABLE $_kHighlightsDB ($_kVerseId TEXT PRIMARY KEY, $_kHighlightColor INTEGER NOT NULL);');
}

class Highlights {
  final String verseId;
  final Color? highlightColor;

  Highlights({
    required this.verseId,
    this.highlightColor,
  });

  factory Highlights.fromJson(dynamic json) {
    return Highlights(
      highlightColor: Color(
        json[_kHighlightColor] as int,
      ),
      verseId: json[_kVerseId] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        _kHighlightColor: highlightColor?.value,
        _kVerseId: verseId,
      };
}

class HighlightTable implements DatabaseSchema<Highlights> {
  final Database _db;

  const HighlightTable(this._db);

  @override
  Future<int> insert(Highlights data) {
    return _db.insert(
      _kHighlightsDB,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Highlights>?> read() async {
    final maps = await _db.query(_kHighlightsDB);
    if (maps.isEmpty) return null;
    return List.generate(
      maps.length,
      (index) => Highlights.fromJson(
        maps[index],
      ),
    );
  }

  @override
  Future<int> delete({
    required String whereArg,
  }) {
    return _db.delete(
      _kHighlightsDB,
      where: '$_kVerseId = ?',
      whereArgs: [
        whereArg,
      ],
    );
  }

  @override
  Future<Highlights?> get({required String whereArg}) async {
    final maps = await _db.query(
      _kHighlightsDB,
      where: '$_kVerseId = ?',
      whereArgs: [
        whereArg,
      ],
    );
    if (maps.isEmpty) return null;
    return Highlights.fromJson(
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
