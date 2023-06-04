import 'package:flutter/cupertino.dart';

@immutable
class Book {
  final String name;
  final String bookId;

  const Book({required this.name, required this.bookId});

  factory Book.fromJson(dynamic json) {
    return Book(
      name: json['n'] as String,
      bookId: json['b'] as String,
    );
  }

  @override
  String toString() {
    return 'Book {name: $name, bookId: $bookId}';
  }
}

enum Testaments {
  newTestament,
  oldTestament,
  allBooks,
}
