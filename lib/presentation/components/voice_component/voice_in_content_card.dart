import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/voice_ui_model.dart';

import 'package:just_audio/just_audio.dart' as ap;
import 'package:shuffle_uikit/shuffle_uikit.dart';

class VoiceInContentCard extends StatefulWidget {
  final VoiceUiModel voice;
  final VoidCallback? onViewAllTap;

  const VoiceInContentCard({
    super.key,
    required this.voice,
    this.onViewAllTap,
  });

  @override
  State<VoiceInContentCard> createState() => _VoicesUiContentCardState();
}

class _VoicesUiContentCardState extends State<VoiceInContentCard> with WidgetsBindingObserver {
  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  Duration? _duration;
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  bool _isPlaying = false;

  Future<void> _init() async {
    await _audioPlayer.setAudioSource(widget.voice.source!);
    _duration = _audioPlayer.duration;
    setState(() {});
  }

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

    _playerStateChangedSubscription = _audioPlayer.playerStateStream.listen((state) async {
      _isPlaying = state.playing;
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });

    _durationChangedSubscription = _audioPlayer.durationStream.listen((dur) {
      setState(() {
        _duration = dur;
      });
    });

    _init();
    super.initState();
  }

  Future<void> play() {
    // widget.onPlay?.call(this);
    return _audioPlayer.play();
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    _isPlaying = false;
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final colorScheme = theme?.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            MemberPlate(),
            SpacingFoundation.horizontalSpace8,
            Text(
              S.current.AboutUs,
              style: boldTextTheme?.subHeadline,
            ),
          ],
        ),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: colorScheme?.surface1,
          borderRadius: BorderRadiusFoundation.all32,
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
              SpacingFoundation.horizontalSpace12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.6.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${_duration?.toAudioTime(_duration)} ${S.current.Voice}',
                            style: boldTextTheme?.caption3Medium,
                          ),
                        ),
                        SpacingFoundation.horizontalSpace2,
                        GestureDetector(
                          onTap: widget.onViewAllTap,
                          child: Text(
                            S.current.ViewAll,
                            style: boldTextTheme?.caption2Bold.copyWith(
                              color: colorScheme?.darkNeutral300,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SpacingFoundation.verticalSpace2,
                  Row(
                    children: [
                      BorderedUserCircleAvatar(
                        imageUrl: widget.voice.user?.avatarUrl,
                        name: widget.voice.user?.name,
                        size: 24,
                        border: GradientFoundation.gradientBorder,
                      ),
                      SpacingFoundation.horizontalSpace8,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.voice.user?.name ?? '',
                                style: regularTextTheme?.caption4Regular,
                              ),
                              SpacingFoundation.horizontalSpace8,
                              GradientableWidget(
                                gradient: GradientFoundation.buttonGradient,
                                child: ImageWidget(
                                  height: 10.w,
                                  width: 10.w,
                                  fit: BoxFit.contain,
                                  iconData: ShuffleUiKitIcons.star2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '@${widget.voice.user?.nickname}',
                            style: regularTextTheme?.caption4Regular.copyWith(
                              color: ColorsFoundation.mutedText,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ).paddingAll(EdgeInsetsFoundation.all16),
        )
      ],
    );
  }
}
