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

class Calendar extends StatefulWidget { // body
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<Calendar>{
  CalendarController _controller;
  Map<DateTime, List> _events;
  List _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _selectedEvents.insert(0, "a");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  createAddDialog(BuildContext context){
    TextEditingController tempController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Your Name?"),
          content: TextField(
            controller: tempController
          ),
          actions: <Widget>[
            MaterialButton( 
              elevation: 5.0,
              child: Text("Add"),
              onPressed:(){
                _save(tempController.text);
              }
            )
          ],
        );
      }
    );
  }

  Widget _buildEventList() {
    return ListView(
  padding: const EdgeInsets.all(8),
  children: <Widget>[
    Container(
      height: 50,
      color: Colors.amber[600],
      child: const Center(child: Text('Entry A')),
    ),
    Container(
      height: 50,
      color: Colors.amber[500],
      child: const Center(child: Text('Entry B')),
    ),
    Container(
      height: 50,
      color: Colors.amber[100],
      child: const Center(child: Text('Entry C')),
    ),
  ],
);
    /* return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 50,
          child: Center(child: Text('Entry ${_selectedEvents[index]}'),)
        );
      },
    ); */
  }

  Widget _buildCalendar(){
    print(_selectedEvents);
    return TableCalendar(
      calendarController: _controller,
      events: _events,
      availableCalendarFormats: const {
        CalendarFormat.month: ''
      },
    );
  }

  /* @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //_buildCalendar(),
            
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:(){
          createAddDialog(context);
        }
      ),
    );
  } */
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index){
          if(index == 0){
            return Column(
              children: <Widget>[
                _buildCalendar()
              ],
            );
          }
          return ListTile(
            title: Text(_selectedEvents[index].toString()),
            onTap: () => print('Entry ${_selectedEvents[index]}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:(){
          createAddDialog(context);
        }
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

_save(String newText) async { // write function
  final file = await _localFile;
  String text1 = await file.readAsString();
  final text = text1 + newText + ",\n";
  await file.writeAsString(text);
  print('saved'); // don't need
}

