import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ManageExercisesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ManageExercises();
  }
}

class ManageExercises extends StatefulWidget {
  // body
  @override
  _ManageExercisesState createState() => _ManageExercisesState();
}

class _ManageExercisesState extends State<ManageExercises> { // body
  List<String> _exercises = ['hi'];

  @override
  void initState() {
    super.initState();
    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });
  }

  createEditDialog(BuildContext context) {
    TextEditingController newExerciseController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Exercises"),
          content: TextField( 
            controller: newExerciseController
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Add"),
              onPressed: () {
                _saveAllExercise(newExerciseController.text);
                setState(() {
                  _exercises[_exercises.length-1] = newExerciseController.text;
                });
              }
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Exercises"),
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index){
          return Container(
            height: 50,
            child: Text(_exercises[index])
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          createEditDialog(context);
        }
      )
    );
  }
}

Future<String> _readAllExercise() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/exercises.txt');
  String text = await file.readAsString();
  return text;
}

_saveAllExercise(String texts) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/exercises.txt');
  String text1 = "";
  if(await file.exists()){
    text1 = await file.readAsString();
  }
  
  final text = text1 + texts + ",";
  await file.writeAsString(text);
  print('saved');
}