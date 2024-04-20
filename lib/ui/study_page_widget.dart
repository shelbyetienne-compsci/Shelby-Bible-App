import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/page_filter_controller.dart';
import 'package:se_bible_project/ui/edit_note_widget.dart';
import 'package:se_bible_project/ui/reader_page_widget.dart';
import 'package:se_bible_project/ui/study_topbar_widget.dart';

import '../databases/note_db.dart';

class StudyPageWidget extends ConsumerWidget {
  const StudyPageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(readerAndNoteFilterProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const StudyTopBarWidget(),
      body: currentItem.selected.runtimeType == ReaderItem
          ? const BibleReaderWidget()
          : FutureBuilder<List<Notes>?>(
              future: ref.read(notesTableProvider).read(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Notes>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return EditNoteWidget(
                    note: snapshot.data?.last,
                  );
                }
              },
            ),
    );
  }
}
