import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/databases/note_db.dart';
import 'package:intl/intl.dart';

class EditNoteWidget extends ConsumerStatefulWidget {
  final Notes? note;

  const EditNoteWidget({this.note, super.key});

  @override
  ConsumerState<EditNoteWidget> createState() => _EditNoteWidgetState();
}

class _EditNoteWidgetState extends ConsumerState<EditNoteWidget> {
  late Notes currentNote;
  final title = TextEditingController();
  final body = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      currentNote = widget.note!;
      title.text = currentNote.title;
      body.text = currentNote.body;
    } else {
      //initialize empty note
      currentNote = Notes(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title.text,
        body: body.text,
        lastUpdated: DateTime.now(),
      );
      ref.read(notesTableProvider).insert(currentNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesDB = ref.read(notesTableProvider);
    final date =
        DateFormat("MMMM d, yyyy 'at' hh:mma").format(currentNote.lastUpdated);
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              date,
            ),
          ),
          TextField(
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
            ),
            controller: title,
            maxLines: 1,
            onChanged: (text) {
              notesDB.update(
                Notes(
                  id: currentNote.id,
                  title: text,
                  body: body.text,
                  lastUpdated: DateTime.now(),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(hintText: 'Enter notes...'),
              controller: body,
              expands: true,
              maxLines: null,
              onChanged: (text) {
                notesDB.update(
                  Notes(
                    id: currentNote.id,
                    title: title.text,
                    body: text,
                    lastUpdated: DateTime.now(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
