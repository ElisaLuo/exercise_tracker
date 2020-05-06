import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalysisPage extends StatelessWidget { // body
  var temp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (text) {
              temp = text;
            },
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Read'),
                  onPressed: () {
                    _read();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Save'),
                  onPressed: () {
                    _save(temp);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<String> get _localPath async { // get file location
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async { // get file
  final path = await _localPath;
  return File('$path/allExercises.txt');
}

/* _read() async { // read function
  try {
    final file = await _localFile;
    String text = await file.readAsString();
    print(text); // don't need
  } catch (e) {
    print("Couldn't read file");
  }
}

_save(String something) async { // write function
  final file = await _localFile;
  String text1 = await file.readAsString();
  final text = text1 + something + ",";
  await file.writeAsString(text);
  print('saved'); // don't need
} */

_read() async {
        try {
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/allEx.txt');
          String text = await file.readAsString();
          print(text);
        } catch (e) {
          print("Couldn't read file");
        }
      }

      _save(String info) async {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/allEx.txt');
        final text = info;
        await file.writeAsString(text);
        print('saved');
      }