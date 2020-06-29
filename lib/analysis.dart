import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
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
  bool _jsfileExists = false;
  Directory dir;
  File jsonFile;
  File jsoFile;
  Map<String, dynamic> _exerciseContent;
  var allExercise = [];
  var allInfo = [];
  List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    _fetchExercise();

  }

  Future _fetchExercise() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseByItem.json');
      jsoFile = File('${directory.path}/exercises.json');
      _fileExists = jsonFile.existsSync();
      _jsfileExists = jsoFile.existsSync();
      if(_fileExists && _jsfileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync())['data'];
          _exercises = json.decode(jsoFile.readAsStringSync())['data'].cast<String>();
        });
        print("exercises"+_exercises.toString());
        allExercise = _exerciseContent.keys.toList();
        for(int i = 0; i < _exercises.length; i++){
          allInfo.add([]);
          allInfo[i].add(_exercises[i]);
          allInfo[i].add(0);
          if(allExercise.contains(_exercises[i])){
            List<dynamic> thing = _exerciseContent[_exercises[i]].values.toList();
            for(int j = 0; j < thing.length; j++){
              allInfo[i][1] += thing[j];
            }
          } else{
          }
        }
        
          
        
        print(allInfo.toString());
      } else if(_fileExists && !_jsfileExists){
        createExerciseFile();
      } else if(_jsfileExists && !_fileExists){
        createFile();
      } else{
        createFile();
        createExerciseFile();
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

  void createExerciseFile(){
    var temp = {"data": []};
    print("create file");
    File file = new File('${dir.path}/exercises.json');
    file.createSync();
    print(json.encode(temp).toString());
    file.writeAsStringSync(json.encode(temp));
    _jsfileExists = true;
  }

  void removeExercise(int index){
    print('delete exercise from file');
    if(_jsfileExists){
      print("file exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsoFile.readAsStringSync());
      jsonFileContent['data'].removeAt(index);
      jsoFile.writeAsStringSync(json.encode(jsonFileContent));
    }
  }

  void addExercise(String exercise){
    print('add exercise into file');
    if(_jsfileExists){
      print("file exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsoFile.readAsStringSync());
      jsonFileContent['data'].add(exercise);
      jsoFile.writeAsStringSync(json.encode(jsonFileContent));
    }
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
                addExercise(newExerciseController.text);
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
      padding: EdgeInsets.only(left: 30, right: 30),
      itemCount: _exercises.length,
      itemBuilder: (context, index){
        return FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width*0.3,
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                title: Text("Delete",style: TextStyle(color: Colors.redAccent),),
                trailingIcon: Icon(Icons.delete,color: Colors.redAccent,),
                onPressed: (){
                  removeExercise(index);
                  _exercises.removeAt(index);
                  setState(() {
                    _exercises = _exercises;
                  });
                }
              )
            ],
            blurSize: 5.0,
            blurBackgroundColor: Colors.grey[200],
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(exer: _exercises[index])
                )
              );
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: -30),
                  title: Text('${_exercises[index]}'),
                  subtitle: Text('Total ${allInfo[index][1]} seconds'),
                  trailing: Icon(Icons.arrow_forward_ios),
                )
              ],
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
