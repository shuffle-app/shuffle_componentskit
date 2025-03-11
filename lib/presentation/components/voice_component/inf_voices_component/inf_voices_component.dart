import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InfVoicesComponent extends StatefulWidget {
  final List<VoiceUiModel> voices;
  final GlobalKey<SliverAnimatedListState> listKey;
  final ValueChanged<int>? onRemoveVoice;
  final bool isOwner;

  const InfVoicesComponent({
    super.key,
    this.voices = const [],
    required this.listKey,
    this.onRemoveVoice,
    this.isOwner = false,
  });

  @override
  State<InfVoicesComponent> createState() => _InfVoicesComponentState();
}

class _InfVoicesComponentState extends State<InfVoicesComponent> {
  final Map<Object, List<VoiceUiModel>> _groupedVoices = {};
  AudioPlayerState? _currentPlayer;

  @override
  void initState() {
    super.initState();
    if (!widget.isOwner) _updateGroupedVoices();
  }

  @override
  void didUpdateWidget(InfVoicesComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.voices != oldWidget.voices && !widget.isOwner) {
      _updateGroupedVoices();
    }
  }

  @override
  void dispose() {
    _currentPlayer?.dispose();
    super.dispose();
  }

  void _updateGroupedVoices() {
    _groupedVoices.clear();
    for (final voice in widget.voices) {
      final key = voice.eventUiModel ?? voice.placeUiModel;
      if (key != null) {
        _groupedVoices.putIfAbsent(key, () => []).add(voice);
      }
    }
  }

  void _handlePlayback(AudioPlayerState newPlayer) {
    _currentPlayer?.pause();
    _currentPlayer = newPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final voices = widget.voices;
    final isOwner = widget.isOwner;
    final hasVoices = voices.isNotEmpty;
    final hasGroups = _groupedVoices.isNotEmpty;

    return BlurredAppBarPage(
      centerTitle: true,
      autoImplyLeading: true,
      customTitle: Flexible(
        child: AutoSizeText(
          S.of(context).Voice,
          style: textTheme?.title1,
          maxLines: 1,
        ),
      ),
      animatedListKey: widget.listKey,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      childrenPadding: EdgeInsets.symmetric(horizontal: SpacingFoundation.horizontalSpacing16),
      childrenCount: isOwner ? (hasVoices ? voices.length : 1) : (hasGroups ? _groupedVoices.length : 1),
      childrenBuilder: (context, index) {
        if (isOwner) {
          if (!hasVoices) {
            return Center(child: Text(S.current.NothingFound, style: textTheme?.body));
          }

          final voice = voices[index];
          final event = voice.eventUiModel;
          final place = voice.placeUiModel;
          final contentTitle = event?.title ?? place?.title;
          final media = event?.media ?? place?.media;
          final horizontalMedia = media?.firstWhereOrNull((m) => m.previewType == UiKitPreviewType.horizontal);
          final imageLink = horizontalMedia?.link ?? media?.firstOrNull?.link;

          return Dismissible(
            key: ValueKey(voice.id),
            direction: DismissDirection.endToStart,
            background: const UiKitBackgroundDismissible(),
            onDismissed: (_) => widget.onRemoveVoice?.call(voice.id),
            child: UiKitContentVoiceReactionCard(
              contentTitle: contentTitle ?? S.current.NothingFound,
              datePosted: voice.createAt,
              imageLink: imageLink,
              customVoiceWidget: AudioPlayer(
                source: voice.source!,
                aptitudeList: voice.amplitudes,
                onPlay: _handlePlayback,
              ),
              properties: [
                ...?event?.tags,
                ...?event?.baseTags,
                ...?place?.tags,
                ...?place?.baseTags,
              ],
            ),
          ).paddingOnly(
            top: SpacingFoundation.verticalSpacing16,
            bottom: index == voices.length - 1 ? kBottomNavigationBarHeight : 0,
          );
        }

        if (!hasGroups) {
          return Center(child: Text(S.current.NothingFound, style: textTheme?.body));
        }

        final groupEntry = _groupedVoices.entries.elementAt(index);
        final entity = groupEntry.key;
        final sources = groupEntry.value;
        final isEvent = entity is UiEventModel;
        final event = isEvent ? entity : null;
        final place = isEvent ? null : entity as UiPlaceModel;
        final media = event?.media ?? place?.media;
        final horizontalMedia = media?.firstWhereOrNull((m) => m.previewType == UiKitPreviewType.horizontal);
        final imageLink = horizontalMedia?.link ?? media?.firstOrNull?.link;

        return UiKitContentVoiceReactionCard(
          contentTitle: (event?.title ?? place?.title) ?? S.current.NothingFound,
          datePosted: sources.firstOrNull?.createAt ?? DateTime.now(),
          imageLink: imageLink,
          customVoiceWidget: Column(
            children: sources
                .map((voice) => AudioPlayer(
                      source: voice.source!,
                      aptitudeList: voice.amplitudes,
                      onPlay: _handlePlayback,
                    ).paddingOnly(
                      bottom: voice == sources.last ? 0 : SpacingFoundation.verticalSpacing8,
                    ))
                .toList(),
          ),
          properties: [
            ...?event?.tags,
            ...?event?.baseTags,
            ...?place?.tags,
            ...?place?.baseTags,
          ],
        ).paddingOnly(
          top: SpacingFoundation.verticalSpacing16,
          bottom: index == _groupedVoices.length - 1 ? kBottomNavigationBarHeight : 0,
        );
      },
    );
  }
}
