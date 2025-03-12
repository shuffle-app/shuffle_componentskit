import 'dart:ui';

import 'package:collection/collection.dart';
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
  final VoidCallback? onSocialCardPressed;
  final Function? onPlaceTapped;
  final Function? onTagSortPressed;
  final bool showBusinessContent;
  final List<UiKitTitledCardWithBackground>? chooseYourselfChips;

  SearchComponent({
    super.key,
    required this.searchController,
    required this.showBusinessContent,
    this.scrollController,
    required this.search,
    this.onPlaceTapped,
    this.chooseYourselfChips,
    this.onSearchFieldTap,
    this.onHowItWorksPoped,
    this.onTagSortPressed,
    this.onFreeCardPressed,
    this.onSocialCardPressed,
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

  final _decorationItemsForSocials = [
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.pharmacyPlus.path,
      position: DecorationIconPosition(top: -14, left: -16),
      iconSize: 64,
      rotationAngle: 0,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.deliveryTruck.path,
      position: DecorationIconPosition(bottom: -20, left: 36),
      iconSize: 56,
      rotationAngle: 0,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.parcel.path,
      position: DecorationIconPosition(top: 4, left: 64),
      iconSize: 36,
      rotationAngle: -42,
    ),
    ActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.clothing.path,
      position: DecorationIconPosition(top: -18, left: 112),
      iconSize: 56,
      rotationAngle: 25,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config = GlobalConfiguration().appConfig.content;
    final source = showBusinessContent ? 'search_business' : 'search';
    final model = ComponentSearchModel.fromJson(config[source]);

    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    final title = model.content.title;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    // height: 30.h,
                    child: TitleWithHowItWorks(
                      title: S.of(context).YoullFindIt,
                      textStyle: theme?.boldTextTheme.title1,
                      textAlign: TextAlign.center,
                      shouldShow: search.showHowItWorks && title?[ContentItemType.hintDialog] != null,
                      howItWorksWidget: HowItWorksWidget(
                        title: S.current.SearchHiwTitle,
                        subtitle: S.current.SearchHiwSubtitle,
                        hintTiles: [
                          HintCardUiModel(
                            title: S.current.SearchHiwHint(0),
                            imageUrl: GraphicsFoundation.instance.png.pixelatedSunglassesEmoji.path,
                          ),
                          HintCardUiModel(
                            title: S.current.SearchHiwHint(1),
                            imageUrl: GraphicsFoundation.instance.png.placeEvents.path,
                          ),
                          HintCardUiModel(
                            title: S.current.SearchHiwHint(2),
                            imageUrl: GraphicsFoundation.instance.png.result.path,
                          ),
                          HintCardUiModel(
                            title: S.current.SearchHiwHint(3),
                            imageUrl: GraphicsFoundation.instance.png.rating.path,
                          ),
                        ],
                        onPop: onHowItWorksPoped,
                      ),
                    ),
                  ),
                  SpacingFoundation.verticalSpace16,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onSearchFieldTap,
                    child: IgnorePointer(
                      child: UiKitInputFieldRightIcon(
                        fillColor: theme?.colorScheme.surface3,
                        hintText: S.of(context).Search.toUpperCase(),
                        controller: searchController,
                        icon: ImageWidget(
                          iconData: ShuffleUiKitIcons.search,
                          color: theme?.colorScheme.inversePrimary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
            ),
          ),
        ),
        ListView(
          primary: true,
          padding: EdgeInsets.zero,
          controller: scrollController,
          children: [
            127.h.heightBox,
            UiKitNoActionOverflownCard(
              horizontalMargin: horizontalMargin,
              title: 'Social',
              subtitle: S.current.SocialSubtitle,
              decorationIcons: _decorationItemsForSocials,
              onTap: onSocialCardPressed,
            ),
            SpacingFoundation.verticalSpace24,
            if (model.showFree ?? false) ...[
              UiKitOverflownActionCard(
                horizontalMargin: horizontalMargin,
                action: context.smallButton(
                  data: BaseUiKitButtonData(
                    onPressed: onFreeCardPressed,
                    text: S.current.CheckItOut.toUpperCase(),
                  ),
                ),
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
                            TextSpan(
                              text: S.of(context).FreePlaces,
                              style: theme?.boldTextTheme.subHeadline.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                overflownIconLink: GraphicsFoundation.instance.svg.map.path,
                decorationIcons: _decorationItemsForFreeCards,
              ),
            ],
            SpacingFoundation.verticalSpace24,
            AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chooseYourselfChips != null) ...[
                        Text(
                          S.current.ChooseYourself,
                          style: theme?.boldTextTheme.title1,
                        ).paddingSymmetric(horizontal: horizontalMargin),
                        SpacingFoundation.verticalSpace24,
                        SingleChildScrollView(
                          primary: false,
                          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: SpacingFoundation.horizontalSpacing12,
                            children: chooseYourselfChips!,
                          ),
                        ),
                        SpacingFoundation.verticalSpace24
                      ]
                    ])),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: '${S.of(context).TopPlacesRatedBy('\n')} ', style: theme?.boldTextTheme.title1),
                WidgetSpan(
                  child: Transform.translate(offset: const Offset(0, 4), child: const MemberPlate()),
                ),
              ]),
            ).paddingSymmetric(horizontal: horizontalMargin),
            if (search.filterChips != null && search.filterChips!.isNotEmpty) ...[
              SpacingFoundation.verticalSpace24,
              ConstrainedBox(
                constraints: BoxConstraints.loose(Size(double.infinity, 40.h)),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  primary: false,
                  cacheExtent: 0.0,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => horizontalMargin.widthBox,
                  itemCount: search.filterChips!.length,
                  itemBuilder: (context, index) => UiKitTitledFilterChip(
                    selected: search.activeFilterChips?.contains(search.filterChips![index].title) ?? false,
                    title: search.filterChips![index].title,
                    onPressed:
                        onTagSortPressed == null ? null : () => onTagSortPressed!(search.filterChips![index].title),
                    icon: search.filterChips![index].icon,
                  ),
                ),
              ),
            ],
            SpacingFoundation.verticalSpace24,
            ...search.content.map((e) => UiKitCompactOrderedRatingCard(
                    order: search.content.indexOf(e) + 1,
                    rating: e.rating,
                    title: e.title,
                    imageLink: e.media.firstWhereOrNull((element) => element.type == UiKitMediaType.image)?.link,
                    onPressed: onPlaceTapped == null ? null : () => onPlaceTapped!.call(e.id, e.type))
                .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing12)),
            kBottomNavigationBarHeight.heightBox,
          ],
        ),
        // ).paddingOnly(top: 126.h),
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
    return RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, 1.sw, 118.h),
        bottomLeft: const Radius.circular(24), bottomRight: const Radius.circular(24));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
