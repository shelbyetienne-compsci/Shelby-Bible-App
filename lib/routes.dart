import 'package:go_router/go_router.dart';
import 'package:se_bible_project/ui/study_page_widget.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'reader',
      path: '/',
      builder: (context, state) => const StudyPageWidget(),
    ),
  ],
);
