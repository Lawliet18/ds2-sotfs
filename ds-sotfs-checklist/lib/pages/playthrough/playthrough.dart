import 'package:ds_soft_checklist/pages/task/task_cubit.dart';
import 'package:ds_soft_checklist/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'playthrough_cubit.dart';

class PlaythroughChecklist extends StatelessWidget {
  const PlaythroughChecklist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaythroughCubit, PlaythroughState>(
      builder: (context, state) {
        if (state.playthroughStates == PlaythroughStates.loading) {
          return Scaffold(
            appBar: _appBar(state, context),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.playthroughStates == PlaythroughStates.loaded) {
          return Scaffold(
            appBar: _appBar(state, context),
            body: GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.list.length,
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        state.list[index].isSelected
                            ? Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Html(
                                      data: state.list[index].name,
                                      onLinkTap: (str, _, __, ___) =>
                                          _urlLauncher(str),
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                  )
                                ],
                              )
                            : Html(
                                data: state.list[index].name,
                                onLinkTap: (str, _, __, ___) =>
                                    _urlLauncher(str),
                              ),
                        LinearProgressIndicator(
                          value: state.list[index].completed /
                              state.list[index].taskAmount,
                          minHeight: 10,
                        )
                      ],
                    ),
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/task', arguments: {
                      'name': state.list[index].name,
                      'page': state.checklistPages
                    });
                    await context.read<PlaythroughCubit>().loadPlaythrough();
                  },
                  onLongPress: () => context
                      .read<PlaythroughCubit>()
                      .selectChecklist(state.list[index].name),
                );
              },
            ),
          );
        }
        return Container(
          child: null,
        );
      },
    );
  }

  AppBar _appBar(PlaythroughState state, BuildContext context) {
    return AppBar(
      title: Text(state.checklistPages == ChecklistPages.playthrough
          ? 'Playthrough'
          : 'Achievement'),
      centerTitle: true,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.filter_alt),
          initialValue: state.playthoughFilter,
          itemBuilder: (context) {
            return PlaythoughFilter.values
                .map(
                  (filter) => PopupMenuItem<PlaythoughFilter>(
                    value: filter,
                    child: Text(filter.toString()),
                  ),
                )
                .toList();
          },
          onSelected: context.read<PlaythroughCubit>().filter,
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
