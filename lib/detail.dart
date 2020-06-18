import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatelessWidget {
  final String exer;

  DetailPage({
    @required this.exer
  });

  @override
  Widget build(BuildContext context) {
    return Detail(exers: exer);
  }
}

class Detail extends StatefulWidget {
  final String exers;

  Detail({
    @required this.exers
  });

  // body
  @override
  _DetailPageState createState() => _DetailPageState();
}

class TimeSeriesSales {
  final DateTime date;
  final int time;
  TimeSeriesSales(this.date, this.time);
}

class _DetailPageState extends State<Detail> {
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
        for(int i = 0; i < _exerciseContent[widget.exers].length; i++){
          var time = DateTime.parse(_exerciseContent[widget.exers][i][0]);
          data.add(new TimeSeriesSales(time, _exerciseContent[widget.exers][i][1]));
        }
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
      animate: false,
      behaviors:[
        new charts.ChartTitle("Exercise")
      ]
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
