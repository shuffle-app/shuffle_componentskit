import 'dart:developer' as dev;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/voice_animation_custom.dart';
import 'package:shuffle_components_kit/presentation/components/voice_component/voice_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:just_audio/just_audio.dart' as ap;

import 'package:shuffle_components_kit/presentation/components/voice_component/audio_player.dart';

class AddVoiceComponent extends StatefulWidget {
  final VoidCallback? onErrorUploadAudioFromDevice;
  final ValueChanged<List<VoiceUiModel?>>? onConfirmTap;
  final bool isLoading;

  const AddVoiceComponent({
    super.key,
    this.onErrorUploadAudioFromDevice,
    this.onConfirmTap,
    this.isLoading = false,
  });

  @override
  State<AddVoiceComponent> createState() => _AddVoiceComponentState();
}

class _AddVoiceComponentState extends State<AddVoiceComponent> {
  final List<double> buffAmplitude = List.empty(growable: true);
  final List<VoiceUiModel?> _voiceUiModels = List.empty(growable: true);
  bool showAudioPlayer = false;

  final ap.AudioPlayer _audioPlayer = ap.AudioPlayer();
  AudioPlayerState? _currentPlayer;

  void _stopCurrentPlayer() {
    _currentPlayer?.pause();
    _currentPlayer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: showAudioPlayer && _voiceUiModels.isNotEmpty && !widget.isLoading
            ? context
                .gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).Confirm,
                    onPressed: () => widget.onConfirmTap?.call(_voiceUiModels),
                  ),
                )
                .paddingOnly(
                  bottom: SpacingFoundation.verticalSpacing24,
                  left: SpacingFoundation.horizontalSpacing16,
                  right: SpacingFoundation.horizontalSpacing16,
                )
            : SizedBox.shrink(),
      ),
      body: BlurredAppBarPage(
        customTitle: Flexible(
          child: AutoSizeText(
            S.of(context).AddVoice,
            style: theme?.boldTextTheme.title1,
            maxLines: 1,
          ),
        ),
        autoImplyLeading: true,
        appBarTrailing: GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['mp3', 'aac', 'wav', 'm4a'],
              withReadStream: true,
            );

            if (result != null) {
              PlatformFile file = result.files.first;

              if (file.path != null && file.path!.isNotEmpty) {
                final source = ap.AudioSource.uri(Uri.parse(file.path!));

                await _audioPlayer.setAudioSource(source);
                _voiceUiModels.add(
                  VoiceUiModel(
                    id: _voiceUiModels.length,
                    path: file.path,
                    duration: _audioPlayer.duration?.inMilliseconds,
                    amplitudes: List.of([]),
                    source: source,
                  ),
                );

                showAudioPlayer = true;
                setState(() {});
              }
            } else {
              dev.log('file is empty');
              widget.onErrorUploadAudioFromDevice?.call();
            }
          },
          child: ImageWidget(
            iconData: ShuffleUiKitIcons.download,
          ),
        ),
        children: [
          if (widget.isLoading)
            SizedBox(
              height: 0.6.sh,
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else ...[
            if (showAudioPlayer && _voiceUiModels.isNotEmpty)
              ..._voiceUiModels.map((item) {
                if (item?.source != null) {
                  return AudioPlayer(
                    key: ValueKey(item!.path),
                    source: item.source!,
                    aptitudeList: item.amplitudes,
                    onDelete: () => _deleteItem(_voiceUiModels.indexWhere((e) => e == item)),
                    onPlay: (playState) {
                      _stopCurrentPlayer();
                      _currentPlayer = playState;
                    },
                  ).paddingOnly(
                    top: SpacingFoundation.verticalSpacing16,
                    left: SpacingFoundation.horizontalSpacing16,
                    right: SpacingFoundation.horizontalSpacing16,
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            SizedBox(
              height: 0.6.sh,
              width: 1.sw,
              child: VoiceAnimationCustom(
                onGetAmplitude: (amplitudes) {
                  buffAmplitude.addAll(amplitudes);
                },
                onStop: (path) async {
                  final source = ap.AudioSource.uri(Uri.parse(path));

                  await _audioPlayer.setAudioSource(source);

                  _voiceUiModels.add(
                    VoiceUiModel(
                      id: _voiceUiModels.length,
                      path: path,
                      duration: _audioPlayer.duration?.inMilliseconds,
                      amplitudes: List.of(buffAmplitude),
                      source: source,
                    ),
                  );

                  buffAmplitude.clear();
                  showAudioPlayer = true;
                  setState(() {});
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    dev.log('_deleteItem ${index}');
    if (index == -1) return;
    _voiceUiModels.removeAt(index);
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
