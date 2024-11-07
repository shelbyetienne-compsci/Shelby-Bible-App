import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../databases/note_db.dart';

class AllNotesButtonWidget extends ConsumerWidget {
  final Function() onPressed;

  const AllNotesButtonWidget({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (context) {
            return DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.48,
              initialChildSize: 0.48,
              maxChildSize: 0.72,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return NotesPageWidget(
                  controller: scrollController,
                  onPressed: onPressed,
                );
              },
            );
          },
        );
      },
      child: const Text('All'),
    );
  }
}

class NotesPageWidget extends ConsumerWidget {
  final ScrollController controller;
  final Function() onPressed;

  const NotesPageWidget(
      {required this.controller, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        FutureBuilder<List<Notes>?>(
          future: ref.read(notesTableProvider).read(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Notes>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (snapshot.data == null) {
                return const Center(
                  child: Text('No notes to display'),
                );
              }
              return ListView.builder(
                controller: controller,
                itemBuilder: (context, index) {
                  return NotesItemWidget(
                    width: MediaQuery.of(context).size.width,
                    height: 64,
                    note: snapshot.data![index],
                    lastItem: index == (snapshot.data!.length - 1),
                    onPressed: onPressed,
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 24,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.black.withOpacity(0.8),
                ),
              ),
              onPressed: () async {
                final notes = ref.read(notesTableProvider);
                final empty = await notes.findEmpty();
                if (empty != null) {
                  ref.read(notesTableProvider).update(
                        Notes(
                          id: empty.id,
                          title: empty.title,
                          body: empty.body,
                          lastUpdated: DateTime.now(),
                        ),
                      );
                } else {
                  ref.read(notesTableProvider).insert(
                        Notes(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: '',
                          body: '',
                          lastUpdated: DateTime.now(),
                        ),
                      );
                }
                onPressed.call();
                if (!context.mounted) return;
                context.pop();
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class NotesItemWidget extends ConsumerWidget {
  final double width;
  final double height;
  final Notes? note;
  final bool lastItem;
  final Function() onPressed;

  const NotesItemWidget({
    super.key,
    required this.width,
    required this.height,
    required this.note,
    required this.lastItem,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return note != null
        ? SizedBox(
            width: width,
            height: height,
            child: InkWell(
              onTap: () {
                ref.read(notesTableProvider).update(
                      Notes(
                        id: note!.id,
                        title: note!.title,
                        body: note!.body,
                        lastUpdated: DateTime.now(),
                      ),
                    );
                onPressed.call();
                context.pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note!.title.isEmpty ? 'No title' : note!.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('MM/dd/yy').format(note!.lastUpdated),
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            note!.body.isEmpty ? 'No body' : note!.body,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    if (!lastItem)
                      const Divider(
                        thickness: 0.1,
                      )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
