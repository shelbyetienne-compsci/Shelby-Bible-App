import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';
import '../models/chapter.dart';
import '../models/verse.dart';


const _apiKey = '248b04362bmsh8c422f05d65472dp1dd801jsn4cd7ff844c4a';
const _apiHost = 'iq-bible.p.rapidapi.com';
const _url = 'https://iq-bible.p.rapidapi.com';

class BibleApi {
  Future<List<Book>> getBooks() async {
    final url = Uri.parse('$_url/GetBooks?language=english');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<List<Book>> getNTBooks() async {
    final url = Uri.parse('$_url/GetBooksNT?language=english');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<List<Book>> getOTBooks() async {
    final url = Uri.parse('$_url/GetBooksOT?language=english');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    final json = jsonDecode(response.body);
    final books = <Book>[];
    for (final book in json) {
      books.add(Book.fromJson(book));
    }
    return books;
  }

  Future<Chapter> getChapter(int bookId, int chapterId) async {
    final url = Uri.parse(
        '$_url/GetChapter?bookId=$bookId&chapterId=$chapterId&versionId=kjv');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    final json = jsonDecode(response.body);
    final verses = <Verse>[];
    for (final verse in json) {
      verses.add(Verse.fromJson(verse));
    }
    return Chapter(bookId: bookId, chapterId: chapterId, verses: verses);
  }

  Future<int> getChapterCount(int bookId) async {
    final url = Uri.parse('$_url/GetChapterCount?bookId=$bookId');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    return jsonDecode(response.body)['chapterCount'];
  }

  Future<int> getVerseCount(int bookId, int chapterId) async {
    final url =
        Uri.parse('$_url/GetVerseCount?bookId=$bookId&chapterId=$chapterId');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    return jsonDecode(response.body)['verseCount'];
  }
}

final bibleApiProvider = Provider.autoDispose((ref) {
  return BibleApi();
});
