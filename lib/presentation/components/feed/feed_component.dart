import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedComponent extends StatelessWidget {
  final UiFeedModel feed;
  final PagingController controller;
  final UiMoodModel? mood;
  final Function? onEventPressed;
  final Function(int id, String type, [String? source])? onListItemPressed;
  final Function? onTagSortPressed;
  final VoidCallback? onHowItWorksPoped;
  final VoidCallback? onMoodPressed;
  final VoidCallback? onMoodCheck;
  final VoidCallback? onMoodCompleted;
  final VoidCallback? onHowItWorksPopedBody;
  final VoidCallback? onAdvertisementPressed;
  final bool showBusinessContent;

  const FeedComponent({
    Key? key,
    required this.feed,
    required this.controller,
    required this.showBusinessContent,
    this.mood,
    this.onEventPressed,
    this.onMoodPressed,
    this.onMoodCheck,
    this.onMoodCompleted,
    this.onTagSortPressed,
    this.onHowItWorksPoped,
    this.onHowItWorksPopedBody,
    this.onListItemPressed,
    this.onAdvertisementPressed,
  }) : super(key: key);

  final progressIndicator = const SizedBox(
      width: 20,
      height: 20,
      child: GradientableWidget(
          gradient: GradientFoundation.attentionCard,
          active: true,
          child: CircularProgressIndicator.adaptive(backgroundColor: Colors.white)));

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentFeedModel feedLeisureModel = ComponentFeedModel.fromJson(config['feed']);
    final ComponentFeedModel feedBusinessModel = ComponentFeedModel.fromJson(config['feed_business']);
    MapEntry<String, PropertiesBaseModel>? advertisement;
    if (feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.isNotEmpty ?? false) {
      advertisement = feedLeisureModel.content.body?[ContentItemType.advertisement]?.properties?.entries.first;
    }

    final nicheTitles = feedBusinessModel.content.body?[ContentItemType.horizontalList]?.properties?.keys.toList();
    final nicheData = feedBusinessModel.content.body?[ContentItemType.horizontalList]?.properties;
    final upcomingGlobals =
        feedBusinessModel.content.body?[ContentItemType.horizontalList]?.title?[ContentItemType.horizontalList]?.properties;
    final upcomingGlobalsTitle =
        feedBusinessModel.content.body?[ContentItemType.horizontalList]?.title?[ContentItemType.text]?.properties?.keys.first;
    nicheTitles?.sort((a, b) {
      final aSortNumber = nicheData?[a]?.sortNumber ?? 0;
      final bSortNumber = nicheData?[b]?.sortNumber ?? 0;

      return aSortNumber.compareTo(bSortNumber);
    });
    final horizontalMargin = (feedBusinessModel.positionModel?.horizontalMargin ?? 0).toDouble();

    final themeTitleStyle = context.uiKitTheme?.boldTextTheme.title1;

    final size = MediaQuery.sizeOf(context);

    return CustomScrollView(
      slivers: [
        if (showBusinessContent) ...[
          SizedBox(
            height: MediaQuery.viewPaddingOf(context).top,
          ).wrapSliverBox,
          Text(
            upcomingGlobalsTitle ?? '',
            style: themeTitleStyle,
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: upcomingGlobals?.keys
                      .map<Widget>(
                        (e) => UiKitImageWithDescriptionCard(
                          title: e,
                          imageUrl: upcomingGlobals[e]?.imageLink ?? '',
                          subtitleIcon: GraphicsFoundation.instance.svg.clock.path,
                          subtitle: DateFormat('MMM dd, HH:mm a')
                              .format(DateTime.tryParse(upcomingGlobals[e]?.value ?? '') ?? DateTime.now()),
                          tags: [
                            UiKitTag(
                              title: upcomingGlobals[e]?.type ?? '',
                              iconPath: GraphicsFoundation.instance.svg.label.path,
                            ),
                          ],
                        ).paddingOnly(right: e == upcomingGlobals.keys.last ? 0 : SpacingFoundation.horizontalSpacing12),
                      )
                      .toList() ??
                  [],
            ).paddingSymmetric(horizontal: horizontalMargin),
          ).wrapSliverBox,
          SpacingFoundation.verticalSpace24.wrapSliverBox,
          if (feed.moods != null && (feedBusinessModel.showFeelings ?? true)) ...[
            Stack(
              children: [
                Text('Your niche', style: themeTitleStyle),
                if (feed.showHowItWorksTitle)
                  HowItWorksWidget(
                    element: feedBusinessModel.content.title![ContentItemType.hintDialog]!,
                    onPop: onHowItWorksPoped,
                    customOffset: Offset(1.sw / 1.7, 0),
                  ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          ],
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: SpacingFoundation.horizontalSpacing12,
              children: nicheTitles?.map<Widget>(
                    (e) {
                      double padding = 0.0;
                      if (e == nicheTitles.first) padding = horizontalMargin;

                      return UiKitMessageCardWithIcon(
                        message: e,
                        iconLink: nicheData?[e]?.imageLink,
                        layoutDirection: Axis.vertical,
                        type: MessageCardType.wide,
                      ).paddingOnly(left: padding);
                    },
                  ).toList() ??
                  [],
            ),
          ).wrapSliverBox,
          SpacingFoundation.verticalSpace24.wrapSliverBox,
        ],
        if (!showBusinessContent) ...[
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          if (feed.recommendedEvent != null && (feedLeisureModel.showDailyRecomendation ?? true)) ...[
            SafeArea(
              bottom: false,
              child: UiKitAccentCard(
                onPressed: onEventPressed == null ? null : () => onEventPressed!(feed.recommendedEvent?.id),
                title: feed.recommendedEvent!.title ?? '',
                additionalInfo: feed.recommendedEvent!.descriptionItems?.first.description ?? '',
                accentMessage: 'Don\'t miss it',
                image: ImageWidget(
                  link: feed.recommendedEvent?.media.firstOrNull?.link,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: const UiKitBigPhotoErrorWidget(),
                ),
              ),
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
          if (feed.moods != null && (feedLeisureModel.showFeelings ?? true)) ...[
            Stack(
              children: [
                Text('How’re you feeling tonight?', style: themeTitleStyle),
                if (feed.showHowItWorksTitle)
                  HowItWorksWidget(
                      element: feedLeisureModel.content.title![ContentItemType.hintDialog]!, onPop: onHowItWorksPoped),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace16.wrapSliverBox,
            FingerprintSwitch(
              height: (size.width - horizontalMargin * 2) * 0.54,
              isHealthKitEnabled: feed.isHealthKitEnabled,
              title: Text(
                'Guess',
                style: context.uiKitTheme?.boldTextTheme.subHeadline,
              ),
              backgroundImage: ImageWidget(
                width: double.infinity,
                rasterAsset: GraphicsFoundation.instance.png.dubaiSilhouette,
                fit: BoxFit.cover,
                color: ColorsFoundation.surface2,
              ),
              animationPath: GraphicsFoundation.instance.animations.lottie.animationTouchId.path,
              isCompleted: mood != null,
              onCompleted: onMoodCompleted,
              onPressed: onMoodCheck,
              onCompletedWidget: mood != null
                  ? UiKitMessageCardWithIcon(
                      message: mood!.title,
                      iconLink: mood!.logo,
                      layoutDirection: Axis.vertical,
                      onPressed: onMoodPressed == null ? null : () => onMoodPressed!(),
                    )
                  : const SizedBox.shrink(),
            ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
            SpacingFoundation.verticalSpace24.wrapSliverBox,
          ],
        ],
        if ((feedLeisureModel.showPlaces ?? true)) ...[
          Stack(
            children: [
              Text(
                'You better check this out',
                style: themeTitleStyle,
                textAlign: TextAlign.left,
              ),
              if (feed.showHowItWorksBody)
                HowItWorksWidget(
                    element: feedLeisureModel.content.body![ContentItemType.hintDialog]!, onPop: onHowItWorksPopedBody),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
            SpacingFoundation.verticalSpace8.wrapSliverBox,
            SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RollingDiceButton(
                      onPressed: (value) {
                        final Set<String> list = {};
                        for (int i in value) {
                          list.add(feed.filterChips![i].title);
                        }

                        onTagSortPressed?.call('Random', list);
                      },
                      length: feed.filterChips?.length ?? 0),
                  UiKitTitledFilterChip(
                    selected: feed.activeFilterChips?.map((e) => e.title).contains('Favorites') ?? false,
                    title: 'Favorites',
                    onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!('Favorites'),
                    icon: GraphicsFoundation.instance.svg.star.path,
                  ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8),
                  Wrap(
                    spacing: SpacingFoundation.verticalSpacing8,
                    children: feed.filterChips!.map(
                      (e) {
                        double padding = 0;
                        if (e == feed.filterChips?.last) padding = horizontalMargin;

                        return UiKitTitledFilterChip(
                          selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                          title: e.title,
                          onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                          icon: e.iconPath,
                        ).paddingOnly(right: padding);
                      },
                    ).toList(),
                  ),
                ],
              ).paddingOnly(left: horizontalMargin),
            ).wrapSliverBox,
          ],
          SpacingFoundation.verticalSpace24.wrapSliverBox,
          PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            builderDelegate: PagedChildBuilderDelegate(
              animateTransitions: true,
              firstPageProgressIndicatorBuilder: (c) => const SizedBox.shrink(),
              newPageProgressIndicatorBuilder: (c) => const SizedBox.shrink(),
              itemBuilder: (_, item, index) {
                item as UiUniversalModel;
                if (item.isAdvertisement && advertisement != null) {
                  return context
                      .advertisementBanner(
                        data: BaseUiKitAdvertisementBannerData(
                          availableWidth: 1.sw - (horizontalMargin * 2),
                          onPressed: onAdvertisementPressed,
                          imageLink: item.randomBannerPicture(),
                          title: advertisement.key,
                          size: AdvertisementBannerSize.values.byName(advertisement.value.value ?? 'small'),
                        ),
                      )
                      .paddingSymmetric(horizontal: horizontalMargin);
                }

                return PlacePreview(
                  onTap: (id) => onListItemPressed?.call(id, item.type, item.source),
                  place: UiPlaceModel(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    media: item.media,
                    tags: item.tags,
                    baseTags: item.baseTags ?? [],
                  ),
                  model: feedLeisureModel,
                );
              },
            ),
            itemExtent: 200.h,
            separatorBuilder: (_, i) => SpacingFoundation.verticalSpace24,
            pagingController: controller,
          ),
          SpacingFoundation.verticalSpace24.wrapSliverBox,
          kBottomNavigationBarHeight.heightBox.wrapSliverBox,
        ],
      ],
    ).paddingSymmetric(
      vertical: (feedLeisureModel.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
