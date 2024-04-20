import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/helper.dart';

abstract class FilterItem {
  final String id;

  const FilterItem({required this.id});
}

class ReaderItem extends FilterItem {
  const ReaderItem({super.id = 'reader'});
}

class NoteItem extends FilterItem {
  const NoteItem({super.id = 'notes'});
}

const List<FilterItem> _items = [ReaderItem(), NoteItem()];

class ReaderAndNoteFilterState extends State {
  final List<FilterItem> items;
  final FilterItem? selected;

  ReaderAndNoteFilterState({
    required this.items,
    this.selected,
  });

  ReaderAndNoteFilterState copyWith({FilterItem? selected}) =>
      ReaderAndNoteFilterState(
        items: items,
        selected: selected ?? this.selected,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderAndNoteFilterState &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          selected == other.selected;

  @override
  int get hashCode => items.hashCode ^ selected.hashCode;
}

class ReaderAndNoteFilterController
    extends Controller<ReaderAndNoteFilterState> {
  ReaderAndNoteFilterController(super.state) {
    state = state.copyWith(selected: _items.first);
  }

  void selectItem(FilterItem item) {
    state = state.copyWith(selected: item);
  }
}

final readerAndNoteFilterProvider = StateNotifierProvider<
    ReaderAndNoteFilterController, ReaderAndNoteFilterState>(
  (ref) => ReaderAndNoteFilterController(
    ReaderAndNoteFilterState(items: _items),
  ),
);
