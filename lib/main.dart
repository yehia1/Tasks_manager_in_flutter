import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_attach/Layout/HomeLayoutUsingCubit.dart';
import 'package:sqflite_attach/Shared/Bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My database',
      //home: Home_Layout(),
      home:Cubit_Home_Layout(),
    );
  }
}