import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/app/app.dart';
import 'pages/app/app_cubit.dart';
import 'pages/playthrough/playthrough_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => PlaythroughCubit()),
      ],
      child: MyApp(),
    ),
  );
}
