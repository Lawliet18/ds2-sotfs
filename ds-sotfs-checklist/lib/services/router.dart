import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/app/app.dart';
import '../pages/playthrough/playthrough.dart';
import '../pages/playthrough/playthrough_cubit.dart';
import '../pages/task/task.dart';
import '../pages/task/task_cubit.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const InitialPage(),
        );
      case '/playthrough':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PlaythroughCubit(ChecklistPages.playthrough),
            child: const PlaythroughChecklist(),
          ),
        );
      case '/achievement':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PlaythroughCubit(ChecklistPages.achievement),
            child: const PlaythroughChecklist(),
          ),
        );
      case '/task':
        final args = settings.arguments! as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => TaskCubit(
                args['name'] as String, args['page'] as ChecklistPages),
            child: DisplayTasks(checklistName: args['name'] as String),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
