import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:se_bible_project/databases/database.dart';
import 'package:se_bible_project/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'databases/highlight_db.dart';
import 'databases/note_db.dart';

void main(List<String> args) async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final initializeDB = await DatabaseManager.initDb(
      onCreate: (db, version) async {
        registerHighlightSchema(db);
        registerNotesSchema(db);
      },
    );
    final initializePreferences = await SharedPreferences.getInstance();
    runApp(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(initializeDB),
          preferencesProvider.overrideWithValue(initializePreferences),
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
