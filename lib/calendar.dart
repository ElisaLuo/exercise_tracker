import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import './manageExercises.dart';

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
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    

    _events = {
      DateTime(2020, 5, 1): ['New Year\'s Day'],
      DateTime(2020, 5, 6): ['Epiphany'],
      DateTime(2020, 5, 14): ['Valentine\'s Day'],
      DateTime(2020, 5, 21): ['Easter Sunday'],
      DateTime(2020, 5, 22): ['Easter Monday'],
    };

    setState(() {
      _events = _events;
    });

    _selectedEvents = _events[_selectedDay] ?? [];

    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                if(_events.containsKey(_selectedDay)){
                  _events[_selectedDay].add(_currentValue);
                } else{
                  _events[_selectedDay] = [];
                  _events[_selectedDay].add(_currentValue);
                }
                setState(() {
                  _events = _events;
                });
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

  Widget _speedDial(){
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Add Exercise',
          onTap: () => createAddDialog(context)
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: 'Edit Exercises',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ManageExercisesPage()));
          }
        ),
      ],
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
      floatingActionButton: _speedDial()
    );
  }
}

Future<String> _readAllExercise() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/exercises.txt');
  String text = await file.readAsString();
  return text;
}
