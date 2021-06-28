import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'task_cubit.dart';

class DisplayTasks extends StatefulWidget {
  final String checklistName;
  const DisplayTasks({Key? key, required this.checklistName}) : super(key: key);

  @override
  _DisplayTasksState createState() => _DisplayTasksState();
}

class _DisplayTasksState extends State<DisplayTasks> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: (state.taskStates == TaskStates.search ||
                  state.taskStates == TaskStates.searchDone)
              ? _searchAppBar()
              : _defaultAppBar(context),
          body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                value: state.tasks[index].isCompleted,
                title: Html(
                  data: state.tasks[index].task,
                  onLinkTap: (str, _, __, ___) => _urlLauncher(str),
                ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppBar _searchAppBar() => AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: context.read<TaskCubit>().search,
          textInputAction: TextInputAction.search,
          autofocus: true,
        ),
        actions: [
          IconButton(
            onPressed: context.read<TaskCubit>().closeSearch,
            icon: Icon(Icons.close),
          )
        ],
      );

  AppBar _defaultAppBar(BuildContext context) {
    return AppBar(
      title: Html(
        data: widget.checklistName,
        onLinkTap: (str, _, __, ___) => _urlLauncher(str),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: context.read<TaskCubit>().startSearch,
          icon: Icon(Icons.search),
        ),
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
          onSelected: context.read<TaskCubit>().filter,
        )
      ],
    );
  }

  Future<void> _urlLauncher(String? str) async {
    await canLaunch(str ?? '');
    if (str != null && await canLaunch(str)) {
      await launch(str);
    } else {
      throw "Could'n launch $str";
    }
  }
}
