import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class State<S> {
}

class Controller<S extends State> extends StateNotifier<S> {
  Controller(super.state);
}
