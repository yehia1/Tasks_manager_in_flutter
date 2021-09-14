import 'package:flutter/material.dart';
import 'package:sqflite_attach/Shared/Cubit/Cubit.dart';

/*
using the reusable componenets
width : for button width
is upper for title of the button to be Upper
radius for putting a circular radius
Colors represents the color of the button
function for onPressed
text is the title
 */
Widget DefaultButton ({
  double height = 40,
  double width = double.infinity,
  bool isUpper = true,
  double radius = 0.0,
  Color backgroundcolor =  Colors.blue,
  required Function function,
  required String text,
  Color textColor = Colors.white,
}) =>
  Container(
    width: width,
    height: height,
    child: MaterialButton(onPressed: function(),
      child: Text(
        isUpper ? text.toUpperCase() : text,
        style: TextStyle(
          fontSize: 20,
          color: textColor,
        ),),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: backgroundcolor
    ),
  );

  Widget defaultformfield({
    required TextEditingController controller,
    required String labelText,
    required TextInputType type,
    bool isPassword = false,
    Function(String)? onsubmit,
    Function(String)? onchange,
    FormFieldValidator<String>? validator,
    Function()? onTab,
    required IconData prefix,
    IconData? suffix,
    Function()? onEyePress,
    }
) => TextFormField(
      onTap: onTab,
      validator: validator,
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      onFieldSubmitted: onsubmit,
      onChanged: onchange,
      decoration: InputDecoration(
      //hintText: 'Email Address',
            labelText: labelText,
            border: OutlineInputBorder(),
            prefixIcon: Icon(prefix),
            suffixIcon: IconButton(icon: Icon(suffix), onPressed:onEyePress),
            ),
    );

  Widget buildTaskItem({required Map model,required context,required bool isdone,required bool isarchivd}){
      return Dismissible(
        key: Key(model['id'].toString()),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                child: Text('${model['time']}',style: TextStyle(fontSize: 20),),
                backgroundColor: Colors.blue,
                radius: 40,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${model['title']}',style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),),
                    Text('${model['Date']}',style: TextStyle(
                      color: Colors.grey
                    ),),
                  ],
                ),
              ),
              isdone ? Container(): IconButton(
                splashRadius: 5,
                onPressed: (){
                  AppCubit.get(context).updatedata(id: model['id'],status: 'done');
                },
                icon: Icon(Icons.check_box,color: Colors.green,)) ,
              isarchivd ? Container(): IconButton(
                  onPressed: (){
                    AppCubit.get(context).updatedata(id: model['id'],status: 'archived');
                  },
                  icon:Icon(Icons.archive,color:Colors.black54),
              ),
              IconButton(
                  onPressed: (){
                    AppCubit.get(context).deleteData(id: model['id']);
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
        ),
        onDismissed: (value){
          AppCubit.get(context).deleteData(id: model['id']);
        },
      );
  }


  Widget TasksBuilder({
  required List<Map> tasks, required IconData icon, required String text, Color color = Colors.grey,required bool isdone,required bool isarchived
}){
    if (tasks.length != 0)
      return ListView.separated(
          itemBuilder:(context,index) => buildTaskItem(model : tasks[index],context: context,isdone:isdone,isarchivd: isarchived),
          separatorBuilder: (context,index) => SizedBox(height: 1,),
          itemCount: tasks.length);
    else
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,size: 100,color: color,),
            SizedBox(height: 10,),
            Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),)
          ],
        ),
      );
  }