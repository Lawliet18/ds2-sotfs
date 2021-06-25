import 'package:ds_soft_checklist/pages/task/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'playthrough_cubit.dart';

class PlaythroughChecklist extends StatelessWidget {
  const PlaythroughChecklist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playthrough'),
        centerTitle: true,
      ),
      body: BlocBuilder<PlaythroughCubit, PlaythroughState>(
        builder: (context, state) {
          if (state.playthroughStates == PlaythroughStates.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.playthroughStates == PlaythroughStates.loaded) {
            return GridView.builder(
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Html(
                              data: state.list[index].name,
                              onLinkTap: (str, _, __, ___) => _urlLauncher(str),
                            ),
                          ),
                          LinearProgressIndicator(
                            value: state.list[index].completed /
                                state.list[index].taskAmount,
                            minHeight: 10,
                          )
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/task',
                        arguments: state.list[index].name),
                  );
                });
          }
          return Container(
            child: null,
          );
        },
      ),
    );
  }

  Future<void> _urlLauncher(String? str) async {
    await canLaunch(str ?? '');
  }
}
