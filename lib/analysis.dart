import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path_provider/path_provider.dart';

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Analysis();
  }
}

class Analysis extends StatefulWidget {
  // body
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class TimeSeriesSales {
  final DateTime date;
  final int time;
  TimeSeriesSales(this.date, this.time);
}

class _AnalysisPageState extends State<Analysis> {
  bool _fileExists = false;
  Directory dir;
  File jsonFile;
  List<TimeSeriesSales> data = [];
  Map<String, dynamic> _exerciseContent;

  @override
  void initState() {
    super.initState();
    _fetchExercise();
  }

  Future _fetchExercise() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseByItem.json');
      _fileExists = jsonFile.existsSync();
      if(_fileExists){
        this.setState((){
          _exerciseContent = json.decode(jsonFile.readAsStringSync())['data'];
        });
        print(_exerciseContent.toString());
        for(int i = 0; i < _exerciseContent['run'].length; i++){
          var time = DateTime.parse(_exerciseContent['run'][i][0]);
          data.add(new TimeSeriesSales(time, _exerciseContent['run'][i][1]));
        }
        /* for(int i = 0; i < _exerciseContent['xcfa'].length; i++){
          data.add(new TimeSeriesSales(_exerciseContent['xcfa']))
        } */
      } else{
        createFile();
      }
      setState(() {
      });
    });
  }

  void createFile(){
    var temp = {"data": {}};
    print("create file");
    File file = new File('${dir.path}/exerciseByItem.json');
    file.createSync();
    print(json.encode(temp).toString());
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true;
  }

  @override
  Widget build(BuildContext context) {
    

    var series = [
      charts.Series(
        id: 'Sales',
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.date,
        measureFn: (TimeSeriesSales sales, _) => sales.time,
      )
    ];

    var chart = charts.TimeSeriesChart(
      series,
      animate: false
    );

    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          chartWidget
        ],
      ),
    );
  }
}

/// Sample time series data type.
