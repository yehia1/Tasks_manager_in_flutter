import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_attach/Modules/ArchivedTasks/ArchivedTaskScreen.dart';
import 'package:sqflite_attach/Modules/DoneTaskScreen/DoneTaskScreen.dart';
import 'package:sqflite_attach/Modules/NewTaskScreen/NewTaskScreen.dart';
import 'package:sqflite_attach/Shared/Components/Components.dart';
import 'package:sqflite_attach/Shared/Components/Constants.dart';
import 'package:sqflite_attach/Shared/Cubit/Cubit.dart';


class Home_Layout extends StatefulWidget {

  @override
  _Home_LayoutState createState() => _Home_LayoutState();
}

class _Home_LayoutState extends State<Home_Layout> {

  var Scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  late Database database;
  bool isbottomsheet = false;
  IconData fabicon = Icons.edit;
  var TextController = TextEditingController();
  var TimeController = TextEditingController();
  var DateController = TextEditingController();


  @override
  void initState(){
    super.initState();
    CreateDatabase();
  }

  int currentIndex = 1;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(title[currentIndex], style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           if(isbottomsheet){
             if (formkey.currentState!.validate()){
               inserttoDatabase(
                 title: TextController.text,
                 date: DateController.text,
                 time: TimeController.text,
               ).then((value) {
                 Navigator.pop(context);
                 isbottomsheet = false;
                 setState(() {
                   fabicon = Icons.add;
                 });
               });
             }
          }
           else {
             Scaffoldkey.currentState!.showBottomSheet((context)
             => Container(
               color: Colors.grey[300],
               padding: EdgeInsets.all(15),
               child: Form(
                 key: formkey,
                 child: SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       defaultformfield(
                         labelText: 'Task title',
                         prefix: Icons.title,
                         controller: TextController,
                         type: TextInputType.text,
                         validator: (String? value){
                           if(value!.isEmpty){
                             return ('Title must not be empty');
                           }
                           return null;
                         }
                       ),
                       SizedBox(height: 15,),
                       defaultformfield(
                           onTab: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now())
                                  .then((value){
                                 TimeController.text = value!.format(context).toString();
                              });
                           },
                           labelText: 'Task time',
                           prefix: Icons.access_time,
                           controller: TimeController,
                           type: TextInputType.datetime,
                           validator: (String? value){
                             if(value!.isEmpty){
                               return ('Time must not be empty');
                             }
                             return null;
                           }
                       ),
                       SizedBox(height: 15,),
                       defaultformfield(
                           onTab: (){
                             showDatePicker(context: context, initialDate: DateTime.now(), firstDate:DateTime.now(), lastDate: DateTime.parse('2021-09-20'))
                                 .then((value){
                               DateController.text = DateFormat.yMMMd().format(value!);
                             });
                           },
                           labelText: 'Task date',
                           prefix: Icons.calendar_today,
                           controller: DateController,
                           type: TextInputType.datetime,
                           validator: (String? value){
                             if(value!.isEmpty){
                               return ('Date must not be empty');
                             }
                             return null;
                           }
                       )
                     ],
                   ),
                 ),
               ),
             ));
             setState(() {
               fabicon = Icons.edit;
             });
             isbottomsheet =true;
           }
        },
        child: Icon(fabicon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: ('Tasks'),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: ('done'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: ('Archive'),
          ),
        ],
      ),
      body: AppCubit.get(context).newtasks.length == 0 ?Center(child: CircularProgressIndicator()) : screen[currentIndex],
    );


  }

  void CreateDatabase() async{
      database = await openDatabase('todo.db',
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
        getdata(database).then((value) {
          setState(() {
            AppCubit.get(context).newtasks = value;
          });
        });
        print('database opened');
      }
  );
  }

  Future inserttoDatabase({required String title, required String time, required String date,
  }) async{
     return await database.transaction((txn) async {
       txn.rawInsert('INSERT INTO tasks1(title,date,time,status) VALUES("$title","$date","$time","new")').then((value){
         print('inserted sucessfully');
       }).catchError((error){
         print('error when inserting new raw ${error.toString()}');
       });
    });
  }

  Future<List<Map>> getdata(Database database) async{
    return await database.rawQuery('Select * from tasks1');
  }
}
