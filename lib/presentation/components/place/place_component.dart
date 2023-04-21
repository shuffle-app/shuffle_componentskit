import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PlaceComponent extends StatelessWidget {
  final Place placeData;

  const PlaceComponent({Key? key, required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final PlaceModel model = PlaceModel.fromJson(config['place']);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          vertical: model.positionModel?.verticalMargin ?? 0,
          horizontal: model.positionModel?.horizontalMargin ?? 0),
      child: Column(
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  (model.positionModel?.titleAlignment).mainAxisAlignment,
              crossAxisAlignment:
                  (model.positionModel?.titleAlignment).crossAxisAlignment,
              children: [
                Placeholder(
                  child: SizedBox(
                    width: 280,
                    height: 45,
                  ),
                )
              ]),
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
                descriptionItems: [
                  PlaceDescriptionItem(
                    title: 'Address',
                    description: 'Burj Khalifa 122nd Floor',
                  ),
                  PlaceDescriptionItem(
                    title: 'Open now',
                    description: '9:30 am - 10:30 pm',
                  ),
                  PlaceDescriptionItem(
                    title: 'Website',
                    description: 'atmosphere.com',
                  ),
                  PlaceDescriptionItem(
                    title: 'Phone',
                    description: '+971123596943',
                  ),
                ],
                spacing: 16,
              ),
              SpacingFoundation.verticalSpace16,
              Placeholder(
                child: SizedBox(
                  width: 280,
                  height: 45,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
