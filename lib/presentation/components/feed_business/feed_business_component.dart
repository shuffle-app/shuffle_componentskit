import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class FeedBusinessComponent extends StatelessWidget {
  final UiFeedModel feed;
  final PagingController<int, dynamic> controller;
  final UiMoodModel? mood;
  final Function? onEventPressed;
  final Function(int id, String type, [String? source])? onListItemPressed;
  final Function? onTagSortPressed;
  final VoidCallback? onHowItWorksPoped;
  final VoidCallback? onMoodPressed;
  final VoidCallback? onMoodCheck;
  final VoidCallback? onMoodCompleted;
  final VoidCallback? onHowItWorksPopedBody;

  const FeedBusinessComponent(
      {Key? key,
      required this.feed,
      required this.controller,
      this.mood,
      this.onEventPressed,
      this.onMoodPressed,
      this.onMoodCheck,
      this.onMoodCompleted,
      this.onTagSortPressed,
      this.onHowItWorksPoped,
      this.onHowItWorksPopedBody,
      this.onListItemPressed})
      : super(key: key);

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
    final ComponentFeedModel model = ComponentFeedModel.fromJson(config['feed_business']);

    final themeTitleStyle = context.uiKitTheme?.boldTextTheme.title1;
    final nicheTitles = model.content.body?[ContentItemType.horizontalList]?.properties?.keys.toList();
    final nicheData = model.content.body?[ContentItemType.horizontalList]?.properties;
    final upcomingGlobals =
        model.content.body?[ContentItemType.horizontalList]?.title?[ContentItemType.horizontalList]?.properties;
    final upcomingGlobalsTitle =
        model.content.body?[ContentItemType.horizontalList]?.title?[ContentItemType.text]?.properties?.keys.first;
    nicheTitles?.sort((a, b) {
      final aSortNumber = nicheData?[a]?.sortNumber ?? 0;
      final bSortNumber = nicheData?[b]?.sortNumber ?? 0;

      return aSortNumber.compareTo(bSortNumber);
    });
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return CustomScrollView(
      slivers: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ).wrapSliverBox,
        if (true) ...[
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
            ),
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          SpacingFoundation.verticalSpace24.wrapSliverBox,
        ],
        if (feed.moods != null && (model.showFeelings ?? true)) ...[
          Stack(
            children: [
              Text('Your niche', style: themeTitleStyle),
              if (feed.showHowItWorksTitle)
                HowItWorksWidget(
                  element: model.content.title![ContentItemType.hintDialog]!,
                  onPop: onHowItWorksPoped,
                  customOffset: Offset(1.sw / 1.7, 0),
                ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          SpacingFoundation.verticalSpace16.wrapSliverBox,
          SizedBox(
            height: 0.2076.sh,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final niche = nicheTitles?.elementAt(index);

                return UiKitMessageCardWithIcon(
                  message: niche ?? '',
                  iconLink: nicheData?[niche]?.imageLink,
                  layoutDirection: Axis.vertical,
                  type: MessageCardType.wide,
                );
              },
              separatorBuilder: (context, index) => SpacingFoundation.horizontalSpace12,
              itemCount: nicheTitles?.length ?? 0,
            ),
          ).paddingOnly(left: horizontalMargin).wrapSliverBox,
          SpacingFoundation.verticalSpace24.wrapSliverBox,
        ],
        if ((model.showPlaces ?? true)) ...[
          Stack(
            children: [
              Text(
                'You better check this out',
                style: themeTitleStyle,
                textAlign: TextAlign.left,
              ),
              if (feed.showHowItWorksBody)
                HowItWorksWidget(element: model.content.body![ContentItemType.hintDialog]!, onPop: onHowItWorksPopedBody),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin).wrapSliverBox,
          if (feed.filterChips != null && feed.filterChips!.isNotEmpty) ...[
            SpacingFoundation.verticalSpace8.wrapSliverBox,
            SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  context.gradientButton(
                    data: BaseUiKitButtonData(
                      icon: ImageWidget(
                        svgAsset: GraphicsFoundation.instance.svg.dice,
                        height: 17,
                        fit: BoxFit.fitHeight,
                      ),
                      onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!('Random'),
                    ),
                  ),
                  UiKitTitledFilterChip(
                    selected: feed.activeFilterChips?.map((e) => e.title).contains('Favorites') ?? false,
                    title: 'Favorites',
                    onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!('Favorites'),
                    icon: GraphicsFoundation.instance.svg.star.path,
                  ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8),
                  Wrap(
                    spacing: SpacingFoundation.verticalSpacing8,
                    children: feed.filterChips!
                        .map(
                          (e) => UiKitTitledFilterChip(
                            selected: feed.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                            title: e.title,
                            onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                            icon: e.iconPath,
                          ),
                        )
                        .toList(),
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
              firstPageProgressIndicatorBuilder: (c) => progressIndicator,
              newPageProgressIndicatorBuilder: (c) => progressIndicator,
              itemBuilder: (_, item, index) {
                item as UiUniversalModel;

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
                  model: model,
                );
              },
            ),
            itemExtent: 200.h,
            separatorBuilder: (_, i) => SpacingFoundation.verticalSpace24,
            // itemCount: feed.mixedItems!.length + 1,
            pagingController: controller,
          ),
          SpacingFoundation.verticalSpace24.wrapSliverBox,
          kBottomNavigationBarHeight.heightBox.wrapSliverBox,
        ],
      ],
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}
