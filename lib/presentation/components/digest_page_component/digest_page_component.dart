import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_kit/atoms/cards/digest_content_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DigestPageComponent extends StatefulWidget {
  final String? title;
  final String? underTitleText;
  final List<DigestUiModel>? digestUiModels;
  final AsyncValueGetter<List<String>>? onTranslateListTap;
  final bool showTranslateButton;

  final Function(int placeOrEventId, bool isEvent)? onPlaceOrEventTap;

  const DigestPageComponent({
    super.key,
    this.title,
    this.underTitleText,
    this.digestUiModels,
    this.showTranslateButton = false,
    this.onTranslateListTap,
    this.onPlaceOrEventTap,
  });

  @override
  State<DigestPageComponent> createState() => _DigestPageComponentState();
}

class _DigestPageComponentState extends State<DigestPageComponent> {
  final shufflePostVideoWidgetHeight = 0.16845.sw * 0.75;
  final shufflePostVideoWidgetWidth = 0.16845.sw;
  final playButtonSize = Size(32.w, 24.h);
  late final xOffset = shufflePostVideoWidgetWidth / 2 - playButtonSize.width / 2;
  late final yOffset = shufflePostVideoWidgetHeight / 2 - playButtonSize.height / 2;
  final horizontalSpacing = SpacingFoundation.horizontalSpacing16;

  bool isTranslate = false;
  final List<String> translateListText = List.empty(growable: true);

  Future<void> toggleTranslation() async {
    if (isTranslate) {
      isTranslate = !isTranslate;
    } else {
      if (translateListText.isEmpty) {
        List<String>? translate = await widget.onTranslateListTap?.call();

        if (translate != null && translate.isNotEmpty) translateListText.addAll(translate);
      }

      isTranslate = !isTranslate;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final colorScheme = theme?.colorScheme;
    final isLightTheme = theme?.themeMode == ThemeMode.light;
    int digestTranslateIndex = -1;

    return BlurredAppBarPage(
      customTitle: Flexible(
        child: AutoSizeText(
          S.of(context).ShuffleDigest,
          style: theme?.boldTextTheme.title1,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
      centerTitle: true,
      autoImplyLeading: true,
      children: [
        Row(
          children: [
            if (widget.title != null && widget.title!.isNotEmpty)
              Expanded(
                child: GradientableWidget(
                  gradient: GradientFoundation.attentionCard,
                  child: Text(
                    isTranslate && translateListText.isNotEmpty ? translateListText[0] : widget.title!,
                    style: boldTextTheme?.title2,
                  ),
                ),
              ),
            InkWell(
              onTap: toggleTranslation,
              child: widget.showTranslateButton
                  ? Text(
                      isTranslate ? S.of(context).Original : S.of(context).Translate,
                      style: context.uiKitTheme?.regularTextTheme.caption4Regular.copyWith(
                        color: isLightTheme ? ColorsFoundation.darkNeutral700 : ColorsFoundation.darkNeutral300,
                      ),
                    )
                  : const SizedBox.shrink(),
            ).paddingOnly(left: SpacingFoundation.horizontalSpacing8),
          ],
        ).paddingOnly(
          bottom: SpacingFoundation.verticalSpacing24,
          top: SpacingFoundation.verticalSpacing16,
          left: horizontalSpacing,
          right: horizontalSpacing,
        ),
        if (widget.underTitleText != null && widget.underTitleText!.isNotEmpty)
          Text(
            isTranslate && translateListText.length >= 2 ? translateListText[1] : widget.underTitleText!,
            style: regularTextTheme?.body,
          ).paddingOnly(
            bottom: SpacingFoundation.verticalSpacing24,
            left: horizontalSpacing,
            right: horizontalSpacing,
          ),
        if (widget.digestUiModels != null && widget.digestUiModels!.isNotEmpty)
          ...widget.digestUiModels!.map(
            (e) {
              digestTranslateIndex += 3;
              final id = e.placeId ?? e.eventId ?? -1;
              final isEvent = e.eventId != null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.title != null && e.title!.isNotEmpty)
                    Text(
                      isTranslate && translateListText.length >= digestTranslateIndex
                          ? translateListText[digestTranslateIndex]
                          : e.title!,
                      style: theme?.boldTextTheme.subHeadline,
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                      left: horizontalSpacing,
                      right: horizontalSpacing,
                    ),
                  if (e.placeId != null || e.eventId != null)
                    UiKitCardWrapper(
                      color: colorScheme?.surface1,
                      padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => widget.onPlaceOrEventTap?.call(id, isEvent),
                            child: DigestContentCard(digestUiModel: e),
                          ),
                          SpacingFoundation.verticalSpace8,
                          if (e.contentDescription != null && e.contentDescription!.isNotEmpty)
                            Text(
                              isTranslate && translateListText.length >= digestTranslateIndex + 1
                                  ? translateListText[digestTranslateIndex + 1]
                                  : e.contentDescription!,
                              style: regularTextTheme?.caption4Regular,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                      left: horizontalSpacing,
                      right: horizontalSpacing,
                    ),
                  if (e.newPhotos != null && e.newPhotos!.isNotEmpty)
                    UiKitStaggeredMediaRow(
                      mediaList: e.newPhotos!,
                      visibleMediaCount: 4,
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                      left: horizontalSpacing,
                      right: horizontalSpacing,
                    ),
                  if (e.newVideos != null && e.newVideos!.isNotEmpty)
                    UiKitCustomChildContentUpdateWidget(
                      height: shufflePostVideoWidgetHeight,
                      child: Row(
                        children: e.newVideos!.map(
                          (video) {
                            final isLast = e.newVideos!.last == video;

                            return SizedBox(
                              height: shufflePostVideoWidgetHeight,
                              child: UiKitMediaVideoWidget(
                                width: shufflePostVideoWidgetWidth,
                                playButtonCustomOffset: Offset(xOffset, yOffset),
                                media: video,
                                borderRadius: BorderRadiusFoundation.all8,
                              ).paddingOnly(right: isLast ? 0 : EdgeInsetsFoundation.horizontal16),
                            );
                          },
                        ).toList(),
                      ),
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                      left: horizontalSpacing,
                      right: horizontalSpacing,
                    ),
                  if (e.description != null && e.description!.isNotEmpty)
                    Text(
                      isTranslate && translateListText.length >= digestTranslateIndex + 2
                          ? translateListText[digestTranslateIndex + 2]
                          : e.description!,
                      style: regularTextTheme?.caption2,
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing24,
                      left: horizontalSpacing,
                      right: horizontalSpacing,
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}
