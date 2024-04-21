import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/controllers/page_filter_controller.dart';
import 'package:se_bible_project/ui/edit_note_widget.dart';
import 'package:se_bible_project/ui/notes_page_widget.dart';
import 'package:se_bible_project/ui/reader_page_widget.dart';
import 'package:se_bible_project/ui/study_topbar_widget.dart';

import '../databases/note_db.dart';

class StudyPageWidget extends ConsumerStatefulWidget {
  const StudyPageWidget({super.key});

  @override
  ConsumerState<StudyPageWidget> createState() => _StudyPageWidget();
}

class _StudyPageWidget extends ConsumerState<StudyPageWidget> {
  @override
  Widget build(BuildContext context) {
    final currentItem = ref.watch(readerAndNoteFilterProvider);
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: StudyTopBarWidget(),
        ),
        centerTitle: true,
        leading: const SizedBox.shrink(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                bgColor,
                bgColor.withOpacity(0),
              ],
              stops: const [0.9, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        forceMaterialTransparency: true,
        actions: [
          if (currentItem.selected.runtimeType == NoteItem)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AllNotesButtonWidget(
                onPressed: () {
                  setState(() {});
                },
              ),
            )
          else
            const SizedBox(
              width: 50,
            )
        ],
      ),
      body: currentItem.selected.runtimeType == ReaderItem
          ? const BibleReaderWidget()
          : FutureBuilder<List<Notes>?>(
              future: ref.watch(notesTableProvider).read(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Notes>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return EditNoteWidget(
                    note: snapshot.data?.first,
                  );
                }
              },
            ),
    );
  }
}
