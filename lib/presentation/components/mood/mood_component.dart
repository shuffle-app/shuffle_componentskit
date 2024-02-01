import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/mood/widgets/preview_cards_wrapper.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class MoodComponent extends StatelessWidget {
  final UiMoodModel mood;
  final Future<List<UiUniversalModel>>? Function(String name) onTabChanged;
  final Function? onPlacePressed;
  final Function(String level)? onLevelActivated;
  final VoidCallback? onLevelComplited;
  final ScrollController controller;
  final ValueNotifier<bool> isVisibleButton;

  const MoodComponent(
      {Key? key,
      required this.mood,
      this.onPlacePressed,
      required this.controller,
      required this.onTabChanged,
      this.onLevelComplited,
      required this.isVisibleButton,
      this.onLevelActivated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentMoodModel model = ComponentMoodModel.fromJson(config['mood']);

    final theme = context.uiKitTheme;

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final cardWidth = 0.5.sw - horizontalMargin * 2;
    final smallCardHeight = cardWidth / 2 - SpacingFoundation.verticalSpacing8 / 2;

    final titleContent = model.content.title?[ContentItemType.card];
    final tabBarContent = model.content.body?[ContentItemType.tabBar];

    final listOfTabs = List<MapEntry<String, PropertiesBaseModel>>.of(tabBarContent?.properties?.entries ?? []);
    listOfTabs.sort((a, b) => (a.value.sortNumber ?? 0).compareTo((b.value.sortNumber ?? 0)));

    String selectedLevel = mood.activatedLevel ?? listOfTabs.firstOrNull?.value.value ?? '';

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
                message: titleContent?.properties?.keys.firstOrNull ?? S.of(context).ThenCheckThisOut,
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
            Text(
              tabBarContent?.body?[ContentItemType.text]?.properties?.keys.firstOrNull ?? S.of(context).WeHavePlacesJustForYou,
              style: theme?.boldTextTheme.title1,
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace4,
            StatefulBuilder(
              builder: (context, setState) {
                final isIgnoringPointer =
                    !(mood.activatedLevel == null || !listOfTabs.map((e) => e.value.value).contains(mood.activatedLevel!));

                return Column(
                  children: [
                    IgnorePointer(
                      ignoring: isIgnoringPointer,
                      child: UiKitCustomTabBar(
                        selectedTab: mood.activatedLevel?.toUpperCase(),
                        onTappedTab: (index) {
                          setState(() {
                            selectedLevel = listOfTabs[index].value.value ?? '';
                            onTabChanged.call(selectedLevel);
                          });
                        },
                        tabs: listOfTabs
                            .map(
                              (entry) => UiKitCustomTab(
                                height: 20.h,
                                title: entry.key.toUpperCase(),
                                group: tabBarGroup,
                                active: !isIgnoringPointer || entry.key.toUpperCase() == mood.activatedLevel!.toUpperCase(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SpacingFoundation.verticalSpace8,
                    FutureBuilder(
                        future: onTabChanged.call(selectedLevel),
                        builder: (context, AsyncSnapshot<List<UiUniversalModel>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Column(
                              children: snapshot.data?.indexed.map((value) {
                                    final (index, item) = value;
                                    if(index.isOdd) return const SizedBox.shrink();

                                    if(index+1 == snapshot.data!.length){
                                      return PreviewCardsWrapper(
                                        cards:[PlacePreview(
                                          onTap: onPlacePressed,
                                          shouldVisitAt:
                                          //TODO get from DTO
                                          index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                          place: UiPlaceModel(
                                            id: item.id,
                                            title: item.title,
                                            description: item.description,
                                            media: item.media,
                                            weekdays: item.weekdays ?? [],
                                            website: item.website,
                                            tags: item.tags,
                                            baseTags: item.baseTags ?? [],
                                          ),
                                          model: model,
                                        )],
                                        shouldVisitAt: index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                      );
                                    } else {
                                      final secondItem = snapshot.data![index + 1];

                                      return PreviewCardsWrapper(
                                        cards: [
                                          PlacePreview(
                                            onTap: onPlacePressed,
                                            shouldVisitAt:
                                            //TODO get from DTO
                                            index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                            place: UiPlaceModel(
                                              id: item.id,
                                              title: item.title,
                                              description: item.description,
                                              media: item.media,
                                              weekdays: item.weekdays ?? [],
                                              website: item.website,
                                              tags: item.tags,
                                              baseTags: item.baseTags ?? [],
                                            ),
                                            model: model,
                                          ),
                                          PlacePreview(
                                            onTap: onPlacePressed,
                                            shouldVisitAt:
                                            //TODO get from DTO
                                            index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                            place: UiPlaceModel(
                                              id: secondItem.id,
                                              title: secondItem.title,
                                              description: secondItem.description,
                                              media: secondItem.media,
                                              weekdays: secondItem.weekdays ?? [],
                                              website: secondItem.website,
                                              tags: secondItem.tags,
                                              baseTags: secondItem.baseTags ?? [],
                                            ),
                                            model: model,
                                          )
                                        ],
                                        shouldVisitAt: index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                      );
                                    }
                                    //
                                    // return PlacePreview(
                                    //   onTap: onPlacePressed,
                                    //   shouldVisitAt:
                                    //       //TODO get from DTO
                                    //       index == 0 ? DateTime.now() : DateTime.now().add(Duration(days: index)),
                                    //   place: UiPlaceModel(
                                    //     id: item.id,
                                    //     title: item.title,
                                    //     description: item.description,
                                    //     media: item.media,
                                    //     weekdays: item.weekdays ?? [],
                                    //     website: item.website,
                                    //     tags: item.tags,
                                    //     baseTags: item.baseTags ?? [],
                                    //   ),
                                    //   model: model,
                                    // ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12);
                                  }).toList() ??
                                  [],
                            );
                          } else {
                            return SizedBox(
                              height: 156.h * 2,
                              width: double.infinity,
                            );
                          }
                        })
                  ],
                ).paddingSymmetric(horizontal: horizontalMargin);
              },
            ),
            (kBottomNavigationBarHeight + SpacingFoundation.verticalSpacing20 * 3.5).heightBox,
            verticalMargin.heightBox,
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
          onCompletedChild: context.gradientButton(
            data: BaseUiKitButtonData(
              text: S.of(context).GetReward,
              onPressed: onLevelComplited == null ? null : () => onLevelComplited?.call(),
              fit: ButtonFit.fitWidth,
            ),
          ),
        ).paddingSymmetric(horizontal: horizontalMargin),
      ).paddingOnly(bottom: MediaQuery.paddingOf(context).bottom),
    ]);
  }
}
