import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/task.dart';
import '../playthrough/playthrough_cubit.dart';
import 'home_cubit.dart';

@immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.homeStates == HomeStates.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.homeStates == HomeStates.loaded)
                _listOfCurrentChecklist(state),
              if (state.homeStates == HomeStates.initial) _selectYourPath(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(
                          '/playthrough',
                          arguments: ChecklistPages.playthrough,
                        );
                        await context.read<HomeCubit>().loadCurrentChecklist();
                      },
                      child: const Text('Playthrough'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(
                          '/achievement',
                          arguments: ChecklistPages.achievement,
                        );
                        await context.read<HomeCubit>().loadCurrentChecklist();
                      },
                      child: const Text('Achievement'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Center _selectYourPath() {
    return const Center(
      child: Text(
        'Select your current playthrough or achievement\n(hold down on the tile)',
        textAlign: TextAlign.center,
      ),
    );
  }

  Expanded _listOfCurrentChecklist(HomeState state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: TaskList(
              list: state.currentPlaythrough,
              name: 'Playthrough',
            ),
          ),
          Expanded(
            child: TaskList(
              list: state.currentAchievement,
              name: 'Achievement',
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> list;
  final String name;

  const TaskList({Key? key, required this.list, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Current $name'),
        ),
        Expanded(
          child: list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: list[index].isCompleted,
                      onChanged: (value) => name == 'Playthrough'
                          ? context
                              .read<HomeCubit>()
                              .completeTaskPlaythrough(list[index].id)
                          : context
                              .read<HomeCubit>()
                              .completeTaskAchievement(list[index].id),
                      title: Html(
                        data: list[index].task,
                        onLinkTap: (str, _, __, ___) => _urlLauncher(str),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                      'Select your current $name\n(hold down on the tile)'),
                ),
        ),
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
