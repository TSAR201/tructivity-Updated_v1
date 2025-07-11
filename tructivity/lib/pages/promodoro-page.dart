import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tructivity/dialogs/confirmation-dialog.dart';
import 'package:tructivity/dialogs/promodoro-setting-dialog.dart';
import 'package:tructivity/functions.dart';

class Promodoro extends StatefulWidget {
  final String title;
  Promodoro({required this.title});
  @override
  _PromodoroState createState() => _PromodoroState();
}

class _PromodoroState extends State<Promodoro> {
  late int _focusTime;
  late int _breakTime;
  late int _minutes;
  int _seconds = 0;
  bool _isLoading = true;
  //if break mode is null, the timer is in reset state
  bool? _breakMode = null;
  double _percentDone = 0.0;
  String _buttonText = 'Start Session';
  var f = NumberFormat("00");
  late Timer _timer;

  Future<void> _getData() async {
    _isLoading = true;
    String _times = await getPromodoroPreference();
    List<String> data = _times.split(':');
    _focusTime = int.parse(data[0]);
    _breakTime = int.parse(data[1]);
    _minutes = _focusTime;
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            _stopTimer();
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Promodoro Timer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: _breakMode != null
                ? null
                : () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PromodoroSettingDialog(
                              focusTime: _focusTime, breakTime: _breakTime);
                        }).whenComplete(() async {
                      await _getData();
                    });
                  },
          )
        ],
      ),
      body: _isLoading
          ? Container()
          : Center(
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 120),
                  CircularPercentIndicator(
                    radius: 150.0,
                    lineWidth: 20.0,
                    percent: _percentDone,
                    progressColor:
                        _breakMode == true ? Colors.teal : Colors.red[400],
                    backgroundColor: Colors.grey[200]!,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${f.format(_minutes)} : ${f.format(_seconds)}",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'SansSerif',
                          ),
                        ),
                        Text(
                          _breakMode == true ? 'Break' : 'Focus',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _startSession,
                    child: Text(
                      _buttonText,
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(220, 50),
                      backgroundColor:
                          _breakMode == true ? Colors.teal : Colors.red[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  SizedBox(height: 10),
                  _breakMode == null
                      ? SizedBox()
                      : TextButton(
                          child: Text(
                            'End Focus Session',
                            style: TextStyle(
                              color: _breakMode == true
                                  ? Colors.teal
                                  : Colors.red[400],
                            ),
                          ),
                          onPressed: _endSession,
                        )
                ],
              ),
            ),
    );
  }

  void _startTimer(int time) {
    _minutes = time;
    _seconds = 0;
    int _totalTime = time * 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        if (_minutes == 0) {
          if (_breakMode == false) {
            _totalTime = _breakTime * 60;
            _minutes = _breakTime;
            _breakMode = true;
            _buttonText = "Skip Break";
          } else {
            _totalTime = _focusTime * 60;
            _minutes = _focusTime;
            _breakMode = false;
            _buttonText = "Stop";
          }
          _percentDone = 0;
        } else if (_minutes > 0) {
          _seconds = 59;
          _minutes--;
        }
      } else {
        _seconds--;
      }
      _percentDone = 1 - (_minutes * 60 + _seconds) / _totalTime;
      setState(() {});
    });
  }

  void _stopTimer() {
    if (_breakMode != null) {
      _timer.cancel();
    }
  }

  void _startSession() {
    if (_breakMode == false) {
      showDialog(
          context: context,
          builder: (context) {
            return ConfirmationDialog(
              text: 'Are you sure you want to finish this round earlier?',
            );
          }).then((confirmed) {
        if (confirmed != null) {
          if (confirmed) {
            _stopTimer();
            _startTimer(_breakTime);
            _breakMode = true;
            _buttonText = "Skip Break";
            _percentDone = 0;
            setState(() {});
          }
        }
      });
    } else {
      if (_breakMode == true) {
        showDialog(
            context: context,
            builder: (context) {
              return ConfirmationDialog(
                text: 'Are you sure you want to finish this break earlier?',
              );
            }).then((confirmed) {
          if (confirmed != null) {
            if (confirmed) {
              _stopTimer();
              _startTimer(_focusTime);
              _breakMode = false;
              _buttonText = "Stop";
              _percentDone = 0;
              setState(() {});
            }
          }
        });
      } else {
        _stopTimer();
        _startTimer(_focusTime);
        _breakMode = false;
        _buttonText = "Stop";
        _percentDone = 0;
        setState(() {});
      }
    }
  }

  void _endSession() {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            text: 'Are you sure you want to end this focus session?',
          );
        }).then((confirmed) {
      if (confirmed != null) {
        if (confirmed) {
          _stopTimer();
          _percentDone = 0;
          _breakMode = null;
          _buttonText = "Start Session";
          _minutes = _focusTime;
          _seconds = 0;
          setState(() {});
        }
      }
    });
  }
}
