import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    oriDura = int.parse(widget.durp.split(" (")[1].split("s")[0]);
    dura = int.parse(widget.durp.split(" (")[1].split("s")[0]);
    finalDura = double.parse(widget.durp.split(" (")[1].split("s")[0]);
    exer = widget.durp.split(" (")[0];
    counting = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if(dura <= 0) {
        setState(() {
          counting = false;
        });
        timer.cancel();
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
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [(1-finalDura/oriDura)*0.9, (1-finalDura/oriDura)*0.95, (1-finalDura/oriDura)],
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: Colors.black
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
