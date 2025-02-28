import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AudioPlayer extends StatefulWidget {
  final ap.AudioSource source;
  final VoidCallback? onDelete;
  final List<double>? aptitudeList;
  final ValueChanged<AudioPlayerState>? onPlay;

  const AudioPlayer({
    super.key,
    required this.source,
    this.onDelete,
    this.aptitudeList,
    this.onPlay,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ap.AudioSource>('source', source));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onDelete', onDelete));
  }
}

class AudioPlayerState extends State<AudioPlayer> with WidgetsBindingObserver {
  late final List<double> _waveData;
  static const double _controlSize = 56;
  static const double _timeTextSize = 24;

  Duration _position = Duration.zero;
  Duration? _duration;
  bool _isPlaying = false;
  bool _hasStarted = false;

  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await pause();
        break;
      case AppLifecycleState.paused:
        await pause();
        break;
      case AppLifecycleState.detached:
        await pause();
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _waveData = widget.aptitudeList ?? [];

    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen((state) async {
      _isPlaying = state.playing;
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });

    _positionChangedSubscription = _audioPlayer.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _durationChangedSubscription = _audioPlayer.durationStream.listen((dur) {
      setState(() {
        _duration = dur;
      });
    });

    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _audioPlayer.setAudioSource(widget.source);
    _duration = _audioPlayer.duration;
    setState(() {});
  }

  Future<void> play() {
    widget.onPlay?.call(this);
    return _audioPlayer.play();
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    _isPlaying = false;
    _position = Duration.zero;
    _hasStarted = false;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final displayDuration = _hasStarted ? _position : _duration ?? _position;

    return Dismissible(
      key: ValueKey(widget.source),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.6},
      background: UiKitBackgroundDismissible(),
      confirmDismiss: (direction) async => direction == DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete?.call(),
      child: UiKitCardWrapper(
        borderRadius: BorderRadiusFoundation.max,
        padding: EdgeInsets.all(EdgeInsetsFoundation.all4),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (_isPlaying) {
                  await pause();
                } else {
                  await play();
                }
              },
              child: Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Center(
                  child: ImageWidget(
                    iconData: _isPlaying ? ShuffleUiKitIcons.pausefill : ShuffleUiKitIcons.playfill,
                    color: Colors.white,
                    height: 20.h,
                  ),
                ),
              ).paddingAll(EdgeInsetsFoundation.all4),
            ),
            SpacingFoundation.horizontalSpace4,
            _buildSlider(theme),
            Text(
              displayDuration.toAudioTime(_duration),
              style: theme?.boldTextTheme.caption1Medium.copyWith(color: ColorsFoundation.darkNeutral700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(UiKitThemeData? theme) {
    final maxDuration = _duration ?? Duration.zero;
    final value = maxDuration.inMilliseconds > 0 ? _position.inMilliseconds / maxDuration.inMilliseconds : 0.0;

    return SizedBox(
      width: 0.8.sw - _controlSize - (_timeTextSize * 1.5),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              size: Size(0.8.sw - _controlSize - _timeTextSize - _timeTextSize, 60),
              painter: WaveformPainter(_waveData, value),
            ),
          ),
          Opacity(
            opacity: widget.aptitudeList != null && widget.aptitudeList!.isNotEmpty ? 0.0 : 1.0,
            child: Slider(
              value: value.clamp(0.0, 1.0),
              activeColor: theme?.colorScheme.inversePrimary,
              inactiveColor: Colors.grey.withValues(alpha: 0.4),
              onChanged: (v) {
                if (_duration != null) {
                  final newPos = Duration(milliseconds: (v * _duration!.inMilliseconds).round());
                  _audioPlayer.seek(newPos);
                  _position = newPos;
                  _hasStarted = true;
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
