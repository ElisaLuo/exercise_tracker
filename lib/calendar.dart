import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Calendar();
  }
}

class Calendar extends StatefulWidget {
  // body
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar> {
  CalendarController _controller;
  Map<DateTime, List> _events;
  List _selectedEvents;
  String _currentValue;
  List<String> _exercises;
  DateTime _selectedDay = new DateTime.now();
  Map<String, dynamic> _exerciseContent;
  bool _fileExists = false;
  File jsonFile;
  Directory dir;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(); // calendar controller

    _events = {};

    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });

    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseTrack.json');
      _fileExists = jsonFile.existsSync();
      if(_fileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync());
        });
        for(var i = 0; i < _exerciseContent['data'].length; i++){
          var temp = _exerciseContent['data'][i]['Date'].split(" ")[0].split("-");
          var _currentDate = DateTime(int.parse(temp[0]), int.parse(temp[1]), int.parse(temp[2]));
          if(_events[_currentDate] == null){
            _events[_currentDate] = [];
          }
          _events[_currentDate].add(_exerciseContent['data'][i]['Exercise']);
        }
      }
      print("finished");
      setState(() {
        _events = _events;
      });
    });

    _selectedEvents = _events[_selectedDay] ?? [];
    print("events"+_events.toString());
  }

  void createFile(Map<String, dynamic> content){
    var temp = {"data":[content]};
    print("create file");
    File file = new File('${dir.path}/exerciseTrack.json');
    file.createSync();
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void writeExercise(DateTime date, String exercise, int seconds){
    print("write to file");
    Map<String, dynamic> content = {"Date": date.toString(), "Exercise": exercise, "Seconds": seconds};
    if(_fileExists){
      print("file exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent['data'].add(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else{
      print("file no exist");
      createFile(content);
    }
    this.setState((){
      _exerciseContent = json.decode(jsonFile.readAsStringSync());
    });
    print(_exerciseContent);
  }

  createAddContent(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          child: DropdownButton<String>(
            value: _currentValue,
            hint: new Text("Select Exercise"),
            items: _exercises.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: SizedBox( 
                  width: 200.0,
                  child: Text(value)
                ),
              );
            }
          ).toList(),
          onChanged: (String change) {
            setState(() {
              _currentValue = change;
            });
          },
        ));
      },
    );
  }

  createAddDialog(BuildContext context) {
    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Daily Exercise"),
          content: createAddContent(context),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Add"),
              onPressed: () {
                writeExercise(_selectedDay, _currentValue, 60);
                Navigator.pop(context);
              }
            )
          ],
        );
      }
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarController: _controller,
      events: _events,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      onDaySelected: (date, events) {
        setState(() {
          _selectedEvents = events;
          _selectedDay = date;
        });
      },
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemCount: _selectedEvents.length+1,
      itemBuilder: (context, index) {
        if(index == 0){
          print("built");
          return _buildCalendar();
        } else{
          return ListTile(
            title: Text(_selectedEvents[index-1].toString()),
            onTap: () {
              print('Entry ${_selectedEvents[index-1]}');
            }
          );
        }
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max, 
        children: <Widget>[
          Expanded(child: _buildExerciseList())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          createAddDialog(context);
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
