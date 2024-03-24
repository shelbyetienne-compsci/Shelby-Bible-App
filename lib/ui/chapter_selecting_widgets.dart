import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/chapter_controller.dart';
import '../models/book.dart';
import '../repository/providers.dart';

class ChapterSelectorWidget extends ConsumerStatefulWidget {
  final ScrollController controller;

  const ChapterSelectorWidget({required this.controller, super.key});

  @override
  ConsumerState<ChapterSelectorWidget> createState() =>
      _ChapterSelectorWidgetState();
}

class _ChapterSelectorWidgetState extends ConsumerState<ChapterSelectorWidget> {
  int selectedBook = -1;

  @override
  Widget build(BuildContext context) {
    final chapterState =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks));
    if (selectedBook == -1) {
      return ListView.builder(
          controller: widget.controller,
          itemCount: chapterState.books.length,
          itemBuilder: (context, index) {
            final book = chapterState.books[index];
            return ListTile(
              title: Text(
                book.name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedBook = book.bookNumber;
                });
              },
            );
          });
    } else {
      return SpecificChapterSelectionWidget(
        currentBook: selectedBook,
        goBackFunction: () {
          setState(() {
            selectedBook = -1;
          });
        },
        controller: widget.controller,
      );
    }
  }
}

class SpecificChapterSelectionWidget extends ConsumerWidget {
  final int currentBook;
  final Function() goBackFunction;
  final ScrollController controller;

  const SpecificChapterSelectionWidget({
    required this.currentBook,
    required this.goBackFunction,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chpts = ref.watch(totalChaptersProvider(currentBook)).asData?.value;
    if (chpts == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
      );
    }
    final chapterController =
        ref.read(chapterStateNotifierProvider(Testaments.allBooks).notifier);
    final chapterButtons = List.generate(
      chpts,
      (chapter) {
        final chpt = chapter + 1;
        return TextButton(
          onPressed: () async {
            await chapterController.setBook(currentBook);
            await chapterController.setChapter(chpt);
          },
          child: Text(
            chpt.toString(),
          ),
        );
      },
    );
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: goBackFunction,
              child: const Text('back'),
            ),
          ),
          Wrap(
            children: chapterButtons,
          ),
        ],
      ),
    );
  }
}
