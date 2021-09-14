import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_attach/Shared/Components/Components.dart';
import 'package:sqflite_attach/Shared/Cubit/Cubit.dart';
import 'package:sqflite_attach/Shared/Cubit/States.dart';


class DoneTaskScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, appstates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).donetasks;
        return TasksBuilder(tasks: tasks, icon: Icons.check_box, text: 'No Done tasks added',color: Colors.green,isdone: true,isarchived: false);
      },
    );
  }
}

