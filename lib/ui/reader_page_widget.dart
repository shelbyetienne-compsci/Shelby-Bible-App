import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/chapter_controller.dart';
import 'package:se_bible_project/ui/book_button_widget.dart';
import 'package:se_bible_project/ui/reader_list_widget.dart';

import '../models/book.dart';

class BibleReaderPageWidget extends ConsumerStatefulWidget {
  const BibleReaderPageWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<BibleReaderPageWidget> createState() => _BibleReaderPageState();
}

class _BibleReaderPageState extends ConsumerState<BibleReaderPageWidget> {
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
    final chapterController = ref.read(chapterStateNotifierProvider(Testaments.allBooks).notifier);
    return Scaffold(
      appBar: AppBar(
        title: const BookButtonWidget(),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) async {
          await chapterController.swipes(details);
        },
        child: BibleReaderListWidget(
          chapterState: chapterState,
        ),
      ),
    );
  }
}
