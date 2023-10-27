import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MoodComponent extends StatelessWidget {
  final UiMoodModel mood;
  final Future<List<UiUniversalModel>>? Function(String name) onTabChanged;
  final Function? onPlacePressed;
  final Function(String level)? onLevelActivated;

  const MoodComponent(
      {Key? key, required this.mood, this.onPlacePressed, required this.onTabChanged, this.onLevelActivated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentMoodModel model = ComponentMoodModel.fromJson(config['mood']);

    final theme = context.uiKitTheme;

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final cardWidth = 0.5.sw - horizontalMargin * 2;
    final smallCardHeight = cardWidth / 2 - SpacingFoundation.verticalSpacing8 / 2;

    final titleContent = model.content.title?[ContentItemType.card];
    final tabBarContent = model.content.body?[ContentItemType.tabBar];

    final listOfTabs = List<MapEntry<String, PropertiesBaseModel>>.of(tabBarContent?.properties?.entries ?? []);
    listOfTabs.sort((a, b) => (a.value.sortNumber ?? 0).compareTo((b.value.sortNumber ?? 0)));

    String selectedLevel = mood.activatedLevel ?? listOfTabs.firstOrNull?.value.value ?? '';

    final AutoSizeGroup tabBarGroup = AutoSizeGroup();

    return Column(
      mainAxisAlignment: bodyAlignment.mainAxisAlignment,
      crossAxisAlignment: bodyAlignment.crossAxisAlignment,
      children: [
        SpacingFoundation.verticalSpace16,
        UiKitMessageCardWithIcon(
          message: mood.title,
          iconLink: mood.logo,
          layoutDirection: Axis.horizontal,
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace14,
        Row(
          children: [
            Flexible(
              child: UiKitGradientAttentionCard(
                message: titleContent?.properties?.keys.firstOrNull ?? 'Then check this out',
                textColor: Colors.black,
                width: cardWidth,
              ),
            ),
            Flexible(
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
                        color: item.active ? Colors.white : UiKitColors.darkNeutral200,
                      ),
                    );
                  }(),
              ],
            ).paddingOnly(left: SpacingFoundation.horizontalSpacing8))
          ],
        ).paddingSymmetric(horizontal: horizontalMargin),
        if (model.showPlaces ?? true && tabBarContent != null) ...[
          SpacingFoundation.verticalSpace24,
          Text(
            tabBarContent?.body?[ContentItemType.text]?.properties?.keys.firstOrNull ?? 'We have places just for you',
            style: theme?.boldTextTheme.title1,
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace4,
          StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                if (mood.activatedLevel == null || !listOfTabs.map((e) => e.value.value).contains(mood.activatedLevel!))
                  UiKitCustomTabBar(
                    onTappedTab: (index) {
                      setState(() {
                        selectedLevel = listOfTabs[index].value.value ?? '';
                      });
                    },
                    tabs: listOfTabs
                        .map((entry) => UiKitCustomTab(
                              title: entry.key.toUpperCase(),
                              group: tabBarGroup,
                            ))
                        .toList(),
                  )
                else
                  Center(
                    child: Text(
                      mood.activatedLevel!,
                      style: theme?.boldTextTheme.title1,
                    ),
                  ),
                SpacingFoundation.verticalSpace16,
                FutureBuilder(
                    future: onTabChanged.call(selectedLevel),
                    builder: (context, AsyncSnapshot<List<UiUniversalModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          children: snapshot.data?.indexed.map((value) {
                                final (index, item) = value;
                                return PlacePreview(
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
                                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12);
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
            );
          }),
          SpacingFoundation.verticalSpace24,
          SlidableButton(
            isCompleted: mood.activatedLevel!=null,
              slidableChild: context.gradientButton(
                  data: BaseUiKitButtonData(text: 'Go!', onPressed: () {}, fit: ButtonFit.hugContent)),
              onCompletedChild: context.gradientButton(
                  data: BaseUiKitButtonData(
                text: 'Get reward',
                onPressed: () => onLevelActivated?.call(selectedLevel),
                fit: ButtonFit.fitWidth,
              ))),
         SpacingFoundation.verticalSpace24,
        ],
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
