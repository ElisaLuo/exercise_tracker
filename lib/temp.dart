//https://flutterawesome.com/flutter-calendar-organized-neatly-into-a-table/
//https://pub.dev/documentation/table_calendar/latest/table_calendar/table_calendar-library.html

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

/* void main() => runApp(MyApp());

class MyApp extends StatelessWidget { // initialize app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget { // body
  var temp = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving data'),
      ),
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
  return File('$path/counter.txt');
}

_read() async { // read function
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