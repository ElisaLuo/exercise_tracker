import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class _AnalysisPageState extends State<Analysis> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future _fetchData() async {
    /* getApplicationDocumentsDirectory().then((Directory directory){
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
      print(_selectedCompleted);
    }); */
  }

  void createFile(Map<String, dynamic> content, DateTime date) {
    /* String datestring = date.toString();
    var temp = {"data": {datestring: [content]}};
    print("create file");
    File file = new File('${dir.path}/exerciseTrack.json');
    file.createSync();
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true; */
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    var series = [
      charts.Series(
        domainFn: (LinearSales clickData, _) => clickData.year,
        measureFn: (LinearSales clickData, _) => clickData.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        id: 'Clicks',
        data: data,
      ),
    ];

    var chart = charts.LineChart(
      series,
      animate: true,
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
