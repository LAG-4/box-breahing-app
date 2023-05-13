import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(BreathingApp());

class BreathingApp extends StatefulWidget {
  @override
  _BreathingAppState createState() => _BreathingAppState();
}

class _BreathingAppState extends State<BreathingApp> {
  String _breathPhase = 'Inhale  ';
  int _breathCount = 0;
  Timer? _timer;
  int _remainingMinutes = 2;
  int _remainingSeconds = 2;
  int _countdown = 6;
  bool _isSessionRunning = false;
  TextEditingController _countdownController = TextEditingController();
  TextEditingController _sessionLengthController = TextEditingController();

  @override
  void dispose() {
    _countdownController.dispose();
    _sessionLengthController.dispose();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _isSessionRunning = true;
      _countdown = int.tryParse(_countdownController.text) ?? _countdown;
      _remainingMinutes = int.tryParse(_sessionLengthController.text) ?? _remainingMinutes;
      _remainingSeconds = _remainingMinutes * 60; // convert minutes to seconds
      _startTimer();
    });
  }


  void _startTimer() {
    int num = _countdown;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        num--;
        if (_remainingSeconds == 0) {
          timer.cancel();
          _isSessionRunning = false;
        }
        if (num == 0) {
          _breathCount++;
          _breathPhase = _getBreathPhase();
          num = _countdown;
        } else {
          _breathPhase = '${_breathPhase.substring(0, _breathPhase.length - 1)}$num';
        }
      });
    });
  }

  String _getBreathPhase() {
    if (_breathCount % 4 == 1) {
      return 'Hold  ';
    } else if (_breathCount % 4 == 2) {
      return 'Exhale  ';
    } else if (_breathCount % 4 == 3) {
      return 'Hold  ';
    } else {
      return 'Inhale  ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center(child: Text('Breathe',style: TextStyle(fontFamily: 'Googlethick'),)),
        ),
        backgroundColor: Color(0xFF252525),
        body: Center(
          child: _isSessionRunning
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$_breathPhase', style: TextStyle(fontSize: 32,fontFamily: 'Google',color: Colors.white)),
              SizedBox(height: 40),
              Text(
                '${_remainingMinutes}:${(_remainingSeconds % 60).toString().padLeft(2, '0')} Session',
                style: TextStyle(fontSize: 24,fontFamily: 'Google',color: Colors.white),
              ),
              SizedBox(height: 60,),
              SizedBox(
                width: 150,
                height: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStatePropertyAll(Colors.black54),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                        )
                    ),
                  ),
                  onPressed: (){
                    _isSessionRunning=false;
                  },
                  child: Text('STOP',style: TextStyle(fontFamily: 'Google',fontSize: 30),
                  ),

                ),
              ),
            ],
          )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(90.0),
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  TextField(
                    style: TextStyle(fontFamily: 'Google',color: Colors.white),
                    controller: _countdownController,
                    decoration: InputDecoration(
                      hintText: 'Countdown(Seconds)',
                      hintStyle: TextStyle(fontFamily: 'Google',color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(style: TextStyle(color: Colors.white,fontFamily: 'Google'),
                    controller: _sessionLengthController,
                    decoration: InputDecoration(
                      hintText: 'Session Length (Minutes)',
                      hintStyle: TextStyle(fontFamily: 'Google',color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 60),
              SizedBox(
                width: 150,
                height: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStatePropertyAll(Colors.black54),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                    ),
                  ),
                  onPressed: _startSession,
                  child: Text('START',style: TextStyle(fontFamily: 'Google',fontSize: 30),
                  ),

                ),
              ),
            ],
          ),
                ),
              ),
        ),
      ),
    );
  }
}
