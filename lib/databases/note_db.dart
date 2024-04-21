import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/databases/database.dart';
import 'package:sqflite/sqflite.dart';

const String _kNotesDb = 'Notes';

void registerNotesSchema(Database db) async {
  await db.execute(
      'CREATE TABLE $_kNotesDb (id INTEGER PRIMARY KEY, title TEXT NOT NULL, body TEXT NOT NULL, lastUpdated INTEGER NOT NULL);');
}

class Notes {
  final int? id;
  final String title;
  final String body;
  final DateTime lastUpdated;

  Notes({
    this.id,
    required this.title,
    required this.body,
    required this.lastUpdated,
  });

  factory Notes.fromJson(dynamic json) {
    return Notes(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      lastUpdated:
          DateTime.fromMillisecondsSinceEpoch(json['lastUpdated'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notes &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ body.hashCode ^ lastUpdated.hashCode;
}

class NotesTable extends DatabaseSchema<Notes> {
  const NotesTable(super.db);

  @override
  Future<int> delete({required String whereArg}) {
    return db.delete(
      _kNotesDb,
      where: 'id = ?',
      whereArgs: [
        whereArg,
      ],
    );
  }

  @override
  Future<Notes?> get({required String whereArg}) async {
    final maps = await db.query(
      _kNotesDb,
      where: 'id = ?',
      whereArgs: [
        int.parse(whereArg),
      ],
    );

    if (maps.isEmpty) return null;
    return Notes.fromJson(
      maps.first,
    );
  }

  @override
  Future<int> insert(Notes data) {
    return db.insert(
      _kNotesDb,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Notes>?> read() async {
    final maps = await db.query(
      _kNotesDb,
      orderBy: 'lastUpdated DESC',
    );
    if (maps.isEmpty) return null;
    return List.generate(
      maps.length,
      (index) => Notes.fromJson(
        maps[index],
      ),
    );
  }

  Future<Notes?> findEmpty() async {
    final maps = await db.query(
      _kNotesDb,
      where: 'title = ? AND body = ?',
      whereArgs: ['', ''],
    );
    if (maps.isEmpty) return null;
    return Notes.fromJson(
      maps.first,
    );
  }

  @override
  Future<int> update(Notes data) {
    return db.update(
      _kNotesDb,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [
        data.id,
      ],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

final notesTableProvider = Provider<NotesTable>(
  (ref) {
    return NotesTable(
      ref.read(databaseProvider),
    );
  },
);
