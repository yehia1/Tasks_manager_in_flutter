import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_attach/Modules/ArchivedTasks/ArchivedTaskScreen.dart';
import 'package:sqflite_attach/Modules/DoneTaskScreen/DoneTaskScreen.dart';
import 'package:sqflite_attach/Modules/NewTaskScreen/NewTaskScreen.dart';
import 'package:sqflite_attach/Shared/Cubit/States.dart';

class AppCubit extends Cubit<appstates>{

  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  late Database database;

  bool isbottomsheet = false;

  IconData fabicon = Icons.edit;

  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];


  List<Widget> screen = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> title = [
    'New Task',
    'Done Tasks',
    'Archived Tasks'
  ];

  void change_current_index(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void CreateDatabase() {
   openDatabase('todo.db',
        version: 2,
        onCreate: (database,version) {
          print('database created');
          database.execute(
              'Create Table tasks1(id INTEGER PRIMARY KEY , title STRING , Date STRING,time STRING,status STRING) ')
              .then((value) {
            print('table created');
          }).catchError((error) {
            ('Error when creating table ${error.toString()}');
          });
        },
        onOpen: (database){
          print('database opened');
          getdata(database);
        }
    ).then((value){
     database =value;
     emit(AppCreateDatabase());
    });
  }


  inserttoDatabase({required String title, required String time, required String date,
  }) async{
    await database.transaction((txn) async {
      txn.rawInsert('INSERT INTO tasks1(title,date,time,status) VALUES("$title","$date","$time","new")').then((value){
        print('$value inserted sucessfully');
        emit(AppInserttoDatabase());

        getdata(database);
      }).catchError((error){
        print('error when inserting new raw ${error.toString()}');
      });
    });
  }

  void getdata(Database database){
    newtasks = [];
    donetasks = [];
    archivedtasks = [];

    emit(AppGetDatabaseLoadingScreen());
    database.rawQuery('Select * from tasks1').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newtasks.add(element);
        else if(element['status'] == 'done')
          donetasks.add(element);
        else archivedtasks.add(element);
      });
      emit(AppGetDatabase());
    });
  }


  void deleteData({
  required int id,
})
  {
    database.rawDelete('delete from tasks1 where id = $id')
        .then((value)
    {
      getdata(database);
      emit(AppDeleteDatabase());
    });
  }

  void updatedata({
  required int id,
  required String status,
}){
    database.rawUpdate(
      'UPDATE tasks1 SET status = ? WHERE id = ?',
      ['$status',id],
    ).then((value)
    {
      getdata(database);
      emit(UpdateDatabase());
    });
  }

  void change_icon({required bool isshow, required IconData icon,}){
    isbottomsheet = isshow;
    fabicon = icon;
    emit(AppChangeIcon());
  }
}
