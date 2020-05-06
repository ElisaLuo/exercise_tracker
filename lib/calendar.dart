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

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    final _selectedDay = DateTime.now();

    _events = {
      DateTime(2020, 4, 1): ['New Year\'s Day'],
      DateTime(2020, 1, 6): ['Epiphany'],
      DateTime(2020, 2, 14): ['Valentine\'s Day'],
      DateTime(2020, 4, 21): ['Easter Sunday'],
      DateTime(2020, 4, 22): ['Easter Monday'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];

    _readAllExercise().then((s){
      setState(() {
        _exercises = s.toString().split(",");
        _exercises.removeLast();
      });
    });
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
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
            items: _exercises.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
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
                
              }
            )
          ],
        );
      }
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(_selectedEvents[index].toString()),
            onTap: () {
              print('Entry ${_selectedEvents[index]}');
            });
      },
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
        _onDaySelected(date, events);
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
          _buildCalendar(),
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
