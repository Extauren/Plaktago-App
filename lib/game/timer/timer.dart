import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

// ignore: must_be_immutable
class BingoTimer extends StatefulWidget {
  String time;
  int timer;
  BingoTimer({Key? key, this.time = "", this.timer = 0}) : super(key: key);

  @override
  State<BingoTimer> createState() => _BingoTimer();

  String getTime() {
    return time;
  }
}

class _BingoTimer extends State<BingoTimer> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onStopped: () {},
    onEnded: () {},
  );
  double fontSize = 24;

  @override
  void initState() {
    if (widget.time != "") {
      final List<String> time = widget.time.split(':');
      _stopWatchTimer.setPresetHoursTime(int.parse(time[0]));
      _stopWatchTimer.setPresetMinuteTime(int.parse(time[1]));
      _stopWatchTimer.setPresetSecondTime(int.parse(time[2]));
    }
    super.initState();
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 330) {
      fontSize = 22;
    }
    return Column(
      children: <Widget>[
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: _stopWatchTimer.rawTime.value,
          builder: (context, snap) {
            final value = snap.data!;
            widget.timer = value;
            widget.time = StopWatchTimer.getDisplayTime(value,
                hours: _isHours, milliSecond: false);
            return SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Center(child: Text(
              widget.time,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            )));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2),
            //   child: RoundedButton(
            //     icon: Icons.play_arrow,
            //     color: Theme.of(context).colorScheme.primary,
            //     onTap: _stopWatchTimer.onStartTimer,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 2),
            //   child: RoundedButton(
            //     icon: Icons.stop,
            //     color: Theme.of(context).colorScheme.primary,
            //     onTap: _stopWatchTimer.onStopTimer,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
