import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatelessWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;

  const BottomBookingBar(
      {Key? key,
      required this.model,
      this.onShowRoute,
      this.onBook,
      this.onMagnify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          mainAxisSize: MainAxisSize.max,
          children: (){
            final svg = Assets.images.svg;

            return [
              if (model.showRoute ?? true)
                context.outlinedButton(
                  onPressed: onShowRoute,
                  icon: ImageWidget(
                    svgAsset: svg.route,
                    color: Colors.white,
                  ),
                ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: context.gradientButton(
                  text: 'Book it',
                  onPressed: onBook,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              if (model.showMagnify ?? true)
                context.outlinedButton(
                  onPressed: onMagnify,
                  icon: ImageWidget(
                    svgAsset: svg.searchPeople,
                    color: Colors.white,
                  ),
                ),
            ];}()

        ).paddingSymmetric(
            vertical: model.positionModel?.verticalMargin ?? 0.0,
            horizontal: model.positionModel?.horizontalMargin ?? 0.0));
  }
}
