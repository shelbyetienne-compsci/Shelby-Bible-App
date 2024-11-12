import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/models/chapter.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/verse.dart';
import 'download_bible.dart';

class ChapterTable {
  final Database db;

  ChapterTable(this.db);

  Future<Chapter?> get(int book, int chapter) async {
    final maps = await db.query(
      'verses',
      where: 'b = ? AND c = ?',
      whereArgs: [
        book,
        chapter,
      ],
      orderBy: 'v',
    );
    final verses = <Verse>[];
    for (final verse in maps) {
      verses.add(
        Verse(
          id: verse['id'].toString(),
          bookId: verse['b'].toString(),
          chapter: verse['c'].toString(),
          verseNumber: verse['v'].toString(),
          text: verse['t'] as String,
        ),
      );
    }
    if (maps.isEmpty) return null;
    return Chapter(
      currentBook: book,
      currentChapter: chapter,
      verses: verses,
    );
  }
}

final chapterTableProvider = FutureProvider<ChapterTable>(
  (ref) async {
    final offlineDB = await OfflineDatabaseManager.initOfflineDb();
    return ChapterTable(
      offlineDB,
    );
  },
);
