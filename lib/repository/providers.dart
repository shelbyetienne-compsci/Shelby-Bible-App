import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/chapter_controller.dart';
import '../databases/note_db.dart';
import '../models/book.dart';
import '../models/chapter.dart';
import '../models/verse.dart';
import 'iq_bible_repository.dart';

final chaptersProvider =
    FutureProvider.family.autoDispose<Chapter, ChapterInfo>((ref, info) async {
  final bibleProvider = ref.read(bibleRepository);
  final chapter =
      bibleProvider.getChapter(info.bookNumber + 1, info.chapterNumber);
  return chapter;
});

final booksProvider = FutureProvider.autoDispose
    .family<List<Book>, Testaments>((ref, testament) async {
  final bibleProvider = ref.read(bibleRepository);
  switch (testament) {
    case Testaments.newTestament:
      return bibleProvider.getNTBooks();
    case Testaments.oldTestament:
      return bibleProvider.getOTBooks();
    case Testaments.allBooks:
      return bibleProvider.getBooks();
  }
});

final totalChaptersProvider =
    FutureProvider.autoDispose.family<int, int>((ref, bookNumber) async {
  return ref.read(bibleRepository).getChapterCount(bookNumber);
});

final currentNote =
    FutureProvider.autoDispose.family<Notes?, Notes?>((ref, note) async {
  if (note == null) {
    final all = await ref.read(notesTableProvider).read();
    return all?.first;
  }
  return note;
});

final copiedVersesProvider =
    Provider.autoDispose.family<String, Set<Verse>>((ref, verses) {
  final chapterState =
      ref.watch(chapterStateNotifierProvider(Testaments.allBooks));
  StringBuffer copy = StringBuffer();
  copy.write("\"");
  for (int i = 0; i < verses.length - 1; i++) {
    copy.write("${verses.elementAt(i).text} ");
  }
  copy.write(verses.elementAt(verses.length - 1).text);
  copy.write("\" ");
  if (verses.length == 1) {
    copy.writeln(
        "${chapterState.books[chapterState.currentBook].name} ${chapterState.currentChapter}:${verses.elementAt(0).verseNumber}");
  } else {
    copy.writeln(
        "${chapterState.books[chapterState.currentBook].name} ${chapterState.currentChapter}:${verses.elementAt(0).verseNumber}-${verses.elementAt(verses.length - 1).verseNumber}");
  }
  return copy.toString();
});
