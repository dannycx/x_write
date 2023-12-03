import 'dart:async';

import 'package:flutter/material.dart';

enum TimerType { countdown, timer }

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerState();
}

class _TimerState extends State<TimerPage> {
  Timer? _timer;
  bool _stopTiming = true;
  TimerType type = TimerType.countdown;

  final int TIME = 24 * 60 * 60 - 1;
  int curTime = 24 * 60 * 60 - 1;
  String _hour = '23';
  String _minute = '59';
  String _second = '59';

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      print('_stopTiming: $_stopTiming curTime: $curTime');
      if (_stopTiming) {
        return;
      }
      switch (type) {
        case TimerType.countdown:
          if (curTime <= 0) {
            _timer?.cancel();
            _stopTiming = true;
            return;
          }
          curTime--;
          _calculateTimer();
          break;
        default:
          if (curTime >= TIME) {
            _timer?.cancel();
            _stopTiming = true;
            return;
          }
          curTime++;
          _calculateTimer();
          break;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.white, // 颜色
          borderRadius: BorderRadiusDirectional.all(Radius.circular(4)), // 圆角
          boxShadow: [
            // 阴影
            BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.3)
          ]),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const Positioned(
              left: 0,
              top: 0,
              child: Text(
                '计时器',
                style: TextStyle(color: Colors.black, fontSize: 12),
              )),
          const Positioned(
              right: 0,
              top: 0,
              child: Icon(
                Icons.close,
                size: 16,
              )),
          Positioned(
              left: 83,
              top: 30,
              child: Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        type = TimerType.countdown;
                        _reset();
                      },
                      child: const Text('倒计时')),
                  TextButton(
                      onPressed: () {
                        type = TimerType.timer;
                        _reset();
                      },
                      child: const Text('计时器')),
                ],
              )),
          Positioned(
              left: 60,
              top: 75,
              child: Row(
                children: <Widget>[
                  Text(
                    _hour,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    _minute,
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _second,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Positioned(
              left: 90,
              bottom: 0,
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: _reset,
                    style: const ButtonStyle(),
                    child: const Text(
                      '重置',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(onPressed: _start, child: const Text('启动', style: TextStyle(fontSize: 12))),
                ],
              )),
        ],
      ),
    );
  }

  _reset() {
    switch (type) {
      case TimerType.countdown:
        _stopTiming = true;
        curTime = TIME;
        _calculateTimer();
        break;
      default:
        _stopTiming = true;
        curTime = 0;
        _calculateTimer();
        break;
    }
  }

  _start() {
    switch (type) {
      case TimerType.countdown:
        curTime = TIME;
        _stopTiming = false;
        setState(() {});
        break;
      default:
        curTime = 0;
        _stopTiming = false;
        setState(() {});
        break;
    }
  }

  void _calculateTimer() {
    int hour = (curTime / 3600).truncate();
    int minute = ((curTime - (hour * 60 * 60)) / 60).truncate();
    int second = ((curTime - (hour * 60 + minute) * 60)).truncate();

    _hour = hour.toString();
    if (_hour.length == 1) {
      _hour = "0$_hour";
    }
    _minute = minute.toString();
    if (_minute.length == 1) {
      _minute = "0$_minute";
    }
    _second = second.toString();
    if (_second.length == 1) {
      _second = "0$_second";
    }
    setState(() {});
  }
}
