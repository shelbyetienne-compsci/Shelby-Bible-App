import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/databases/database.dart';
import 'package:se_bible_project/routes.dart';
import 'package:se_bible_project/ui/reader_page_widget.dart';

import 'databases/highlight_db.dart';

void main(List<String> args) async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final initializeDB = await DatabaseManager.initDb(
      onCreate: (db, version) async {
        registerHighlightSchema(db);
      },
    );
    runApp(
      ProviderScope(
        overrides: [
          initialDatabaseProvider.overrideWithValue(initializeDB),
        ],
        child: const MyApp(),
      ),
    );
  }, (_, __) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routerConfig: router,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const BibleReaderPageWidget();
  }
}
