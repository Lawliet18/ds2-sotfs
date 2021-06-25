import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import 'task_cubit.dart';

class DisplayTasks extends StatelessWidget {
  final String playthroughName;
  const DisplayTasks({Key? key, required this.playthroughName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Html(data: playthroughName),
            centerTitle: true,
            actions: [
              PopupMenuButton<Filter>(
                icon: Icon(Icons.filter_alt),
                itemBuilder: (context) {
                  return Filter.values.map(
                    (value) {
                      return PopupMenuItem<Filter>(
                        value: value,
                        mouseCursor: MouseCursor.defer,
                        child: Text(
                          value.toString().toUpperCase(),
                        ),
                      );
                    },
                  ).toList();
                },
                onSelected: (filter) =>
                    context.read<TaskCubit>().filter(filter),
              )
            ],
          ),
          body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: state.tasks[index].isCompleted,
                title: Html(data: state.tasks[index].task),
                onChanged: (value) => context
                    .read<TaskCubit>()
                    .completeTask(state.tasks[index].id),
              );
            },
            separatorBuilder: (context, index) => Divider(
              endIndent: 10,
              indent: 10,
            ),
          ),
        );
      },
    );
  }
}
