import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/api/iq_bible_api.dart';
import 'package:se_bible_project/databases/offline/chapter_db.dart';

import '../databases/offline/download_bible.dart';
import '../models/book.dart';
import '../models/chapter.dart';

class BibleRepository {
  final BibleApi _api;
  final Ref _ref;

  BibleRepository(this._api, this._ref);

  Future<List<Book>> getBooks() async {
    return _api.getBooks();
  }

  Future<List<Book>> getNTBooks() async {
    return _api.getNTBooks();
  }

  Future<List<Book>> getOTBooks() async {
    return _api.getOTBooks();
  }

  Future<Chapter> getChapter(int bookId, int chapterId) async {
    if(OfflineDatabaseManager.kjvIsDownloaded){
      final chapter = await _ref.watch(chapterTableProvider).asData?.value.get(bookId, chapterId);
      if (chapter != null) {
        return chapter;
      }
    }
    return _api.getChapter(bookId, chapterId);
  }

  Future<int> getChapterCount(int bookId) async {
    return _api.getChapterCount(bookId);
  }

  Future<int> getVerseCount(int bookId, int chapterId) async {
    return _api.getVerseCount(bookId, chapterId);
  }
}

final bibleRepository = Provider((ref) {
  final bibleApi = ref.read(bibleApiProvider);
  return BibleRepository(bibleApi, ref);
});
