import 'dart:developer';

import 'package:flutter/cupertino.dart';

@immutable
class Lexicon {
  final int id;
  final String verseId;
  final int book;
  final int chapter;
  final int verse;
  final String word;

  //pronun
  final int strongs;
  final String morph;

  const Lexicon({
    required this.id,
    required this.verseId,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.word,
    required this.strongs,
    required this.morph,
  });

  factory Lexicon.fromJson(dynamic json) {
    return Lexicon(
      id: int.parse(json['id'] as String),
      verseId: json['verseID'] as String,
      book: int.parse(json['book'] as String),
      chapter: int.parse(json['chapter'] as String),
      verse: int.parse(json['verse'] as String),
      word: json['word'] as String,
      strongs: int.parse(json['strongs'] as String),
      morph: json['morph'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lexicon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          verseId == other.verseId &&
          book == other.book &&
          chapter == other.chapter &&
          verse == other.verse &&
          word == other.word &&
          strongs == other.strongs &&
          morph == other.morph;

  @override
  int get hashCode =>
      id.hashCode ^
      verseId.hashCode ^
      book.hashCode ^
      chapter.hashCode ^
      verse.hashCode ^
      word.hashCode ^
      strongs.hashCode ^
      morph.hashCode;

  @override
  String toString() {
    return 'Lexicon{id: $id, verseId: $verseId, book: $book, chapter: $chapter, verse: $verse, word: $word, strongs: $strongs, morph: $morph}';
  }
}
