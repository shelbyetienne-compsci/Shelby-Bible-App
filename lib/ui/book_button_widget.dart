import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/models/book.dart';

class BookButtonWidget extends ConsumerStatefulWidget {
  const BookButtonWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<BookButtonWidget> createState() => _BookButtonWidgetState();
}

class _BookButtonWidgetState extends ConsumerState<BookButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterState =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks));

    final chapterController =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks).notifier);

    return TextButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
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
                        chapterController.setBook(int.parse(book.bookId));
                      },
                    );
                  });
            });
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
        Colors.blue,
      )),
      child: Text(
        chapterState.books.isEmpty
            ? '--'
            : chapterState.books[chapterState.currentBook].name,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
