import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/router.dart';
import '../home/home.dart';
import 'app_cubit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: const ColorScheme.dark(),
      ),
      onGenerateRoute: CustomRouter.generateRoute,
    );
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state.appStates == AppStates.loading) {
          return _loadingData();
        } else if (state.appStates == AppStates.loaded) {
          return const MyHomePage();
        }
        return const Scaffold();
      },
    );
  }

  Scaffold _loadingData() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
