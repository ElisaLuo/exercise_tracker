import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'detail.dart';

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Analysis();
  }
}

class Analysis extends StatefulWidget {
  // body
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> { // body
  bool _fileExists = false;
  Directory dir;
  File jsonFile;
  Map<String, dynamic> _exerciseContent;
  var allExercise = [];
  var allInfo = [];
  List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    _fetchExercise();

    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });
  }

  Future _fetchExercise() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseByItem.json');
      _fileExists = jsonFile.existsSync();
      if(_fileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync())['data'];
        });
        allExercise = _exerciseContent.keys.toList();
        print("exercisecontent" + _exerciseContent.toString());
        print(allExercise.toString());
        for(int i = 0; i < allExercise.length; i++){
          allInfo.add([]);
          allInfo[i].add(allExercise[i]);
          allInfo[i].add(0);
          List<dynamic> thing = _exerciseContent[allExercise[i]].values.toList();
          for(int j = 0; j < thing.length; j++){
            allInfo[i][1] += thing[j];
          }
          
        }
        print(allInfo.toString());
      } else{
        createFile();
      }
      setState(() {
      });
    });
  }

  void createFile(){
    var temp = {"data": {}};
    print("create file");
    File file = new File('${dir.path}/exerciseByItem.json');
    file.createSync();
    print(json.encode(temp).toString());
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true;
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
                _exercises.add(newExerciseController.text);
                allInfo.add([newExerciseController.text, 0]);
                setState(() {
                  _exercises = _exercises;
                });
                Navigator.pop(context);
              }
            )
          ],
        );
      }
    );
  }

  Text determineSecs(index){
    if(index < allInfo.length){
      return Text('Total ${allInfo[index][1]} seconds');
    } else{
      return Text('Total 0 seconds');
    }
  }

  /* _buildList(BuildContext context){
    return ListView.builder(
      itemCount: _exercises.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('${_exercises[index]}'),
          subtitle: determineSecs(index),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.arrow_forward_ios),
                color: Colors.white,
                splashColor: Colors.white,
                elevation: 0.0,
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(exer: _exercises[index])
                    )
                  );
                }
              ),
              /* RaisedButton(
                child: Icon(Icons.cancel),
                textColor: Colors.red[600],
                color: Colors.white,
                splashColor: Colors.white,
                elevation: 0.0,
                onPressed:(){
                  _deleteExercise(_exercises[index]);
                  _exercises.removeAt(index);
                  setState(() {
                    _exercises = _exercises;
                  });
                }
              ), */
            ],
          ),
          
          contentPadding: EdgeInsets.only(left: 30),
        );
      },
    );
  } */

  _buildList(BuildContext context){
    return ListView.builder(
      itemCount: _exercises.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onLongPress: () {
            showMenu(
              position: RelativeRect.fromLTRB(0, 10, 20, 30),
              items: <PopupMenuEntry>[
                PopupMenuItem(
                  value: index,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      Text("Delete"),
                    ],
                  ),
                )
              ],
              context: context,
            );
          },
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(exer: _exercises[index])
              )
            );
          },
          child: ListTile(
            title: Text('${_exercises[index]}'),
            subtitle: determineSecs(index),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                  splashColor: Colors.white,
                  elevation: 0.0,
                  onPressed:(){
                
                  }
                ),
                /* RaisedButton(
                  child: Icon(Icons.cancel),
                  textColor: Colors.red[600],
                  color: Colors.white,
                  splashColor: Colors.white,
                  elevation: 0.0,
                  onPressed:(){
                    _deleteExercise(_exercises[index]);
                    _exercises.removeAt(index);
                    setState(() {
                      _exercises = _exercises;
                    });
                  }
                ), */
              ],
            ),
            
            contentPadding: EdgeInsets.only(left: 30),
          )
        );
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Exercises"),
      ),
      body: _buildList(context),
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

_deleteExercise(String texts) async{
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/exercises.txt');
  String text = await file.readAsString();
  text = text.replaceFirst(texts+",", "");
  await file.writeAsString(text);
  print('saved change');
}