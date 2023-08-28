import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchComponent extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController? scrollController;
  final UiSearchModel search;
  final VoidCallback? onFreeCardPressed;
  final VoidCallback? onSearchFieldTap;
  final Function? onPlaceTapped;
  final Function? onTagSortPressed;

  SearchComponent(
      {super.key,
      required this.searchController,
      this.scrollController,
      required this.search,
      this.onPlaceTapped,
      this.onSearchFieldTap,
      this.onTagSortPressed,
      this.onFreeCardPressed});

  final _decorationItemsForFreeCards = [
    ActionCardDecorationIconData(
        iconLink: GraphicsFoundation.instance.png.coin.path,
        position: DecorationIconPosition(top: 4, right: -4),
        iconSize: 24,
        rotationAngle: -26),
    ActionCardDecorationIconData(
        iconLink: GraphicsFoundation.instance.png.coin.path,
        iconSize: 27,
        position: DecorationIconPosition(bottom: 0, right: 64),
        rotationAngle: 47.5),
    ActionCardDecorationIconData(
        iconLink: GraphicsFoundation.instance.png.icecream.path,
        iconSize: 40,
        position: DecorationIconPosition(right: 86, bottom: 0),
        rotationAngle: -15),
    ActionCardDecorationIconData(
        iconLink: GraphicsFoundation.instance.png.firstAidKit.path,
        iconSize: 44,
        position: DecorationIconPosition(top: 32, right: 69),
        rotationAngle: 30),
    ActionCardDecorationIconData(
        iconLink: GraphicsFoundation.instance.png.coin.path,
        iconSize: 34,
        position: DecorationIconPosition(top: 8, right: 30),
        rotationAngle: 0)
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config = GlobalConfiguration().appConfig.content;
    final model = ComponentSearchModel.fromJson(config['search']);

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    final title = model.content.title;
    final body = model.content.body;

    print('model.content ${model.content.body?.keys}');

    final chooseCards = body?[ContentItemType.horizontalList]?.properties?.entries.toList()
      ?..sort((a, b) => a.value.sortNumber!.compareTo(b.value.sortNumber!));

    final sortedCards = chooseCards
            ?.map(
              (e) => UiKitTitledCardWithBackground(
                title: e.key,
                backgroundImageLink: e.value.imageLink ?? '',
                backgroundColor: e.value.color ?? Colors.white,
                onPressed: () {
                  onSearchFieldTap?.call();
                  searchController.text = e.key;
                },
              ),
            )
            .toList() ??
        [];

    return Scaffold(
      body: Column(
        children: [
          SpacingFoundation.verticalSpace16,
          Text(
            title?[ContentItemType.text]?.properties?.keys.firstOrNull ?? 'You’ll find it',
            style: theme?.boldTextTheme.title1,
          ),
          SpacingFoundation.verticalSpace16,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSearchFieldTap,
            child: IgnorePointer(
              child: Hero(
                tag: search.heroSearchTag,
                child: SizedBox(
                  width: double.infinity,
                  child: UiKitInputFieldRightIcon(
                    fillColor: ColorsFoundation.surface3,
                    hintText: 'search'.toUpperCase(),
                    controller: searchController,
                    icon: ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.search,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
          SpacingFoundation.verticalSpace24,
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: (model.positionModel?.bodyAlignment).mainAxisAlignment,
                crossAxisAlignment: (model.positionModel?.bodyAlignment).crossAxisAlignment,
                children: [
                  if (model.showFree ?? false) ...[
                    SpacingFoundation.verticalSpace24,
                    UiKitOverflownActionCard(
                      horizontalMargin: horizontalMargin,
                      action: context.smallButton(data: BaseUiKitButtonData(onPressed: onFreeCardPressed, text: 'Check out it')),
                      title: Stack(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: theme?.boldTextTheme.body,
                              children: [
                                const TextSpan(text: 'Selection of the best'),
                                TextSpan(
                                    text: '\nfree places',
                                    style: theme?.boldTextTheme.subHeadline.copyWith(color: Colors.transparent))
                              ],
                            ),
                          ),
                          GradientableWidget(
                            gradient: GradientFoundation.buttonGradient,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Selection of the best',
                                      style: theme?.boldTextTheme.body.copyWith(color: Colors.transparent)),
                                  TextSpan(text: '\nfree places', style: theme?.boldTextTheme.subHeadline)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      overflownIconLink: GraphicsFoundation.instance.png.map.path,
                      decorationIcons: _decorationItemsForFreeCards,
                    )
                  ],
                  SpacingFoundation.verticalSpace24,
                  Text(
                    body?[ContentItemType.text]?.properties?.keys.firstOrNull ?? 'Choose yourself',
                    style: theme?.boldTextTheme.title1,
                  ).paddingSymmetric(horizontal: horizontalMargin),
                  SpacingFoundation.verticalSpace24,
                  SingleChildScrollView(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: SpacingFoundation.horizontalSpacing12,
                      children: [
                        const SizedBox.shrink(),
                        ...sortedCards,
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SpacingFoundation.verticalSpace24,
                  Stack(clipBehavior: Clip.none, children: [
                    Text('Top places rated\nby', style: theme?.boldTextTheme.title1),
                    () {
                      const MemberPlate widget = MemberPlate();

                      return Positioned(
                        width: widget.width,
                        top: (theme?.boldTextTheme.title1.fontSize ?? 0) * 1.3,
                        left: SizesFoundation.screenWidth / 5,
                        child: widget,
                      );
                    }()
                  ]).paddingSymmetric(horizontal: horizontalMargin),

                  if (search.filterChips != null && search.filterChips!.isNotEmpty) ...[
                    SpacingFoundation.verticalSpace24,
                    SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          horizontalMargin.widthBox,
                          Wrap(
                            spacing: SpacingFoundation.verticalSpacing8,
                            children: search.filterChips!
                                .map(
                                  (e) => UiKitTitledFilterChip(
                                    selected: search.activeFilterChips?.map((e) => e.title).contains(e.title) ?? false,
                                    title: e.title,
                                    onPressed: onTagSortPressed == null ? null : () => onTagSortPressed!(e.title),
                                    icon: e.iconPath,
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                  SpacingFoundation.verticalSpace24,
                  ...search.places
                      .map((e) => UiKitCompactOrderedRatingCard(
                              order: search.places.indexOf(e) + 1,
                              rating: e.rating,
                              title: e.title,
                              imageLink: e.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                              onPressed: onPlaceTapped == null ? null : () => onPlaceTapped!.call(e.id))
                          .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing12))
                      .toList(),
                  SpacingFoundation.verticalSpace24,
                  kBottomNavigationBarHeight.heightBox
                  // MediaQuery.of(context).viewInsets.bottom.heightBox,
                ],
              ),
            ),
          ),
        ],
      ).paddingSymmetric(vertical: (model.positionModel?.verticalMargin ?? 0).toDouble()),
    );
  }
}
