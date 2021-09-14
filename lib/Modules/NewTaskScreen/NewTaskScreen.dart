import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_attach/Shared/Components/Components.dart';
import 'package:sqflite_attach/Shared/Cubit/Cubit.dart';
import 'package:sqflite_attach/Shared/Cubit/States.dart';


class NewTaskScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, appstates>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).newtasks;
          return TasksBuilder(tasks: tasks, icon: Icons.menu, text: 'No new tasks added yet',isdone: false,isarchived: false);
        },
    );
  }
}
