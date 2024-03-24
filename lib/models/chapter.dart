import 'package:flutter/cupertino.dart';
import 'package:se_bible_project/models/verse.dart';

@immutable
class Chapter {
  final int currentBook;
  final int currentChapter;
  final List<Verse> verses;

  const Chapter({
    required this.currentBook,
    required this.currentChapter,
    required this.verses,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chapter &&
          runtimeType == other.runtimeType &&
          verses == other.verses;

  @override
  int get hashCode => verses.hashCode;
}

@immutable
class ChapterInfo {
  final int bookNumber;
  final int chapterNumber;

  const ChapterInfo(this.bookNumber, this.chapterNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterInfo &&
          runtimeType == other.runtimeType &&
          bookNumber == other.bookNumber &&
          chapterNumber == other.chapterNumber;

  @override
  int get hashCode => bookNumber.hashCode ^ chapterNumber.hashCode;
}
