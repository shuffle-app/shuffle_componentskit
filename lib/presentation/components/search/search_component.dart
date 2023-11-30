import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchComponent extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController? scrollController;
  final UiSearchModel search;
  final VoidCallback? onFreeCardPressed;
  final VoidCallback? onSearchFieldTap;
  final VoidCallback? onHowItWorksPoped;
  final Function? onPlaceTapped;
  final Function? onTagSortPressed;
  final bool showBusinessContent;

  SearchComponent({
    super.key,
    required this.searchController,
    required this.showBusinessContent,
    this.scrollController,
    required this.search,
    this.onPlaceTapped,
    this.onSearchFieldTap,
    this.onHowItWorksPoped,
    this.onTagSortPressed,
    this.onFreeCardPressed,
  });

  final _decorationItemsForFreeCards = [
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      position: DecorationIconPosition(top: 4, right: -4),
      iconSize: 24,
      rotationAngle: -26,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      iconSize: 27,
      position: DecorationIconPosition(bottom: 0, right: 64),
      rotationAngle: 47.5,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.icecream.path,
      iconSize: 40,
      position: DecorationIconPosition(right: 96, bottom: -8),
      rotationAngle: -15,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.firstAidKit.path,
      iconSize: 44,
      position: DecorationIconPosition(top: 32, right: 85),
      rotationAngle: 30,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      iconSize: 34,
      position: DecorationIconPosition(top: 8, right: 30),
      rotationAngle: 0,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config = GlobalConfiguration().appConfig.content;
    final source = showBusinessContent ? 'search_business' : 'search';
    final model = ComponentSearchModel.fromJson(config[source]);

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    final title = model.content.title;
    final body = model.content.body;

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

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
            borderRadius: BorderRadiusFoundation.onlyBottom24,
            clipper: _CustomBlurClipper(),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: SafeArea(
                    bottom: false,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                          width: double.infinity,
                          // height: 30.h,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Text(
                                title?[ContentItemType.text]?.properties?.keys.firstOrNull ?? S.of(context).YoullFindIt,
                                style: theme?.boldTextTheme.title1,
                              ),
                              if (search.showHowItWorks && title?[ContentItemType.hintDialog] != null)
                                HowItWorksWidget(
                                    customOffset: Offset(0.35.sw, 10),
                                    element: title![ContentItemType.hintDialog]!,
                                    onPop: onHowItWorksPoped),
                            ],
                          )),
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
                                fillColor: theme?.colorScheme.surface3,
                                hintText: S.of(context).Search.toUpperCase(),
                                controller: searchController,
                                icon: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.search,
                                  color: theme?.colorScheme.inversePrimary.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16)))),
        // SpacingFoundation.verticalSpace24,
        ListView(
          clipBehavior: Clip.none,
          primary: true,
          padding: EdgeInsets.zero,
          controller: scrollController,
          // child: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: (model.positionModel?.bodyAlignment).mainAxisAlignment,
          //   crossAxisAlignment: (model.positionModel?.bodyAlignment).crossAxisAlignment,
          children: [
            if (model.showFree ?? false) ...[
              UiKitOverflownActionCard(
                horizontalMargin: horizontalMargin,
                action: context.smallButton(data: BaseUiKitButtonData(onPressed: onFreeCardPressed, text: 'Check out it')),
                title: Stack(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: theme?.boldTextTheme.body,
                        children: [
                          TextSpan(text: S.of(context).SelectionOfTheBest),
                          TextSpan(
                            text: S.of(context).FreePlaces,
                            style: theme?.boldTextTheme.subHeadline.copyWith(color: Colors.transparent),
                          )
                        ],
                      ),
                    ),
                    GradientableWidget(
                      gradient: GradientFoundation.buttonGradient,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: S.of(context).SelectionOfTheBest,
                              style: theme?.boldTextTheme.body.copyWith(color: Colors.transparent),
                            ),
                            TextSpan(text: S.of(context).FreePlaces, style: theme?.boldTextTheme.subHeadline)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                overflownIconLink: GraphicsFoundation.instance.svg.map.path,
                decorationIcons: _decorationItemsForFreeCards,
              ).paddingOnly(right: horizontalMargin),
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
                children: sortedCards,
              ),
            ).paddingOnly(left: horizontalMargin),
            SpacingFoundation.verticalSpace24,
            Stack(clipBehavior: Clip.none, children: [
              Text(S.of(context).TopPlacesRatedBy, style: theme?.boldTextTheme.title1),
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
                              icon: e.icon,
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
            kBottomNavigationBarHeight.heightBox,
          ],
        ).paddingOnly(top: 118.h),
        // ),
      ].reversed.toList(),
    ).paddingSymmetric(
      vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
    );
  }
}

class _CustomBlurClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, 1.sw, 110.h),
        bottomLeft: const Radius.circular(24), bottomRight: const Radius.circular(24));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
