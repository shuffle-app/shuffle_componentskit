import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_uikit/ui_kit/atoms/cards/digest_content_card.dart';

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

  DigestPageComponent({
    super.key,
    this.title,
    this.underTitleText,
    this.digestUiModels,
    this.showTranslateButton,
    this.titleTranslateText,
    this.underTitleTranslateText,
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

          log('e.descriptionTranslate?.value ${e.descriptionTranslate?.value}');
          log(' e.descriptionNotifier?.value  ${e.descriptionNotifier?.value}');
        },
      );
    }

    return BlurredAppBarPage(
      title: S.of(context).ShuffleDigest,
      centerTitle: true,
      autoImplyLeading: true,
      children: [
        Row(
          children: [
            if (titleNotifier.value.isNotEmpty)
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: titleNotifier,
                  builder: (_, titleTranslate, __) => Text(
                    titleTranslate,
                    style: boldTextTheme?.title2,
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
              ),
          ],
        ).paddingOnly(
          bottom: SpacingFoundation.verticalSpacing24,
          top: SpacingFoundation.verticalSpacing16,
          left: horizontalSpacing,
          right: horizontalSpacing,
        ),
        if (underTitleNotifier.value.isNotEmpty)
          Expanded(
            child: ValueListenableBuilder<String>(
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
          ),
        if (digestUiModels != null && digestUiModels!.isNotEmpty)
          ...digestUiModels!.map(
            (e) {
              return UiKitCardWrapper(
                color: colorScheme?.surface1,
                padding: EdgeInsets.all(EdgeInsetsFoundation.all16),
                child: Column(
                  children: [
                    DigestContentCard(digestUiModel: e),
                    SpacingFoundation.verticalSpace8,
                    if (e.descriptionNotifier != null && e.descriptionNotifier!.value.isNotEmpty)
                      ValueListenableBuilder(
                        // вот этот текст не меняется
                        valueListenable: e.descriptionNotifier!,
                        builder: (_, descriptionTranslate, __) => Text(
                          descriptionTranslate,
                          style: regularTextTheme?.caption2,
                        ),
                      ),
                  ],
                ),
              ).paddingOnly(
                bottom: SpacingFoundation.verticalSpacing24,
                left: horizontalSpacing,
                right: horizontalSpacing,
              );
            },
          ),
      ],
    );
  }
}
