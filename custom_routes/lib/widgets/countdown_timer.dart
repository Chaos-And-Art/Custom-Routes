import 'package:custom_routes/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool _displayResetButton = false;

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.onRequestLocation});

  final Function() onRequestLocation;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _restartTimer() {
    widget.onRequestLocation();
    final timerService = Provider.of<TimerService>(context, listen: false);
    timerService.resetTimer();
    timerService.startTimer(timerFinished: () {
      _restartTimer();
    });
    if (!timerService.isRunning) {
      _displayResetButton = false;
    }
  }

  void _resetTimer() {
    final timerService = Provider.of<TimerService>(context, listen: false);
    timerService.pauseTimer();
    timerService.resetTimer();
    _displayResetButton = false;
  }

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Countdown from: '),
            DropdownButton(
              value: timerService.selectedTimeInSeconds,
              items: const [
                DropdownMenuItem(value: 5 * 60, child: Text("5 minutes")),
                DropdownMenuItem(value: 10 * 60, child: Text("10 minutes")),
                DropdownMenuItem(value: 15 * 60, child: Text("15 minutes")),
                DropdownMenuItem(value: 30 * 60, child: Text("30 minutes")),
              ],
              onChanged: (value) {
                timerService.selectedTimeInSeconds = value!;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: CircularProgressIndicator(value: timerService.counter / timerService.selectedTimeInSeconds, strokeWidth: 6.0, backgroundColor: Colors.grey[300], valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue)),
            ),
            Text(
              _formatTime(timerService.counter),
              style: const TextStyle(fontSize: 60.0),
            ),
          ],
        ),
        const SizedBox(height: 45),
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!timerService.isRunning) {
                      widget.onRequestLocation();
                      _displayResetButton = true;
                      timerService.startTimer(timerFinished: () {
                        _restartTimer();
                      });
                    } else {
                      timerService.pauseTimer();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        timerService.isRunning ? Icons.pause : Icons.play_arrow,
                        size: 45.0,
                        color: Colors.white,
                      ),
                      // const SizedBox(height: 8.0),
                      // Text(
                      //   timerService.isRunning ? 'Pause' : 'Start',
                      //   style: const TextStyle(fontSize: 18),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_displayResetButton)
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: const Text('Reset'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
