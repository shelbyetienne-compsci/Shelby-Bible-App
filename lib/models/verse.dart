import 'package:flutter/cupertino.dart';

@immutable
class Verse {
  final String id;
  final String bookId;
  final String chapter;
  final String verseNumber;
  final String text;

  const Verse({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verseNumber,
    required this.text,
  });

  factory Verse.fromJson(dynamic json) {
    return Verse(
      id: json['id'] as String,
      bookId: json['b'] as String,
      chapter: json['c'] as String,
      verseNumber: json['v'] as String,
      text: json['t'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'b': bookId,
        'c': chapter,
        'v': verseNumber,
        't': text,
      };

  @override
  String toString() {
    return 'Verse {id: $id, bookId: $bookId, chapter: $chapter, verse: $verseNumber, text: $text}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Verse &&
          runtimeType == other.runtimeType &&
          verseNumber == other.verseNumber;

  @override
  int get hashCode => verseNumber.hashCode;
}
