import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/page_filter_controller.dart';
import 'package:se_bible_project/ui/book_button_widget.dart';

class StudyTopBarWidget extends ConsumerWidget {
  const StudyTopBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(readerAndNoteFilterProvider);
    final controller = ref.read(readerAndNoteFilterProvider.notifier);
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filters.items.map((item) {
        if (item.runtimeType == ReaderItem) {
          return BookButtonWidget(
            selectFilter: item.id != filters.selected?.id
                ? () {
                    controller.selectItem(item);
                  }
                : null,
            isSelected: item.id == filters.selected?.id,
          );
        } else {
          return TextButton(
            onPressed: () {
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              controller.selectItem(item);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                item.id == filters.selected?.id
                    ? Colors.black.withOpacity(0.8)
                    : bgColor,
              ),
            ),
            child: Text(
              'Notes',
              style: TextStyle(
                color: item.id == filters.selected?.id
                    ? bgColor
                    : Colors.black,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
