import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatelessWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;
  final bool isLoading;

  const BottomBookingBar({Key? key,
    required this.model,
    this.onShowRoute,
    this.onBook,
    this.isLoading = false,
    this.onMagnify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
            top: false,
            child: Row(
                crossAxisAlignment: bodyAlignment.crossAxisAlignment,
                mainAxisAlignment: bodyAlignment.mainAxisAlignment,
                mainAxisSize: MainAxisSize.max,
                children: () {
                  final svg = Assets.images.svg;

                  return [
                    if (model.showRoute ?? true)
                      context.smallOutlinedButton(
                        blurred: true,
                        data: BaseUiKitButtonData(
                            onPressed: onShowRoute,
                            icon: ImageWidget(
                              height:26.sp,
                              svgAsset: svg.route,
                              color: Colors.white,
                            )),
                      ),
                    SpacingFoundation.horizontalSpace12,
                    Expanded(
                      child: context
                          .gradientButton(
                          data: BaseUiKitButtonData(
                            text: 'Book it',
                            onPressed: onBook,
                          ))
                          .loadingWrap(isLoading),
                    ),
                    SpacingFoundation.horizontalSpace12,
                    if (model.showMagnify ?? true)
                      context.smallOutlinedButton(
                          blurred: true,
                          data: BaseUiKitButtonData(
                            onPressed: onMagnify,
                            icon: ImageWidget(
                              height:26.sp,
                              svgAsset: svg.searchPeople,
                              color: Colors.white,
                            ),)
                      ),
                  ];
                }())
                .paddingSymmetric(
                vertical:
                (model.positionModel?.verticalMargin ?? 0).toDouble(),
                horizontal: (model.positionModel?.horizontalMargin ?? 0)
                    .toDouble())));
  }
}
