import 'package:exercise_tracker/manageExercises.dart';
import 'package:flutter/material.dart';
import './calendar.dart';
import './analysis.dart';
import './manageExercises.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // initialize app
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final _pageOptions = [
    CalendarPage(),
    AnalysisPage(),
  ];

  int _currentIndex = 0;

  void onTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget mainHome(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar( 
        onTap: onTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            title: Text('Track'),
          ),
          /* BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            title: Text('Edit Exercises'),
          ), */
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: "Exercise Tracker",
      home: mainHome(context)
    );
  }
}