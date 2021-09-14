import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_attach/Shared/Components/Components.dart';
import 'package:sqflite_attach/Shared/Cubit/Cubit.dart';
import 'package:sqflite_attach/Shared/Cubit/States.dart';


class Cubit_Home_Layout extends StatelessWidget {

  var Scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var TextController = TextEditingController();
  var TimeController = TextEditingController();
  var DateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDatabase(),
      child: BlocConsumer<AppCubit, appstates>(
        listener: (context,appstates state){
          // if(state is AppInserttoDatabase)
          // {
          //   Navigator.pop(context);
          // }
        },
        builder: (context, appstates state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: Scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.cyan,
              title: Text(cubit.title[cubit.currentIndex], style: TextStyle(color: Colors.white),),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isbottomsheet){
                  if (formkey.currentState!.validate()){
                    cubit.inserttoDatabase(
                      title: TextController.text,
                      date: DateController.text,
                      time: TimeController.text,
                    ).then((value){
                      Navigator.pop(context);
                    });
                    };
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
                  )).closed.then((value)
                  {
                  cubit.change_icon(isshow: false, icon: Icons.edit);
                  }
                  );
                  cubit.change_icon(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.cyan,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.change_current_index(index);
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
            body:cubit.screen[cubit.currentIndex],
          );
        }
      ),
    );


  }

}
