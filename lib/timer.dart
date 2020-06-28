import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class TimerPage extends StatelessWidget {
  final String dur;

  TimerPage({
    @required this.dur,
  });

  @override
  Widget build(BuildContext context) {
    return Timers(durp: dur);
  }
}

class Timers extends StatefulWidget {
  final String durp;

  Timers({
    @required this.durp,
  });
  
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timers> with TickerProviderStateMixin{ // body
  List seconds = [];
  int dura;
  int oriDura;
  double finalDura;
  String exer;
  bool counting;
  Timer timer;
  bool _fileExists = false;
  File jsonFile;
  bool _exerfileExists = false;
  File exerjsonFile;
  Directory dir;
  String date;
  var formatDate;

  @override
  void initState() {
    super.initState();

    _fetchExerciseByItem();
    

    print("here");
    print(widget.durp);
    oriDura = int.parse(widget.durp.split(" (")[1].split("s")[0]);
    dura = int.parse(widget.durp.split(" (")[1].split("s")[0]);
    finalDura = double.parse(widget.durp.split(" (")[1].split("s")[0]);
    exer = widget.durp.split(" (")[0];
    date = widget.durp.split(") ")[1].split(" ")[0];
    formatDate = DateTime.parse(widget.durp.split(") ")[1]).toString();
    counting = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _fetchExerciseByItem() async{
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = File('${directory.path}/exerciseByItem.json');
      _fileExists = jsonFile.existsSync();
      if(_fileExists){
        print("exercise by item file exists");
        print("file" + json.decode(jsonFile.readAsStringSync())['data'].toString());
      } else{
        createFile();
      }
    });
  }

  void createFile(){
    var temp = {"data": {exer: {}}};
    print("create file");
    File file = new File('${dir.path}/exerciseByItem.json');
    file.createSync();
    print(json.encode(temp).toString());
    file.writeAsStringSync(json.encode(temp));
    _fileExists = true;
  }

  void setAsComplete(date, exercise, duration){
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      exerjsonFile = File('${directory.path}/exerciseTrack.json');
      jsonFile = File('${directory.path}/exerciseByItem.json');
      _exerfileExists = exerjsonFile.existsSync();
      if(_exerfileExists && _fileExists){
        Map<String, dynamic> jsonFileContent = json.decode(exerjsonFile.readAsStringSync());
        Map<String, dynamic> jsonFileCont = json.decode(jsonFile.readAsStringSync());
        for(Map<String, dynamic> item in jsonFileContent['data'][formatDate]){
          if(item["Exercise"] == exercise && item["Seconds"] == duration && item["Completed"] == false){
            item["Completed"] = true;
            print(item.toString());
            break;
          }
        }
        if(jsonFileCont['data'][exercise] == null || jsonFileCont['data'][exercise].isEmpty){
          jsonFileCont['data'][exercise] = {date: duration};
          //print("not this thing " + jsonFileCont['data'][exercise].toString());
        } else{
          jsonFileCont['data'][exercise][date] += duration;
          print("this thing " + jsonFileCont['data'][exercise].toString());
        }
        exerjsonFile.writeAsStringSync(json.encode(jsonFileContent));
        jsonFile.writeAsStringSync(json.encode(jsonFileCont));
      }
      setState(() {
      });
    });
  }
  /* void writeExercise(DateTime date, String exercise, int seconds, int amount, bool completed){
    date = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
    print("write to file");
    Map<String, dynamic> content = {"Exercise": exercise, "Seconds": seconds, "Amount": amount, "Completed": completed};
    if(_fileExists){
      print("file exists");
      
    } else{
      print("file no exist");
      createFile(content, date);
    }
  } */

  startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if(dura <= 0) {
        setState(() {
          counting = false;
        });
        timer.cancel();
        setAsComplete(formatDate, exer, oriDura);
      } else{
        setState(() {
          finalDura = finalDura-0.05;
          dura = finalDura.round();
        });
      }
    });
  }

  cancelTimer() {
    timer.cancel();
  }

  String get timerString {
    return '${((dura / 60) % 60).floor().toString().padLeft(2, '0')}:${(dura % 60).floor().toString().padLeft(2, '0')}';
  }

  @override
  Widget background(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 0.6),
            Color.fromRGBO(125, 170, 206, 0.6),
          ],
          [
            Color.fromRGBO(125, 170, 206, 0.7),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 0.5),
            Color.fromRGBO(172, 182, 219, 0.5)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [(finalDura/oriDura)*0.9, (finalDura/oriDura)*1.1, (finalDura/oriDura)],
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Exercise Timer')
      ),
      body: Stack(
        children: <Widget>[
          background(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: Text( 
                    timerString,
                    style: TextStyle( 
                      fontSize: 92.0,
                      color: Colors.white
                    )
                  )
                ),
              ),
              FloatingActionButton.extended(
                onPressed: (){
                  if(counting){
                    cancelTimer();
                  } else{
                    startTimer();
                  }
                  setState(() {
                    counting = !counting;
                  });
                },
                icon: Icon(counting ? Icons.pause : Icons.play_arrow),
                label: Text(counting ? "Pause" : "Play")
              )
            ],
          ),
        ],
      )
    );
  }
}
