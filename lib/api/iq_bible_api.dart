import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:se_bible_project/env/env.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import '../models/lexicon.dart';

const _apiKey = Env.key1;
const _apiHost = 'iq-bible.p.rapidapi.com';

class BibleApi {
  /// get method. Provide query starting with slash.
  /// ex. /GetBooks?language=english
  Future<Response> _get(String query) {
    log(query, name: 'RAPID-API CALL');
    final response = http.get(
      Uri.parse('https://iq-bible.p.rapidapi.com$query'),
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': _apiHost,
      },
    );
    return response;
  }

  Future<List<Book>> getBooks() async {
    final response = await _get('/GetBooks?language=english');
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<List<Book>> getNTBooks() async {
    final response = await _get('/GetBooksNT?language=english');
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<List<Book>> getOTBooks() async {
    final response = await _get('/GetBooksOT?language=english');
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<Chapter> getChapter(int bookId, int chapterId) async {
    final response = await _get(
        '/GetChapter?bookId=$bookId&chapterId=$chapterId&versionId=kjv');
    final json = jsonDecode(response.body);
    final verses = <Verse>[];
    for (final verse in json) {
      verses.add(Verse.fromJson(verse));
    }
    return Chapter(
      currentBook: bookId,
      currentChapter: chapterId,
      verses: verses,
    );
  }

  Future<int> getChapterCount(int bookId) async {
    final response = await _get('/GetChapterCount?bookId=$bookId');
    return jsonDecode(response.body)['chapterCount'] as int;
  }

  Future<int> getVerseCount(int bookId, int chapterId) async {
    final response =
        await _get('/GetVerseCount?bookId=$bookId&chapterId=$chapterId');
    return jsonDecode(response.body)['verseCount'] as int;
  }

  Future<List<Lexicon>> getConcordance(String verseId) async {
    final response = await _get('/GetOriginalText?verseId=$verseId');
    final json = jsonDecode(response.body);
    log(response.body);
    final lexicons = <Lexicon>[];
    for (final lexicon in json) {
      lexicons.add(Lexicon.fromJson(lexicon));
    }
    return lexicons;
  }

}

final bibleApiProvider = Provider((ref) {
  return BibleApi();
});
