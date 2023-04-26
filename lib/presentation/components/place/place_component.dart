import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlaceComponent extends StatelessWidget {
  final PlaceModel model;
  final UiKitPlace placeData;
  final List<PlaceDescriptionItem> placeDescriptionItems;

  const PlaceComponent(
      {Key? key,
      required this.placeData,
      required this.placeDescriptionItems,
      required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final PlaceModel model = PlaceModel.fromJson(config['place']);

    return Column(
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                (model.positionModel?.titleAlignment).mainAxisAlignment,
            crossAxisAlignment:
                (model.positionModel?.titleAlignment).crossAxisAlignment,
            children: [
              SpacingFoundation.verticalSpace4,
              TitleWithAvatar(
                title: placeData.title,
                avatarUrl: placeData.logo,
              ),
            ]),
        SpacingFoundation.verticalSpace4,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              (model.positionModel?.bodyAlignment).mainAxisAlignment,
          crossAxisAlignment:
              (model.positionModel?.bodyAlignment).crossAxisAlignment,
          children: [
            PlaceInfo(
              place: placeData,
            ),
            SpacingFoundation.verticalSpace16,
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: UpcomingEventPlaceActionCard(
                      value: 'in 2 days',
                      icon: GraphicsFoundation.instance.svgPicture(
                        asset: Assets.images.svg.star,
                      ),
                      action: () {},
                    ),
                  ),
                  SpacingFoundation.horizontalSpace8,
                  Expanded(
                    child: PointBalancePlaceActionCard(
                      value: '2 650',
                      icon: GraphicsFoundation.instance.svgPicture(
                        asset: Assets.images.svg.star,
                      ),
                      action: () {},
                    ),
                  ),
                ],
              ),
            ),
            SpacingFoundation.verticalSpace16,
            PlaceDescriptionGrid(
              descriptionItems: placeDescriptionItems,
              spacing: 16,
            ),
            SpacingFoundation.verticalSpace16,
            SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment:
                      (model.bookingElementModel?.positionModel?.bodyAlignment)
                          .crossAxisAlignment,
                  mainAxisAlignment:
                      (model.bookingElementModel?.positionModel?.bodyAlignment)
                          .mainAxisAlignment,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (model.bookingElementModel?.showRoute ?? true)
                      context.button(
                        text: 'Button',
                        onPressed: () {},
                        onlyIcon: true,
                        outlined: true,
                        icon: GraphicsFoundation.instance.svgPicture(
                          asset: Assets.images.svg.route,
                          color: Colors.white,
                        ),
                      ),
                    SpacingFoundation.horizontalSpace12,
                    Expanded(
                      child: context.button(
                        text: 'Book it',
                        onPressed: () {},
                        gradient: true,
                      ),
                    ),
                    SpacingFoundation.horizontalSpace12,
                    if (model.bookingElementModel?.showMagnify ?? true)
                      context.button(
                        text: 'Button',
                        onPressed: () {},
                        onlyIcon: true,
                        outlined: true,
                        icon: GraphicsFoundation.instance.svgPicture(
                          asset: Assets.images.svg.searchPeople,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ).paddingSymmetric(
                    vertical: model.bookingElementModel?.positionModel
                            ?.verticalMargin ??
                        0.0,
                    horizontal: model.bookingElementModel?.positionModel
                            ?.horizontalMargin ??
                        0.0)),
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
        vertical: model.positionModel?.verticalMargin ?? 0,
        horizontal: model.positionModel?.horizontalMargin ?? 0);
  }
}
