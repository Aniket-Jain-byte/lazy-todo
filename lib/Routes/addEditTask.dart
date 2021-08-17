import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:lazy_todo/Theme/light_theme.dart';
import 'package:lazy_todo/Utils/classes.dart';


class AddEditTask extends StatefulWidget {
  Task task;

  AddEditTask(this.task,this.addEditTask);
  void Function(Task) addEditTask;

  @override
  _AddEditTaskState createState() => _AddEditTaskState(task,addEditTask);
}

class _AddEditTaskState extends State<AddEditTask> {

  Task task;
  void Function(Task) addEditTask;
  _AddEditTaskState(this.task,this.addEditTask);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: LightTheme.background,
      body: LayoutBuilder(
        builder: (context,constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height,),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,50,0,0),
                        child: Text("Add Task", style: TextStyle(color: LightTheme.text,fontSize: 24),),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          initialValue: task.title,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: LightTheme.elevated,
                            labelText: "Task",
                            labelStyle: TextStyle(color: LightTheme.text), 
                            //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: LightTheme.accent,width: 1),),
                            //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: LightTheme.accent,width: 1),),
                          ),
                          onChanged: (String s) {
                            task.title = s;
                          }
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: LightTheme.elevated),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text("Due at: ${getDateFormattedString(DateTime.parse(task.dueTime))}", style: TextStyle(color: LightTheme.text, fontSize: 16),))),
                            IconButton(
                              onPressed: () async{
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                setState(() {
                                  DateTime curDueTime = DateTime.parse(task.dueTime);
                                  DateTime newDueTime = DateTime(curDueTime.year,curDueTime.month,curDueTime.day,newTime!.hour,newTime.minute);
                                  task.dueTime = newDueTime.toIso8601String();
                                });
                              },
                              padding: EdgeInsets.all(10),
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.timer,color: LightTheme.accent,size: 20,),
                            ),
                            IconButton(
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                DateTime? chosenDueTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(now.year,now.month,now.day), 
                                  firstDate: DateTime(now.year,now.month,now.day), 
                                  lastDate: DateTime(now.year + 1, now.month, now.day),
                                );
                                setState(() {
                                  DateTime curDueTime = DateTime.parse(task.dueTime);
                                  DateTime newDueTime = DateTime(chosenDueTime!.year,chosenDueTime.month,chosenDueTime.day,curDueTime.hour,curDueTime.minute);
                                  task.dueTime = newDueTime.toIso8601String();
                                });
                              },
                              padding: EdgeInsets.only(right: 8),
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.date_range_outlined,color: LightTheme.accent,size: 20,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: LightTheme.elevated),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text("Remind at: ${getDateFormattedString(DateTime.parse(task.remindTime))}", style: TextStyle(color: LightTheme.text, fontSize: 16),))),
                            IconButton(
                              onPressed: () async{
                                TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                setState(() {
                                  DateTime curRemindTime = DateTime.parse(task.remindTime);
                                  DateTime newRemindTime = DateTime(curRemindTime.year,curRemindTime.month,curRemindTime.day,newTime!.hour,newTime.minute);
                                  task.remindTime = newRemindTime.toIso8601String();
                                });
                              },
                              padding: EdgeInsets.all(10),
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.timer,color: LightTheme.accent,size: 20,),
                            ),
                            IconButton(
                              onPressed: () async{
                                DateTime now = DateTime.now();
                                DateTime? chosenRemindTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(now.year,now.month,now.day), 
                                  firstDate: DateTime(now.year,now.month,now.day), 
                                  lastDate: DateTime(now.year + 1, now.month, now.day),
                                );
                                setState(() {
                                  DateTime curRemindTime = DateTime.parse(task.remindTime);
                                  DateTime newRemindTime = DateTime(chosenRemindTime!.year,chosenRemindTime.month,chosenRemindTime.day,curRemindTime.hour,curRemindTime.minute);
                                  task.remindTime = newRemindTime.toIso8601String();
                                });
                              },
                              padding: EdgeInsets.only(right: 8),
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.date_range_outlined,color: LightTheme.accent,size: 20,),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          initialValue: task.note,
                          expands: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: LightTheme.elevated,
                            labelText: "Notes",
                            alignLabelWithHint: true
                          ),
                          maxLines: null,
                          minLines: null,
                          onChanged: (String s) {
                            task.note = s;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addEditTask(task);
          Navigator.pop(context);
        },
        child: Icon(Icons.check,size: 20,color: LightTheme.elevated,),
      ),
    );
  }

  String getDateFormattedString(DateTime dateTime) {
    String s = " ${correctHourMinute(dateTime.hour.toString())}:${correctHourMinute(dateTime.minute.toString())}, ${dateTime.day} ${getMonth(dateTime.month)} ${dateTime.year.toString().substring(2,4)}";
    return s;
  }

  String getMonth(int month) {
    List<String> arr = ["Jan", "Feb", "Mar", "Apr" , "May" , "Jun", "Jul" , "Aug", "Sept", "Oct", "Nov", "Dec"];
    return arr[month - 1];
  }

  String correctHourMinute(String s) {
    if(s.length == 1)
      s = "0" + s;
    return s;
  }
 }