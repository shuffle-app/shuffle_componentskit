import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_kit/atoms/cards/digest_content_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DigestPageComponent extends StatelessWidget {
  final String? title;
  final String? underTitleText;
  final List<DigestUiModel>? digestUiModels;

  final ValueNotifier<bool>? showTranslateButton;
  final ValueNotifier<String>? titleTranslateText;
  final ValueNotifier<String>? underTitleTranslateText;

  late final ValueNotifier<String> titleNotifier;
  late final ValueNotifier<String> underTitleNotifier;
  late final ValueNotifier<bool> isTranslate;

  final Function(int placeOrEventId, bool isEvent)? onPlaceOrEventTap;

  DigestPageComponent({
    super.key,
    this.title,
    this.underTitleText,
    this.digestUiModels,
    this.showTranslateButton,
    this.titleTranslateText,
    this.underTitleTranslateText,
    this.onPlaceOrEventTap,
  }) {
    titleNotifier = ValueNotifier<String>(title ?? '');
    underTitleNotifier = ValueNotifier<String>(underTitleText ?? '');

    isTranslate = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final colorScheme = theme?.colorScheme;
    final isLightTheme = theme?.themeMode == ThemeMode.light;

    final shufflePostVideoWidgetHeight = 0.16845.sw * 0.75;
    final shufflePostVideoWidgetWidth = 0.16845.sw;
    final playButtonSize = Size(32.w, 24.h);
    final xOffset = shufflePostVideoWidgetWidth / 2 - playButtonSize.width / 2;
    final yOffset = shufflePostVideoWidgetHeight / 2 - playButtonSize.height / 2;

    final horizontalSpacing = SpacingFoundation.horizontalSpacing16;

    void toggleTranslation() {
      isTranslate.value = !isTranslate.value;

      ///Translate in publication
      titleNotifier.value = isTranslate.value ? (titleTranslateText?.value ?? title ?? '') : title ?? '';
      underTitleNotifier.value =
          isTranslate.value ? (underTitleTranslateText?.value ?? underTitleText ?? '') : underTitleText ?? '';

      ///Translate in content card
      digestUiModels?.forEach(
        (e) {
          e.contentDescriptionNotifier?.value = isTranslate.value
              ? (e.contentDescriptionTranslate?.value ?? e.contentDescription ?? '')
              : e.contentDescription ?? '';

          e.descriptionNotifier?.value =
              isTranslate.value ? (e.descriptionTranslate?.value ?? e.description ?? '') : e.description ?? '';

          e.subTitleNotifier?.value =
              isTranslate.value ? (e.subTitleTranslate?.value ?? e.subTitle ?? '') : e.subTitle ?? '';
        },
      );
    }

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
            if (titleNotifier.value.isNotEmpty)
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: titleNotifier,
                  builder: (_, titleTranslate, __) => GradientableWidget(
                    gradient: GradientFoundation.attentionCard,
                    child: Text(
                      titleTranslate,
                      style: boldTextTheme?.title2,
                    ),
                  ),
                ),
              ),
            if (showTranslateButton != null)
              ValueListenableBuilder<bool>(
                valueListenable: isTranslate,
                builder: (_, isTranslating, __) => InkWell(
                  onTap: toggleTranslation,
                  child: showTranslateButton!.value
                      ? Text(
                          isTranslating ? S.of(context).Original : S.of(context).Translate,
                          style: context.uiKitTheme?.regularTextTheme.caption4Regular.copyWith(
                            color: isLightTheme ? ColorsFoundation.darkNeutral700 : ColorsFoundation.darkNeutral300,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ).paddingOnly(left: SpacingFoundation.horizontalSpacing8),
          ],
        ).paddingOnly(
          bottom: SpacingFoundation.verticalSpacing24,
          top: SpacingFoundation.verticalSpacing16,
          left: horizontalSpacing,
          right: horizontalSpacing,
        ),
        if (underTitleNotifier.value.isNotEmpty)
          ValueListenableBuilder<String>(
            valueListenable: underTitleNotifier,
            builder: (_, underTitleTranslate, __) => Text(
              underTitleTranslate,
              style: regularTextTheme?.body,
            ).paddingOnly(
              bottom: SpacingFoundation.verticalSpacing24,
              left: horizontalSpacing,
              right: horizontalSpacing,
            ),
          ),
        if (digestUiModels != null && digestUiModels!.isNotEmpty)
          ...digestUiModels!.map(
            (e) {
              final id = e.placeId ?? e.eventId ?? -1;
              final isEvent = e.eventId != null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.subTitleNotifier != null && e.subTitleNotifier!.value.isNotEmpty)
                    ValueListenableBuilder<String>(
                      valueListenable: e.subTitleNotifier!,
                      builder: (_, subTitle, __) => Text(
                        subTitle,
                        style: theme?.boldTextTheme.subHeadline,
                      ).paddingOnly(
                        bottom: SpacingFoundation.verticalSpacing24,
                        left: horizontalSpacing,
                        right: horizontalSpacing,
                      ),
                    ),
                  if (e.placeId != null || e.eventId != null)
                    UiKitCardWrapper(
                      color: colorScheme?.surface1,
                      padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => onPlaceOrEventTap?.call(id, isEvent),
                            child: DigestContentCard(digestUiModel: e),
                          ),
                          SpacingFoundation.verticalSpace8,
                          if (e.contentDescriptionNotifier != null && e.contentDescriptionNotifier!.value.isNotEmpty)
                            ValueListenableBuilder<String>(
                              valueListenable: e.contentDescriptionNotifier!,
                              builder: (_, contentDescriptionTranslate, __) => Text(
                                contentDescriptionTranslate,
                                style: regularTextTheme?.caption4Regular,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                  if (e.descriptionNotifier != null && e.descriptionNotifier!.value.isNotEmpty)
                    ValueListenableBuilder(
                      valueListenable: e.descriptionNotifier!,
                      builder: (_, descriptionTranslate, __) => Text(
                        descriptionTranslate,
                        style: regularTextTheme?.caption2,
                      ),
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
