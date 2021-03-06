import 'dart:convert';
import 'dart:io';

import 'package:exercise_tracker/timer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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
  final secondsController = TextEditingController();
  Map<DateTime, List> _events;
  List _selectedEvents;
  Map<DateTime, List> _completed;
  List _selectedCompleted;
  String _currentValue;
  List<String> _exercises = [];
  DateTime _selectedDay = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  DateTime _today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
  Map<String, dynamic> _exerciseContent;
  bool _fileExists = false;
  File jsonFile;
  bool _jsfileExists = false;
  File jsFile;
  Directory dir;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController(); // calendar controller
    _events = {};
    _completed = {};
    
    _fetchExercise();

    _selectedEvents = _events[_selectedDay] ?? [];
    _selectedCompleted = _completed[_selectedDay] ?? [];
  }

  Future _fetchExercise() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseTrack.json');
      _fileExists = jsonFile.existsSync();
      jsFile = File('${directory.path}/exercises.json');
      _jsfileExists = jsFile.existsSync();
      if(_fileExists && _jsfileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync());
          _exercises = json.decode(jsFile.readAsStringSync())['data'].cast<String>();
        });
        var _keyslist = _exerciseContent['data'].keys.toList();
        for(var i = 0; i < _keyslist.length; i++){
          var _currentDate = _keyslist[i];
          var _dateTime = DateFormat("yyyy-MM-dd").parse(_currentDate);
          if(_events[_dateTime] == null){
            _events[_dateTime] = [];
            _completed[_dateTime] = [];
          }
          for(var j = 0; j < _exerciseContent['data'][_currentDate].length; j++){
            _completed[_dateTime].add(_exerciseContent['data'][_keyslist[i]][j]['Completed']);
            _events[_dateTime].add(_exerciseContent['data'][_keyslist[i]][j]['Exercise'] + " (" + _exerciseContent['data'][_keyslist[i]][j]['Seconds'].toString() + "s)");
          }
          
        }
      }
      setState(() {
        _events = _events;
        _completed = _completed;
        _selectedEvents = _events[_selectedDay] ?? [];
        _selectedCompleted = _completed[_selectedDay] ?? [];
      });
    });
  }

  Future _updateExercise() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseTrack.json');
      _fileExists = jsonFile.existsSync();
      if(_fileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync());
        });
        var _keyslist = _exerciseContent['data'].keys.toList();
        for(var i = 0; i < _keyslist.length; i++){
          var _currentDate = _keyslist[i];
          var _dateTime = DateFormat("yyyy-MM-dd").parse(_currentDate);
          if(_events[_dateTime] == null){
            _events[_dateTime] = [];
            _completed[_dateTime] = [];
          }
          for(var j = 0; j < _exerciseContent['data'][_currentDate].length; j++){
            _completed[_dateTime][j] = (_exerciseContent['data'][_keyslist[i]][j]['Completed']);
          }
          
        }
      }
      setState(() {
        _completed = _completed;
        _selectedCompleted = _completed[_selectedDay] ?? [];
      });
    });
  }

  void createFile(Map<String, dynamic> content, DateTime date){
    String datestring = date.toString();
    var temp = {"data": {datestring: [content]}};
    File file = new File('${dir.path}/exerciseTrack.json');
    file.createSync();
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    secondsController.dispose();
    super.dispose();
  }

  void writeExercise(DateTime date, String exercise, int seconds, bool completed){
    date = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
    Map<String, dynamic> content = {"Exercise": exercise, "Seconds": seconds, "Completed": completed};
    if(_fileExists){
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      if(jsonFileContent['data'][date.toString()] == null){
        jsonFileContent['data'][date.toString()] = [];
      }
      jsonFileContent['data'][date.toString()].add(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else{
      createFile(content, date);
    }
    this.setState((){
      _exerciseContent = json.decode(jsonFile.readAsStringSync());
    });
  }

  void removeExercise(DateTime date, int index){
    if(_fileExists){
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent['data'][date.toString()].removeAt(index);
      _completed[date].removeAt(index);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
      this.setState((){
        _exerciseContent = json.decode(jsonFile.readAsStringSync());
        _completed = _completed;
      });
    }
  }

  createAddContent(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new DropdownButton<String>(
                value: _currentValue,
                hint: new Text("Select Exercise"),
                items: _exercises.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox( 
                      width: 259.0,
                      child: Text(value)
                    ),
                  );
                }).toList(),
              onChanged: (String change) {
                setState(() {
                  _currentValue = change;
                });
              },),
              new TextField(
                decoration: new InputDecoration(labelText: "Exercise Time (seconds)"),
                keyboardType: TextInputType.number,
                controller: secondsController,
              )
            ],
        );
      },
    );
  }

  createAddDialog(BuildContext context) {
    _exercises = json.decode(jsFile.readAsStringSync())['data'].cast<String>();
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
                writeExercise(_selectedDay, _currentValue, int.parse(secondsController.text), false);
                if(_events[_selectedDay] == null){
                  _events[_selectedDay] = [];
                  _completed[_selectedDay] = [];
                }
                _events[_selectedDay].add(_currentValue + " (" + secondsController.text + "s)");
                _completed[_selectedDay].add(false);
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
          _selectedDay = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
          _selectedCompleted = _completed[_selectedDay];
        });
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blueAccent,
        todayColor: Colors.blueAccent[100]
      ),
    );
  }

  Color getColor(complete, date){
    if(!complete && date == _today) {
      return Colors.black;
    } else{
      return Colors.grey;
    }
  }

  Color getColors(complete){
    if(!complete) {
      return Colors.black;
    } else{
      return Colors.grey;
    }
  }

  Color getCancel(complete){
    if(!complete) {
      return Colors.red;
    } else{
      return Colors.grey;
    }
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _selectedEvents.length+1,
      itemBuilder: (context, index) {
        if(index == 0){
          return _buildCalendar();
        } else{
          return ListTile(
            title: Text(
              _selectedEvents[index-1].toString(), 
              style: TextStyle(color: getColors(_selectedCompleted[index-1]))
            ),
            onTap: () {
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.play_arrow),
                  textColor: getColor(_selectedCompleted[index-1], _selectedDay),
                  color: Colors.white,
                  splashColor: Colors.white,
                  elevation: 0.0,
                  onPressed:(){
                    if(_selectedCompleted[index-1] || _selectedDay != _today){

                    } else{
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => TimerPage(dur: _selectedEvents[index-1] + " " + _selectedDay.toString()),
                        )
                      ).then((_){
                        setState(() {
                          _updateExercise();
                        });
                      });
                    }
                    
                  }
                ),
                RaisedButton(
                  child: Icon(Icons.cancel),
                  textColor: getCancel(_selectedCompleted[index-1]),
                  color: Colors.white,
                  splashColor: Colors.white,
                  elevation: 0.0,
                  onPressed:(){
                    if(_selectedCompleted[index-1]){

                    } else{
                      _events[_selectedDay].removeAt(index-1);
                      setState(() {
                        _events = _events;
                      });
                      removeExercise(_selectedDay, index-1);
                    }
                    
                  }
                ),
              ],
            ),
            contentPadding: EdgeInsets.only(left: 30),
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
          onPressed: () => createAddDialog(context)
        )
      );
    
  }
}

