//https://flutterawesome.com/flutter-calendar-organized-neatly-into-a-table/
//https://pub.dev/documentation/table_calendar/latest/table_calendar/table_calendar-library.html

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import './calendar.dart';
import './analysis.dart';

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
    AnalysisPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.calendar_today)),
                Tab(icon: Icon(Icons.graphic_eq))
              ],
              labelPadding: EdgeInsets.only(top: 8),
            )
          ),
          body: TabBarView(
            children: _pageOptions
          ),
        ),
      )
    );
  }
}