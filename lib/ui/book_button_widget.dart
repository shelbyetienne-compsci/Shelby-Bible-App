import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/models/book.dart';
import 'package:se_bible_project/ui/chapter_selecting_widgets.dart';

class BookButtonWidget extends ConsumerWidget {
  final bool isSelected;
  final Function()? selectFilter;

  const BookButtonWidget({
    required this.isSelected,
    this.selectFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterState =
        ref.watch(chapterStateNotifierProvider(Testaments.allBooks));
    return TextButton(
      onPressed: selectFilter ??
          () {
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
          isSelected ? Colors.black.withOpacity(0.8) : Colors.white,
        ),
      ),
      child: Text(
        chapterState.books.isEmpty
            ? '--'
            : chapterState.books[chapterState.currentBook].name,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
