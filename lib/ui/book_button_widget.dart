import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/models/book.dart';
import 'package:se_bible_project/ui/chapter_selecting_widgets.dart';

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
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          constraints: const BoxConstraints(maxWidth: 500),
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.32,
            initialChildSize: 0.48,
            maxChildSize: 0.72,
            builder: (context, controller) {
              return ChapterSelectorWidget(controller: controller);
            },
          ),
        );
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
