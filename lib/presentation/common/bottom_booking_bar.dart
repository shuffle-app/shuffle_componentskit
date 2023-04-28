import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
class BottomBookingBar extends StatelessWidget {
  final PlaceModel model;
  const BottomBookingBar({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                icon: ImageWidget(
                  svgAsset: Assets.images.svg.route,
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
                icon: ImageWidget(
                  svgAsset: Assets.images.svg.searchPeople,
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
                0.0));
  }
}
