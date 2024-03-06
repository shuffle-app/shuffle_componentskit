import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/mood/widgets/preview_cards_wrapper.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MoodComponent extends StatelessWidget {
  final UiMoodModel mood;
  final Future<UiMoodGameContentModel>? Function(String name) onTabChanged;
  final Function? onPlacePressed;
  final Function(String level)? onLevelActivated;
  final VoidCallback? onLevelComplited;
  final ScrollController controller;
  final ValueNotifier<bool> isVisibleButton;
  final bool rewardIsUnderDev;
  final bool showHowItWorks;

  const MoodComponent({
    Key? key,
    required this.mood,
    this.onPlacePressed,
    required this.controller,
    required this.onTabChanged,
    this.onLevelComplited,
    required this.isVisibleButton,
    this.onLevelActivated,
    this.rewardIsUnderDev = false,
    this.showHowItWorks = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentMoodModel model = ComponentMoodModel.fromJson(config['mood']);

    final theme = context.uiKitTheme;

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final cardWidth = 0.5.sw - horizontalMargin * 2;
    final smallCardHeight = cardWidth / 2 - SpacingFoundation.verticalSpacing8 / 2;

    final tabBarContent = model.content.body?[ContentItemType.tabBar];

    String selectedLevel = mood.activatedLevel ?? 'easy';

    final AutoSizeGroup tabBarGroup = AutoSizeGroup();

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
                          active: !item.active,
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
                    customOffset: Offset(0.6.sw, 24),
                  ),
              ],
            ),
            SpacingFoundation.verticalSpace24,
            StatefulBuilder(
              builder: (context, setState) {
                final lvls = ['easy','fair', 'hardcore'];
                final isIgnoringPointer =
                    !(mood.activatedLevel == null || !lvls.contains(mood.activatedLevel!));

                return Column(
                  children: [
                    IgnorePointer(
                      ignoring: isIgnoringPointer,
                      child: UiKitCustomTabBar(
                        selectedTab: mood.activatedLevel?.toUpperCase(),
                        onTappedTab: (index) {
                          setState(() {
                            selectedLevel = lvls[index] ?? '';
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
                                      onTap: onPlacePressed,
                                      isFavorite: todayContent.isFavorite,
                                      onFavoriteChanged: todayContent.onFavoriteChanged,
                                      shouldVisitAt: DateTime.now(),
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
                                  shouldVisitAt: DateTime.now(),
                                ),
                              if (tomorrowContent != null)
                                PreviewCardsWrapper(
                                  cards: tomorrowContent
                                      .map(
                                        (content) => PlacePreview(
                                          onTap: onPlacePressed,
                                          isFavorite: content.isFavorite,
                                          onFavoriteChanged: content.onFavoriteChanged,
                                          shouldVisitAt: DateTime.now().add(const Duration(days: 1)),
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
                                  shouldVisitAt: DateTime.now().add(const Duration(days: 1)),
                                ),
                              if (dayAfterTomorrowContent != null)
                                PreviewCardsWrapper(
                                  cards: dayAfterTomorrowContent
                                      .map(
                                        (content) => PlacePreview(
                                          onTap: onPlacePressed,
                                          isFavorite: content.isFavorite,
                                          onFavoriteChanged: content.onFavoriteChanged,
                                          shouldVisitAt: DateTime.now().add(const Duration(days: 2)),
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
                                  shouldVisitAt: DateTime.now().add(const Duration(days: 2)),
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
          isCompleted: mood.activatedLevel != null,
          customBorder: mood.activatedLevel == null || onLevelComplited != null
              ? null
              : const Border.fromBorderSide(BorderSide(color: UiKitColors.gradientGreyLight2, width: 2)),
          slidableChild: context.gradientButton(
              data: BaseUiKitButtonData(text: S.of(context).Go, onPressed: () {}, fit: ButtonFit.hugContent)),
          onCompleted: () => onLevelActivated?.call(selectedLevel),
          onCompletedChild: GestureDetector(
            onTap: rewardIsUnderDev
                ? () => showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        topPadding: 0.5.sh,
                        child: const UnderDevelopment().paddingOnly(top: 0.125.sh),
                      ),
                    )
                : null,
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
