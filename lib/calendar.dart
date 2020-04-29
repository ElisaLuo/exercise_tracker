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
  String _currentValue = 'A';

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
          items: <String>['A', 'B', 'C', 'D'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String change) {
            print(_currentValue);
            setState(() {
              _currentValue = change;
            });
            print(_currentValue);
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
            title: Text("Exercise"),
            content: createAddContent(context),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Add"),
                  onPressed: () {
                    _save(_currentValue);
                  })
            ],
          );
        });
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(_selectedEvents[index].toString()),
            onTap: () {
              _save(_selectedEvents[index]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        _buildCalendar(),
        Expanded(child: _buildExerciseList())
      ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            createAddDialog(context);
          }),
    );
  }
}

Future<String> get _localPath async {
  // get file location
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  // get file
  final path = await _localPath;
  return File('$path/counter.txt');
}

_read() async {
  // read function
  try {
    final file = await _localFile;
    String text = await file.readAsString();
    print(text); // don't need
  } catch (e) {
    print("Couldn't read file");
  }
}

_save(String newText) async {
  // write function
  final file = await _localFile;
  String text1 = await file.readAsString();
  final text = text1 + newText + ",\n";
  await file.writeAsString(text);
  print('saved'); // don't need
}
