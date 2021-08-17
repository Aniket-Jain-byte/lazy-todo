import 'dart:convert';

import 'package:flutter/material.dart';

class Task {

  String title;
  bool completed;
  String dueTime;
  String remindTime;
  String note;

  Task(
    this.title,
    this.completed,
    this.dueTime,
    this.remindTime,
    this.note,
  );

  static String encode(List<Task> tasks) => jsonEncode(
    tasks.map<Map<String, dynamic>>((task) =>  Task.toMap(task))
    .toList(),
  );

  static Map<String,dynamic> toMap(Task task) => {
    "title" : task.title,
    "completed" : task.completed,
    "dueTime" : task.dueTime,
    "remindTime" : task.remindTime,
    "note" : task.note,
  };

  static List<Task> decode(String tasks) => 
    (json.decode(tasks) as List<dynamic>).map<Task>((task) => Task.fromJson(task))
    .toList();

  factory Task.fromJson(Map<String,dynamic> jsonData) {
    return Task(
      jsonData["title"],
      jsonData["completed"],
      jsonData["dueTime"],
      jsonData["remindTime"],
      jsonData["note"]
    );
  }

}