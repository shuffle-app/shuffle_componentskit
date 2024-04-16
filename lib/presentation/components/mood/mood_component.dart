import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/mood/widgets/preview_cards_wrapper.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MoodComponent extends StatelessWidget {
  final UiMoodModel mood;
  final Future<UiMoodGameContentModel>? Function(String name) onTabChanged;
  final List<UiUniversalModel> passedCheckins;
  final Function(int id, String type)? onPlacePressed;
  final Function(int id, String type)? onCheckInPressed;
  final Function(String level)? onLevelActivated;
  final VoidCallback? onLevelComplited;
  final ScrollController controller;
  final ValueNotifier<bool> isVisibleButton;
  final bool showHowItWorks;

  const MoodComponent({
    Key? key,
    required this.mood,
    this.onPlacePressed,
    this.onCheckInPressed,
    required this.controller,
    required this.onTabChanged,
    this.onLevelComplited,
    required this.isVisibleButton,
    this.onLevelActivated,
    this.showHowItWorks = false,
    this.passedCheckins = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentMoodModel model = ComponentMoodModel.fromJson(config['mood']);

    final theme = context.uiKitTheme;

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final cardWidth = 0.5.sw - horizontalMargin * 2;
    final smallCardHeight = cardWidth / 2 - SpacingFoundation.verticalSpacing8 / 2;

    final tabBarContent = model.content.body?[ContentItemType.tabBar];

    String selectedLevel = mood.activatedLevel ?? 'easy';

    final AutoSizeGroup tabBarGroup = AutoSizeGroup();

    log('here we are building weather with value ${mood.descriptionItems}', name: 'MoodComponent');

    return Stack(alignment: Alignment.bottomCenter, clipBehavior: Clip.none, children: [
      BlurredAppBarPage(
        title: S.of(context).Feeling,
        autoImplyLeading: true,
        centerTitle: true,
        controller: controller,
        children: [
          verticalMargin.heightBox,
          UiKitMessageCardWithIcon(
            message: mood.title,
            iconLink: mood.logo,
            layoutDirection: Axis.horizontal,
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace14,
          Row(
            children: [
              UiKitGradientAttentionCard(
                message: S.current.ThenCheckThisOut,
                textColor: Colors.black,
                width: cardWidth,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (mood.descriptionItems != null && mood.descriptionItems!.isNotEmpty)
                      () {
                        final item = mood.descriptionItems!.first;

                        return UiKitWeatherInfoCard(
                          weatherType: item.title,
                          temperature: item.description,
                          active: item.active,
                          height: smallCardHeight,
                        );
                      }(),
                    SpacingFoundation.verticalSpacing8.heightBox,
                    if (mood.descriptionItems != null && mood.descriptionItems!.length >= 2)
                      () {
                        final item = mood.descriptionItems!.last;

                        return UiKitMetricsCard(
                          active: item.active,
                          height: smallCardHeight,
                          title: item.title,
                          value: item.description,
                          unit: 'kCal',
                          icon: ImageWidget(
                            svgAsset: Assets.images.svg.fireWhite,
                            height: 18.h,
                            width: 12.w,
                            fit: BoxFit.cover,
                            color: item.active ? theme?.colorScheme.inverseSurface : UiKitColors.darkNeutral200,
                          ),
                        );
                      }(),
                  ],
                ).paddingOnly(left: SpacingFoundation.horizontalSpacing8),
              )
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
          if (model.showPlaces ?? true && tabBarContent != null) ...[
            SpacingFoundation.verticalSpace24,
            Stack(
              children: [
                Text(
                  S.of(context).WeHavePlacesJustForYou,
                  style: theme?.boldTextTheme.title1,
                ).paddingSymmetric(horizontal: horizontalMargin),
                if (showHowItWorks)
                  HowItWorksWidget(
                    title: S.current.CheckInHiwTitle,
                    subtitle: S.current.CheckInHiwSubtitle,
                    hintTiles: [
                      HintCardUiModel(
                        title: S.current.CheckInHiwHint(0),
                        imageUrl: GraphicsFoundation.instance.png.threeLevels.path,
                      ),
                      HintCardUiModel(
                        title: S.current.CheckInHiwHint(1),
                        imageUrl: GraphicsFoundation.instance.png.visitFirst.path,
                      ),
                      HintCardUiModel(
                        title: S.current.CheckInHiwHint(2),
                        imageUrl: GraphicsFoundation.instance.png.checkIn.path,
                      ),
                      HintCardUiModel(
                        title: S.current.CheckInHiwHint(3),
                        imageUrl: GraphicsFoundation.instance.png.reward.path,
                      ),
                    ],
                    customOffset: Offset(0.6.sw, 40),
                  ),
              ],
            ),
            SpacingFoundation.verticalSpace24,
            StatefulBuilder(
              builder: (context, setState) {
                final lvls = ['easy', 'fair', 'hardcore'];
                final isIgnoringPointer = !(mood.activatedLevel == null || !lvls.contains(mood.activatedLevel!));

                log('selected level is ${mood.activatedLevel}', name: 'MoodComponent');

                return Column(
                  children: [
                    IgnorePointer(
                      ignoring: isIgnoringPointer,
                      child: UiKitCustomTabBar(
                        selectedTab: mood.activatedLevel?.toLowerCase(),
                        onTappedTab: (index) {
                          setState(() {
                            selectedLevel = lvls[index];
                            onTabChanged.call(selectedLevel);
                          });
                        },
                        tabs: [
                          UiKitCustomTab(
                            height: 20.h,
                            title: S.current.Easy.toUpperCase(),
                            group: tabBarGroup,
                            active: !isIgnoringPointer || mood.activatedLevel == 'easy',
                            customValue: 'easy',
                          ),
                          UiKitCustomTab(
                            height: 20.h,
                            title: S.current.Fair.toUpperCase(),
                            group: tabBarGroup,
                            active: !isIgnoringPointer || mood.activatedLevel == 'fair',
                            customValue: 'fair',
                          ),
                          UiKitCustomTab(
                            height: 20.h,
                            title: S.current.Hardcore.toUpperCase(),
                            group: tabBarGroup,
                            active: !isIgnoringPointer || mood.activatedLevel == 'hardcore',
                            customValue: 'hardcore',
                          ),
                        ],
                      ),
                    ),
                    SpacingFoundation.verticalSpace8,
                    FutureBuilder(
                      future: onTabChanged.call(selectedLevel),
                      builder: (context, AsyncSnapshot<UiMoodGameContentModel> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final todayContent = snapshot.data?.todayGameContent;
                          final tomorrowContent = snapshot.data?.tomorrowGameContent;
                          final dayAfterTomorrowContent = snapshot.data?.dayAfterTomorrowGameContent;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (todayContent != null)
                                PreviewCardsWrapper(
                                  cards: [
                                    PlacePreview(
                                      onTap: (id) => onPlacePressed?.call(id, todayContent.type),
                                      onCheckIn: mood.activatedLevel != null
                                          ? (passedCheckins.firstWhereOrNull((el) =>
                                                      el.id == todayContent.id && el.type == todayContent.type) !=
                                                  null
                                              ? null
                                              : (id) => onCheckInPressed?.call(id, todayContent.type))
                                          : null,
                                      isFavorite: todayContent.isFavorite,
                                      onFavoriteChanged: todayContent.onFavoriteChanged,
                                      shouldVisitAt: todayContent.shouldVisitAt ?? DateTime.now(),
                                      place: UiPlaceModel(
                                        id: todayContent.id,
                                        title: todayContent.title,
                                        description: todayContent.description,
                                        media: todayContent.media,
                                        weekdays: todayContent.weekdays ?? [],
                                        website: todayContent.website,
                                        tags: todayContent.tags,
                                        baseTags: todayContent.baseTags ?? [],
                                      ),
                                      model: model,
                                    ),
                                  ],
                                  shouldVisitAt: todayContent.shouldVisitAt ?? DateTime.now(),
                                ),
                              if (tomorrowContent != null)
                                PreviewCardsWrapper(
                                  cards: tomorrowContent
                                      .map(
                                        (content) => PlacePreview(
                                          onTap: (id) => onPlacePressed?.call(id, content.type),
                                          onCheckIn: mood.activatedLevel != null
                                              ? (passedCheckins.firstWhereOrNull(
                                                          (el) => el.id == content.id && el.type == content.type) !=
                                                      null
                                                  ? null
                                                  : (id) => onCheckInPressed?.call(id, content.type))
                                              : null,
                                          isFavorite: content.isFavorite,
                                          onFavoriteChanged: content.onFavoriteChanged,
                                          shouldVisitAt:
                                              content.shouldVisitAt ?? DateTime.now().add(const Duration(days: 1)),
                                          place: UiPlaceModel(
                                            id: content.id,
                                            title: content.title,
                                            description: content.description,
                                            media: content.media,
                                            weekdays: content.weekdays ?? [],
                                            website: content.website,
                                            tags: content.tags,
                                            baseTags: content.baseTags ?? [],
                                          ),
                                          model: model,
                                        ),
                                      )
                                      .toList(),
                                  shouldVisitAt: tomorrowContent.first.shouldVisitAt ??
                                      DateTime.now().add(const Duration(days: 1)),
                                ),
                              if (dayAfterTomorrowContent != null)
                                PreviewCardsWrapper(
                                  cards: dayAfterTomorrowContent
                                      .map(
                                        (content) => PlacePreview(
                                          onTap: (id) => onPlacePressed?.call(id, content.type),
                                          onCheckIn: mood.activatedLevel != null
                                              ? (passedCheckins.firstWhereOrNull(
                                                          (el) => el.id == content.id && el.type == content.type) !=
                                                      null
                                                  ? null
                                                  : (id) => onCheckInPressed?.call(id, content.type))
                                              : null,
                                          isFavorite: content.isFavorite,
                                          onFavoriteChanged: content.onFavoriteChanged,
                                          shouldVisitAt:
                                              content.shouldVisitAt ?? DateTime.now().add(const Duration(days: 2)),
                                          place: UiPlaceModel(
                                            id: content.id,
                                            title: content.title,
                                            description: content.description,
                                            media: content.media,
                                            weekdays: content.weekdays ?? [],
                                            website: content.website,
                                            tags: content.tags,
                                            baseTags: content.baseTags ?? [],
                                          ),
                                          model: model,
                                        ),
                                      )
                                      .toList(),
                                  shouldVisitAt: dayAfterTomorrowContent.first.shouldVisitAt ??
                                      DateTime.now().add(const Duration(days: 2)),
                                ),
                            ],
                          );
                        } else {
                          return UiKitShimmerProgressIndicator(
                            gradient: GradientFoundation.greyGradient,
                            child: PlacePreview(
                              onTap: null,
                              place: UiPlaceModel(id: -1, media: [], description: '', tags: []),
                              model: ComponentMoodModel(
                                version: '',
                                content: const ContentBaseModel(),
                                pageBuilderType: PageBuilderType.modalBottomSheet,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: horizontalMargin);
              },
            ),
            SpacingFoundation.bottomNavigationBarSpacing,
            MediaQuery.paddingOf(context).bottom.heightBox,
          ],
        ],
      ),
      ValueListenableBuilder<bool>(
        valueListenable: isVisibleButton,
        builder: (context, value, child) =>
            AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: value ? 1 : 0, child: child!),
        child: SlidableButton(
          onTap: () {
            showUiKitAlertDialog(
                context,
                AlertDialogData(
                    title: Align(
                        alignment: Alignment.center,
                        child: Text(
                          S.current.YouCanGet,
                          textAlign: TextAlign.center,
                          style: theme?.boldTextTheme.title2.copyWith(color: theme.colorScheme.primary),
                        )),
                    defaultButtonText: '',
                    additionalButton: context.button(
                        data: BaseUiKitButtonData(
                            text: S.current.OkayCool.toUpperCase(),
                            fit: ButtonFit.fitWidth,
                            onPressed: () => navigatorKey.currentState?.pop(),
                            textColor: theme?.colorScheme.inversePrimary,
                            backgroundColor: theme?.colorScheme.primary)),
                    content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          S.current.DifferentNumberOfPoints,
                          S.current.RealMoney,
                          S.current.InventoryItems,
                          S.current.DubaiEventTicket
                        ]
                            .map(
                              (e) => Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GradientableWidget(
                                    gradient: GradientFoundation.starLinearGradient,
                                    child: ImageWidget(
                                      iconData: ShuffleUiKitIcons.gradientStar,
                                      color: Colors.white,
                                      width: 0.0625.sw,
                                      height: 0.0625.sw,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SpacingFoundation.horizontalSpace8,
                                  Expanded(
                                    child: Text(
                                      e,
                                      style: theme?.regularTextTheme.body.copyWith(color: theme.colorScheme.primary),
                                    ),
                                  ),
                                ],
                              ).paddingSymmetric(
                                vertical: SpacingFoundation.verticalSpacing6,
                              ),
                            )
                            .toList())));
          },
          isCompleted: mood.activatedLevel != null,
          customBorder: mood.activatedLevel == null || onLevelComplited != null
              ? null
              : const Border.fromBorderSide(BorderSide(color: UiKitColors.gradientGreyLight2, width: 2)),
          slidableChild: context.gradientButton(
              data: BaseUiKitButtonData(text: S.of(context).Go, onPressed: () {}, fit: ButtonFit.hugContent)),
          onCompleted: () {
            onLevelActivated?.call(selectedLevel);
          },
          onCompletedChild: GestureDetector(
            onTap: () {
              showUiKitGeneralFullScreenDialog(
                  context,
                  GeneralDialogData(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              S.current.YouCanGet,
                              style: theme?.boldTextTheme.title2,
                            ),
                          ),
                          SpacingFoundation.verticalSpace8,
                          ...[
                            S.current.DifferentNumberOfPoints,
                            S.current.RealMoney,
                            S.current.InventoryItems,
                            S.current.DubaiEventTicket
                          ].map(
                            (e) => Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientableWidget(
                                  gradient: GradientFoundation.starLinearGradient,
                                  child: ImageWidget(
                                    iconData: ShuffleUiKitIcons.gradientStar,
                                    color: Colors.white,
                                    width: 0.0625.sw,
                                    height: 0.0625.sw,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SpacingFoundation.horizontalSpace8,
                                Expanded(
                                  child: Text(
                                    e,
                                    style: theme?.regularTextTheme.body,
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(
                                vertical: SpacingFoundation.verticalSpacing8,
                                horizontal: SpacingFoundation.horizontalSpacing16),
                          ),
                          SpacingFoundation.verticalSpace8,
                        ],
                      ),
                      topPadding: 0.6.sh));
            },
            child: context.gradientButton(
              data: BaseUiKitButtonData(
                text: S.of(context).GetReward,
                onPressed: onLevelComplited == null ? null : () => onLevelComplited?.call(),
                fit: ButtonFit.fitWidth,
              ),
            ),
          ),
        ).paddingSymmetric(horizontal: horizontalMargin),
      ).paddingOnly(bottom: MediaQuery.paddingOf(context).bottom),
    ]);
  }
}

showCongrats(int points) {
  final theme = navigatorKey.currentContext!.uiKitTheme;

  return showUiKitGeneralFullScreenDialog(
      navigatorKey.currentContext!,
      GeneralDialogData(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                  top: 40.h,
                  child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                      theme!.colorScheme.surface1.withOpacity(0.4),
                      theme.colorScheme.surface1.withOpacity(0.6),
                      theme.colorScheme.surface1.withOpacity(0.8),
                      theme.colorScheme.surface1.withOpacity(1),
                    ])),
                    child: ImageWidget(
                        svgAsset: GraphicsFoundation.instance.svg.logo, height: 90.h, fit: BoxFit.fitHeight),
                  )),
              Column(children: [
                Text(
                  S.current.Congratulations,
                  style: theme.boldTextTheme.title2,
                ),
                Text(
                  S.current.YouReceived,
                  style: theme.boldTextTheme.title2,
                ),
                SpacingFoundation.verticalSpace24,
                Text(
                  '$points\n${S.current.Points}',
                  textAlign: TextAlign.center,
                  style: theme.boldTextTheme.title2,
                ),
              ]),
            ],
          ),
          topPadding: 0.65.sh));
}
