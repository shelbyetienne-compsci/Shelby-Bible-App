import 'package:flutter/cupertino.dart';
import 'package:se_bible_project/models/verse.dart';

@immutable
class Chapter {
  final int bookId;
  final int chapterId;
  final List<Verse> verses;

  const Chapter({
    required this.bookId,
    required this.chapterId,
    required this.verses,
  });
}

class ChapterInfo {
  final int bookId;
  final int chapterId;

  ChapterInfo(this.bookId, this.chapterId);
}
