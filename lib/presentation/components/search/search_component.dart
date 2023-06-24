import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class SearchComponent extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController? scrollController;
  final UiSearchModel search;
  final VoidCallback? onFreeCardPressed;

  SearchComponent({super.key,
    required this.searchController,
    this.scrollController,
    required this.search,
    this.onFreeCardPressed});

  final _decorationItemsForFreeCards = [
    OverflownActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      position: DecorationIconPosition(
        top: 4,
        right: -4,
      ),
      iconSize: 24,
      rotationAngle: -26,
    ),
    OverflownActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      iconSize: 27,
      position: DecorationIconPosition(
        bottom: 0,
        right: 64,
      ),
      rotationAngle: 47.5,
    ),
    OverflownActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.icecream.path,
      iconSize: 40,
      position: DecorationIconPosition(
        right: 86,
        bottom: 0,
      ),
      rotationAngle: -15,
    ),
    OverflownActionCardDecorationIconData(
      iconLink:
      GraphicsFoundation.instance.png.firstAidKit.path,
      iconSize: 44,
      position: DecorationIconPosition(
        top: 32,
        right: 69,
      ),
      rotationAngle: 30,
    ),
    OverflownActionCardDecorationIconData(
      iconLink: GraphicsFoundation.instance.png.coin.path,
      iconSize: 34,
      position: DecorationIconPosition(
        top: 8,
        right: 30,
      ),
      rotationAngle: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final config = GlobalConfiguration().appConfig.content;
    final model = ComponentSearchModel.fromJson(config['search']);

    final horizontalMargin =
    (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
              (model.positionModel?.titleAlignment).mainAxisAlignment,
              crossAxisAlignment:
              (model.positionModel?.titleAlignment).crossAxisAlignment,
              children: [
                Text(
                  'You’ll find it',
                  style: context.uiKitTheme?.boldTextTheme.title1,
                ).paddingSymmetric(horizontal: horizontalMargin),
                SpacingFoundation.verticalSpace24,
                SizedBox(
                    width: double.infinity,
                    child: UiKitInputFieldRightIcon(
                      hintText: 'search'.toUpperCase(),
                      controller: searchController,
                      icon: searchController.text.isEmpty
                          ? ImageWidget(
                        svgAsset: GraphicsFoundation.instance.svg.search,
                        color: Colors.white.withOpacity(0.5),
                      )
                          : null,
                      // onPressed: () {
                      //   if(preferences.searchController.text.isNotEmpty) preferences.searchController.clear();
                      // },
                    )).paddingSymmetric(horizontal: horizontalMargin),
                if(model.showFree ?? false) ...[
                  SpacingFoundation.verticalSpace24,
                  UiKitOverflownActionCard(
                    horizontalMargin: horizontalMargin,
                    action: context.smallButton(
                      data: BaseUiKitButtonData(
                        onPressed: onFreeCardPressed,
                        text: 'Check out it',
                      ),
                    ),
                    title: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: context.uiKitTheme?.boldTextTheme.body,
                            children: [
                              const TextSpan(
                                text: 'Selection of the best',
                              ),
                              TextSpan(
                                text: '\nfree places',
                                style: context
                                    .uiKitTheme?.boldTextTheme.subHeadline
                                    .copyWith(color: Colors.transparent),
                              ),
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
                                    style: context.uiKitTheme?.boldTextTheme
                                        .body
                                        .copyWith(color: Colors.transparent),
                                  ),
                                  TextSpan(
                                    text: '\nfree places',
                                    style: context
                                        .uiKitTheme?.boldTextTheme.subHeadline,
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                    overflownIconLink: GraphicsFoundation.instance.png.map.path,
                    decorationIcons: _decorationItemsForFreeCards,
                  )
                  // .paddingSymmetric(horizontal: horizontalMargin)
                  ,
                ]
              ]),
          Expanded(child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment:
                (model.positionModel?.bodyAlignment).mainAxisAlignment,
                crossAxisAlignment:
                (model.positionModel?.bodyAlignment).crossAxisAlignment,
                children: [
                  Text(
                    'Choose yourself',
                    style: context.uiKitTheme?.boldTextTheme.title1,
                  ).paddingSymmetric(horizontal: horizontalMargin),
                  SpacingFoundation.verticalSpace24,
                  SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                          spacing: horizontalMargin,
                          children: [
                            const SizedBox.shrink(),
                            ...search.chooseCards.map((item) =>
                                GestureDetector(
                                    onTap: item.callback,
                                    child: UiKitTitledCardWithBackground(
                                      title: item.title,
                                      backgroundImageLink: item.backgroundImage,
                                      backgroundColor: item.backgroundColor,
                                    ))
                            ),
                            const SizedBox.shrink(),
                          ])),
                  SpacingFoundation.verticalSpace24,
                  Text(
                    'Top places',
                    style: context.uiKitTheme?.boldTextTheme.title1,
                  ).paddingSymmetric(horizontal: horizontalMargin),
                  SpacingFoundation.verticalSpace24,
                  const UnderDevelopment().paddingSymmetric(horizontal: horizontalMargin)
                ],
              )
          )
          )
        ],
      ).paddingSymmetric(
          vertical: (model.positionModel?.verticalMargin ?? 0).toDouble()),
    );
  }

}
