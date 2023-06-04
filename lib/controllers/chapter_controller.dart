import 'package:flutter/cupertino.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper.dart';
import '../models/book.dart';
import 'package:se_bible_project/repository/iq_bible_repository.dart';

@immutable
class ChapterState extends State {
  final int currentBook;
  final int currentChapter;
  final List<int> chapters;
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
    List<int>? chapters,
    List<Book>? books,
  }) =>
      ChapterState(
        currentBook: currentBook ?? this.currentBook,
        currentChapter: currentChapter ?? this.currentChapter,
        chapters: chapters ?? this.chapters,
        books: books ?? this.books,
      );
}

class ChapterStateNotifier extends Controller<ChapterState> {
  final Ref ref;
  final Testaments testaments;

  ChapterStateNotifier(this.ref, this.testaments, super.state);

  Future<void> setChapter(int chapter) async {
    if (!mounted) return;
    state = state.copyWith(currentChapter: chapter);
  }

  Future<void> setBook(int book) async {
    if (!mounted) return;
    state = state.copyWith(
        currentBook: book - 1,
        currentChapter: 1,
        chapters: await _fetchChapters(book));
  }

  Future<List<int>> _fetchChapters(int bookId) async {
    final bookChapters = ref.read(chapterCountProvider(bookId)).asData?.value;
    return List.generate(bookChapters ?? 0, (index) => index + 1);
  }
}

final initialChapterState = Provider.autoDispose<ChapterState?>((ref) {
  final books = ref.watch(booksProvider(Testaments.allBooks)).asData?.value;
  if (books != null) {
    final initialBookChapters = ref
        .watch(chapterCountProvider(int.parse(books[0].bookId)))
        .asData
        ?.value;
    final chapters =
        List.generate(initialBookChapters ?? 0, (index) => index + 1);
    return ChapterState(
        currentBook: 0, currentChapter: 1, chapters: chapters, books: books);
  } else {
    return null;
  }
});

final chapterStateNotifierProvider = StateNotifierProvider.family
    .autoDispose<ChapterStateNotifier, ChapterState, Testaments>(
        (ref, testament) {
  final initState = ref.watch(initialChapterState);
  return ChapterStateNotifier(
    ref,
    testament,
    initState ??
        ChapterState(
          currentBook: 1,
          currentChapter: 1,
          chapters: const [],
          books: const [],
        ),
  );
});
