import 'package:flutter/cupertino.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper.dart';
import '../models/book.dart';

import '../repository/providers.dart';

@immutable
class ChapterState extends State {
  final int currentBook;
  final int currentChapter;
  final int chapters;
  final List<Book> books;

  ChapterState({
    required this.currentBook,
    required this.currentChapter,
    required this.chapters,
    required this.books,
  });

  ChapterState copyWith({
    int? currentBook,
    int? currentChapter,
    int? chapters,
    List<Book>? books,
  }) =>
      ChapterState(
        currentBook: currentBook ?? this.currentBook,
        currentChapter: currentChapter ?? this.currentChapter,
        chapters: chapters ?? this.chapters,
        books: books ?? this.books,
      );
}

class ChapterStateController extends Controller<ChapterState> {
  final Ref ref;
  final Testaments testaments;

  ChapterStateController(this.ref, this.testaments, super.state);

  Future<void> setChapter(int chapter) async {
    if (!mounted) return;
    state = state.copyWith(currentChapter: chapter);
  }

  Future<void> setBook(int book) async {
    if (!mounted) return;
    state = state.copyWith(
        currentBook: book - 1, chapters: await _fetchChapters(book));
  }

  Future<int?> _fetchChapters(int bookId) async {
    final bookChapters = ref.read(totalChaptersProvider(bookId)).asData?.value;
    return bookChapters;
  }

  Future<void> swipes(DragEndDetails details) async {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      // Right Swipe
      if (state.currentBook == 0 && state.currentChapter == 1) {
        return;
      } else if (state.currentBook > 0 && state.currentChapter == 1) {
        final bookChapters =
            ref.read(totalChaptersProvider(state.currentBook)).asData?.value;
        if (!mounted) return;
        state = state.copyWith(
          currentBook: state.currentBook - 1,
          currentChapter: bookChapters,
          chapters: await _fetchChapters(state.currentBook - 1),
        );
      } else {
        state = state.copyWith(currentChapter: state.currentChapter - 1);
      }
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      //Left Swipe
      if (state.currentBook == state.books.length - 1 &&
          state.currentChapter == state.chapters) {
        return;
      } else if (state.currentBook < state.books.length &&
          state.currentChapter == state.chapters) {
        if (!mounted) return;
        state = state.copyWith(
          currentBook: state.currentBook + 1,
          currentChapter: 1,
          chapters: await _fetchChapters(state.currentBook + 1),
        );
      } else {
        state = state.copyWith(currentChapter: state.currentChapter + 1);
      }
    }
  }
}

final initialChapterState = Provider.autoDispose<ChapterState>((ref) {
  final books = ref.watch(booksProvider(Testaments.allBooks)).asData?.value;
  if (books != null) {
    final firstBook = books.first;
    final initialBookChapters =
        ref.watch(totalChaptersProvider(firstBook.bookNumber)).asData?.value;
    return ChapterState(
      currentBook: firstBook.bookNumber - 1,
      currentChapter: 1,
      chapters: initialBookChapters ?? 0,
      books: books,
    );
  } else {
    return ChapterState(
      currentBook: -1,
      currentChapter: -1,
      chapters: 0,
      books: const [],
    );
  }
});

final chapterStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChapterStateController, ChapterState, Testaments>(
        (ref, testament) {
  final initState = ref.watch(initialChapterState);
  return ChapterStateController(
    ref,
    testament,
    initState,
  );
});
