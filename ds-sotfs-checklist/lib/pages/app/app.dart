import 'package:ds_soft_checklist/services/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_page.dart';
import 'app_cubit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.dark(),
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
          return MyHomePage();
        }
        return Scaffold();
      },
    );
  }

  Scaffold _loadingData() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
