// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<dynamic> listBox;
  List toDoList = [
    ["Sample Task 1", false],
    ["Sample Task 2", true],
  ];

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    listBox = await Hive.openBox("myBox");
    setState(() {
      toDoList = listBox.get(0, defaultValue: [
        ["Study DSA", false],
        ["Develop app", true],
      ]);
    });
  }

  TextEditingController obj = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([obj.text, false]);
      obj.clear();
      listBox.put(0, toDoList);
    });
    Navigator.pop(context);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: obj,
        onSave: saveNewTask,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      listBox.put(0, toDoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(color: Colors.blue)),
        elevation: 4,
        shadowColor: Colors.yellow,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) => ToDoTile(
          taskName: toDoList[index][0],
          taskStatus: toDoList[index][1],
          onChanged: (value) => checkBoxChanged(value, index),
          deleteTask: (context) => deleteTask(index),
        ),
      ),
    );
  }
}
