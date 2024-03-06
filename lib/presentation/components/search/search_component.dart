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

  List<UiKitTitledCardWithBackground> get _mockedBusinessChips => [
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself1,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessClubs.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'business club';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself2,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessConferences.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'conference';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself3,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessSpeech.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'pitch';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself4,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessGames.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'business games';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself5,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessNetworking.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'networking';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchBusinessChooseYourself6,
          backgroundImageLink: GraphicsFoundation.instance.png.searchBusinessTraining.path,
          backgroundColor: Colors.transparent,
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'business training';
          },
        ),
      ];

  List<UiKitTitledCardWithBackground> get _mockedLeisureChips => [
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself1,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryFamily.path,
          backgroundColor: Color(int.parse('FFFA4C34', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'happiness for children and family';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself2,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryAdventure.path,
          backgroundColor: Color(int.parse('FFFAE634', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'thirst for adventure';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself3,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryParty.path,
          backgroundColor: Color(int.parse('FFD808FA', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'parties and dancing';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself4,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryExtreme.path,
          backgroundColor: Color(int.parse('FFFA4C34', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'extremes and thrills';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself5,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryZadrot.path,
          backgroundColor: Color(int.parse('FFFAE634', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'age of enlightenment';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself6,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryFood.path,
          backgroundColor: Color(int.parse('FFD808FA', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'fine dining';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself7,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategoryChill.path,
          backgroundColor: Color(int.parse('FFFA4C34', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'bliss and chill';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself8,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategorySport.path,
          backgroundColor: Color(int.parse('FFFAE634', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'sporty movements';
          },
        ),
        UiKitTitledCardWithBackground(
          title: S.current.SearchChooseYourself9,
          backgroundImageLink: GraphicsFoundation.instance.png.searchCategorySelfCare.path,
          backgroundColor: Color(int.parse('FFD808FA', radix: 16)),
          onPressed: () {
            onSearchFieldTap?.call();
            searchController.text = 'self care';
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config = GlobalConfiguration().appConfig.content;
    final source = showBusinessContent ? 'search_business' : 'search';
    final model = ComponentSearchModel.fromJson(config[source]);
    final showSocial = model.showSocial ?? false;

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
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Text(
                          S.of(context).YoullFindIt,
                          style: theme?.boldTextTheme.title1,
                        ),
                        if (search.showHowItWorks && title?[ContentItemType.hintDialog] != null)
                          HowItWorksWidget(
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
                            customOffset: Offset(0.35.sw, 10),
                            onPop: onHowItWorksPoped,
                          ),
                      ],
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
                          svgAsset: GraphicsFoundation.instance.svg.search,
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
            if (showSocial) ...[
              UiKitNoActionOverflownCard(
                horizontalMargin: horizontalMargin,
                title: 'Social',
                subtitle: S.current.SocialSubtitle,
                decorationIcons: _decorationItemsForSocials,
                onTap: onSocialCardPressed,
              ),
              SpacingFoundation.verticalSpace24,
            ],
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
            Text(
              S.current.ChooseYourself,
              style: theme?.boldTextTheme.title1,
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace24,
            SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: SpacingFoundation.horizontalSpacing12,
                children: chooseYourselfChips ?? (showBusinessContent ? _mockedBusinessChips : _mockedLeisureChips),
              ),
            ).paddingOnly(left: horizontalMargin),
            SpacingFoundation.verticalSpace24,
            Stack(
              clipBehavior: Clip.none,
              children: [
                Text(S.of(context).TopPlacesRatedBy('\n'), style: theme?.boldTextTheme.title1),
                Positioned(
                  top: (theme?.boldTextTheme.title1.fontSize ?? 0) * 1.3,
                  left: SizesFoundation.screenWidth / 5,
                  child: const MemberPlate(),
                ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin),
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
