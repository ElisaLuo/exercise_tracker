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

  @override
  void initState() {
    super.initState();
    _fetchExercise();
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
        print(_exerciseContent.keys.toList().toString());
        for(int i = 0; i < allExercise.length; i++){
          allInfo.add([]);
          allInfo[i].add(allExercise[i]);
          allInfo[i].add(0);
          for(int j = 0; j < _exerciseContent[allExercise[i]].length; j++){
            allInfo[i][1] += _exerciseContent[allExercise[i]][j][1];
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

  _buildList(BuildContext context){
    return ListView.builder(
      itemCount: allInfo.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('${allInfo[index][0]}'),
          subtitle: Text('Total ${allInfo[index][1]} seconds'),
          trailing: RaisedButton(
            child: Icon(Icons.arrow_forward_ios),
            color: Colors.white,
            splashColor: Colors.white,
            elevation: 0.0,
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(exer: allInfo[index][0])
                )
              );
            }
          ),
          contentPadding: EdgeInsets.only(left: 30),
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
    );
  }
}
