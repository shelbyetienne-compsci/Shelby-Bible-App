import 'package:flutter/cupertino.dart';

@immutable
class Book {
  final String name;
  final int bookNumber;

  const Book({required this.name, required this.bookNumber});

  factory Book.fromJson(dynamic json) {
    final numberString = json['b'] as String;
    return Book(
      name: json['n'] as String,
      bookNumber: int.parse(numberString),
    );
  }

  @override
  String toString() {
    return 'Book {name: $name, bookId: $bookNumber}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

enum Testaments {
  newTestament,
  oldTestament,
  allBooks,
}
