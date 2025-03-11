import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/audio_player.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/voice_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ShowAllVoicesComponent extends StatefulWidget {
  final List<VoiceUiModel> voices;

  const ShowAllVoicesComponent({
    super.key,
    required this.voices,
  });

  @override
  State<ShowAllVoicesComponent> createState() => _ShowAllVoicesComponentState();
}

class _ShowAllVoicesComponentState extends State<ShowAllVoicesComponent> {
  AudioPlayerState? _currentPlayer;
  final double _avatarSize = 24;
  final double _starIconSize = 10;

  @override
  void dispose() {
    _currentPlayer?.dispose();
    super.dispose();
  }

  void _handlePlayback(AudioPlayerState newPlayer) {
    _currentPlayer?.pause();
    _currentPlayer = newPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textTheme = theme?.regularTextTheme;

    return BlurredAppBarPage(
      title: S.of(context).AllVoices,
      customToolbarBaseHeight: 80.h,
      centerTitle: true,
      autoImplyLeading: true,
      childrenPadding: EdgeInsets.all(EdgeInsetsFoundation.all16),
      childrenCount: widget.voices.length,
      childrenBuilder: (context, index) {
        final item = widget.voices[index];
        final user = item.user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BorderedUserCircleAvatar(
                  imageUrl: user?.avatarUrl,
                  name: user?.name,
                  size: _avatarSize.w,
                  border: GradientFoundation.gradientBorder,
                ),
                SpacingFoundation.horizontalSpace8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user?.name ?? '',
                          style: textTheme?.caption4Regular,
                        ),
                        SpacingFoundation.horizontalSpace8,
                        GradientableWidget(
                          gradient: GradientFoundation.buttonGradient,
                          child: ImageWidget(
                            height: _starIconSize.w,
                            width: _starIconSize.w,
                            iconData: ShuffleUiKitIcons.star2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '@${user?.nickname}',
                      style: textTheme?.caption4Regular.copyWith(
                        color: ColorsFoundation.mutedText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SpacingFoundation.verticalSpace8,
            AudioPlayer(
              key: ValueKey(item.path),
              source: item.source!,
              aptitudeList: item.amplitudes,
              onPlay: _handlePlayback,
            ),
          ],
        );
      },
    );
  }
}
