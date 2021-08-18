import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lazy_todo/Routes/addEditTask.dart';
import 'package:lazy_todo/Theme/light_theme.dart';
import 'package:lazy_todo/Utils/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  SharedPreferences? sharedPreferences;
  bool showToDoTasks = true;
  bool showCompletedTasks = true;

  List<Task> completedTasks = [];
  List<Task> todoTasks = [];
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    sharedPreferences = await SharedPreferences.getInstance(); 

    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(android:androidInitilize, iOS: iOSinitilize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
      sharedPreferences!.setString("Tasks", Task.encode(tasks));
    });
  }

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
                child: FutureBuilder(
                  future: initialize(),
                  builder: (context, snapshot) {
                    if(sharedPreferences != null) {

                      String s = sharedPreferences!.getString("Tasks") ?? "";
                      tasks = s == "" ? [] : Task.decode(s);

                      completedTasks = [];
                      todoTasks = [];

                      for(int i = 0; i < tasks.length; ++i) {
                        if(tasks[i].completed) completedTasks.add(tasks[i]);
                        else todoTasks.add(tasks[i]);
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25,40,0,0),
                            child: Text("LazyTodo", style: TextStyle(color: LightTheme.text,fontSize: 24),),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 20, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {setState(() => showToDoTasks = !showToDoTasks);},
                                  child: Row(
                                    children: [
                                      Text("Tasks",style: TextStyle(color: LightTheme.text,fontSize: 20),),
                                      SizedBox(width: 10,),
                                      Icon(showToDoTasks == true ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right_outlined,color: LightTheme.text,size: 20,)
                                    ]
                                  )
                                ),
                                SizedBox(height: 20,),
                                if(showToDoTasks) Column (
                                  children: todoTasks.asMap().entries.map((e) => getTaskCard(e.key, e.value,context)).toList(),
                                ),
                                
                                SizedBox(height: 15,),
                                TextButton(
                                  onPressed: () {setState(() => showCompletedTasks = !showCompletedTasks);},
                                  child: Row(
                                    children: [
                                      Text("Completed Tasks",style: TextStyle(color: LightTheme.text,fontSize: 20),),
                                      SizedBox(width: 10,),
                                      Icon(showCompletedTasks == true ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right_outlined,color: LightTheme.text,size: 20,)
                                    ]
                                  )
                                ),
                                SizedBox(height: 20,),
                                if(showCompletedTasks) Column(
                                  children: completedTasks.asMap().entries.map((e) => getTaskCard(e.key, e.value, context)).toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  }
                ) 
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String s = DateTime.now().toIso8601String();
          int id = sharedPreferences!.getInt("Id") ??  0;
          sharedPreferences!.setInt("Id", id + 1);
          Navigator.of(context).push(_createRoute(AddEditTask(Task("Untitled",false,s,s,"",id), addTask,flutterLocalNotificationsPlugin,false))); 
        },
        child: Center(child: Icon(Icons.add)),
        backgroundColor: LightTheme.accent,
      ),
    );
  }

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget getTaskCard(int index, Task task, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          int i = -1,k;
          for(k = 0; k < tasks.length; ++k) {
            if(tasks[k].completed == task.completed) ++i;
            if(i == index) break;
          }
          if(!task.completed) Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditTask(task, (Task task) {
            setState(() {
              tasks[k] = task;
              sharedPreferences!.setString("Tasks", Task.encode(tasks));
            });
          },flutterLocalNotificationsPlugin,true)));
        }, 
        child: Row(
          children: [
            SizedBox(width: 10,),
            Container(  
              width: 22,
              height: 22,
              child: ElevatedButton(
                onPressed: () {
                  int i = -1;
                  for(int k = 0; k < tasks.length; ++k) {
                    if(tasks[k].completed == task.completed) {
                      ++i;
                    }
                    if(i == index) {
                      setState(() {
                        tasks[k].completed = !tasks[k].completed;
                        sharedPreferences!.setString("Tasks", Task.encode(tasks));
                      });
                      return;
                    }
                  }
                },
                child: !task.completed ? Container() : Icon(Icons.check,size: 15,color: LightTheme.elevated,),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: task.completed ? LightTheme.accent : LightTheme.elevated,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: task.completed ? LightTheme.accent : LightTheme.text),
                ),
              )
            ),
            SizedBox(width: 15,),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(task.title, style: TextStyle(color: LightTheme.text, fontSize: 16,decoration: !task.completed ? TextDecoration.none : TextDecoration.lineThrough))
              )
            ),
            Padding(
              padding: EdgeInsets.only(right: 0,),
              child: IconButton(
                onPressed: () {
                  int i = -1;
                  for(int k = 0; k < tasks.length; ++k) {
                    if(tasks[k].completed == task.completed) {
                      ++i;
                    }
                    if(i == index) {
                      setState(() {
                        flutterLocalNotificationsPlugin.cancel(tasks[k].id);
                        tasks.removeAt(k);
                        sharedPreferences!.setString("Tasks", Task.encode(tasks));
                      });
                      return;
                    }
                  }
                },
                icon: Icon(Icons.delete,color: Color(0x87000000),),
              ),
            )
          ],
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
          backgroundColor: MaterialStateProperty.all(LightTheme.elevated),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
    );
  }
}
