import 'dart:async';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VoiceAnimationCustom extends StatefulWidget {
  final VoidCallback? onPlay;
  final ValueChanged<String>? onStop;
  final ValueChanged<List<double>>? onGetAmplitude;

  const VoiceAnimationCustom({
    super.key,
    this.onStop,
    this.onGetAmplitude,
    this.onPlay,
  });

  @override
  State<VoiceAnimationCustom> createState() => _VoiceAnimationCustomState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function(String path)>.has('onStop', onStop));
  }
}

class _VoiceAnimationCustomState extends State<VoiceAnimationCustom> {
  bool _isTimeLimit = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  Timer? _startDelayTimer;
  final AudioRecorder _audioRecorder = AudioRecorder();
  Amplitude? _amplitude;
  final List<double> _amplitudeList = [];

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _startDelayTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
        widget.onPlay?.call();

        _isTimeLimit = false;
        setState(() {
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final String? path = await _audioRecorder.stop();

    if (_recordDuration > 1 && path != null) {
      widget.onStop?.call(path);
      widget.onGetAmplitude?.call(List.from(_amplitudeList));
    }

    setState(() {
      _amplitudeList.clear();
    });
  }

  ///if you need to pause for voice input

  // Future<void> _pause() async {
  //   _timer?.cancel();
  //   _ampTimer?.cancel();
  //   await _audioRecorder.pause();

  //   setState(() {
  //     _isPaused = true;
  //     _isRecording = false;
  //   });
  // }

  // Future<void> _resume() async {
  //   _startTimer();
  //   await _audioRecorder.resume();

  //   setState(() {
  //     _isPaused = false;
  //     _isRecording = true;
  //   });
  // }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);

      /// 30 minute limit
      if (_recordDuration > 1800) {
        _isTimeLimit = true;
        _stop();
      }
    });

    _ampTimer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      _amplitudeList.add((_amplitude?.current.clamp(-100, 100) ?? 0.0) + 50);
      setState(() {});
    });
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.expand,
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: 400,
          height: 400,
          child: GestureDetector(
            onTapDown: (details) {
              _startDelayTimer = Timer(Duration(milliseconds: 250), () {
                _start();
              });
            },
            onTapUp: (details) {
              _startDelayTimer?.cancel();
              _stop();
            },
            onTapCancel: () {
              if (!_isTimeLimit) {
                _startDelayTimer?.cancel();
                _stop();
              }
            },
            child: UiKitGradientedDecoratedButtonPrioritized(
              iconData: ShuffleUiKitIcons.record,
              audioLevel: 40 + (_amplitude?.current ?? 0.0),
            ),
          ),
        ),
        Positioned(
          bottom: 0.12.sh,
          child: UiKitAudioWavePrioritized(
            amplitudes: _amplitudeList,
            scrollable: true,
          ),
        ),
        Positioned(
          bottom: 0.05.sh,
          child: GradientableWidget(
            gradient: GradientFoundation.defaultLinearGradient,
            child: Text(
              '$minutes : $seconds ',
              style: theme?.regularTextTheme.caption2,
            ),
          ),
        ),
      ],
    );
  }
}
