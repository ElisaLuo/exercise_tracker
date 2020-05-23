/* https://medium.com/flutterdevs/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1 */

import 'dart:math';

import 'package:flutter/material.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Timer();
  }
}

class Timer extends StatefulWidget {
  // body
  @override
  _TimerState createState() => _TimerState();
}

class CustomTimerPainter extends CustomPainter{
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class _TimerState extends State<Timer> with TickerProviderStateMixin{ // body
  AnimationController controller;
  List seconds = [];
  int durat = 0;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: durat)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    String temp = ModalRoute.of(context).settings.arguments.toString();
    seconds.add([]);
    seconds[0].add(temp.split(" (")[0]);
    seconds[0].add(int.parse(temp.split(" (")[1].split("s")[0]));
    setState(() {
      durat = seconds[0][1];
    });
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: durat)
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Timer"),
      ),
      body: AnimatedBuilder( 
        animation: controller,
        builder: (context, child){
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container( 
                  color: Colors.blueAccent,
                  height: controller.value * (MediaQuery.of(context).size.height - AppBar().preferredSize.height)
                )
              ),
              Padding( 
                padding: EdgeInsets.all(50.0),
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio( 
                          aspectRatio: 1,
                          child: Stack( 
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.red,
                                    color: Colors.black,
                                  )
                                )
                              ),
                              Align( 
                                alignment: FractionalOffset.center,
                                child: Column( 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      seconds[0][0],
                                      style: TextStyle( 
                                        fontSize: 30.0,
                                        color: Colors.black
                                      )
                                    ),
                                    AnimatedBuilder( 
                                      animation: controller,
                                      builder: (context, child){
                                        return Text( 
                                          timerString,
                                          style: TextStyle( 
                                            fontSize: 92.0,
                                            color: Colors.black
                                          )
                                        );
                                      },
                                    )
                                  ],
                                )
                              ),
                            ],
                          ),
                        )
                      )
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child){
                        return FloatingActionButton.extended(
                          onPressed: (){
                            if(controller.isAnimating){
                              controller.stop();
                            } else {
                              controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                            }
                          },
                          icon: Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow),
                          label: Text(controller.isAnimating ? "Pause" : "Play")
                        );
                      },
                    )
                  ],
                )
              )
            ]
          );
        }
      )
    );
  }
}
