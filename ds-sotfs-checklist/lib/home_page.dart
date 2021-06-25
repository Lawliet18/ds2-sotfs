import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Playthrough'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Playthrough'),
            onPressed: () => Navigator.of(context).pushNamed('/playthrough'),
          ),
        ));
  }
}
