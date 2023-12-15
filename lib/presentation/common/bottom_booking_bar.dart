import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatelessWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;
  final bool isLoading;

  const BottomBookingBar({
    Key? key,
    required this.model,
    this.onShowRoute,
    this.onBook,
    this.isLoading = false,
    this.onMagnify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = model.positionModel?.bodyAlignment;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.uiKitTheme?.colorScheme.surface.withOpacity(0.5) ?? Colors.transparent,
            context.uiKitTheme?.colorScheme.surface ?? Colors.transparent,
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
            return [
              if (model.showRoute ?? true)
                context.outlinedButton(
                  blurred: true,
                  data: BaseUiKitButtonData(
                    onPressed: onShowRoute,
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.route,
                    ),
                  ),
                ),
              SpacingFoundation.horizontalSpace12,
              Expanded(
                child: context.gradientButton(
                  data: BaseUiKitButtonData(
                    text: S.of(context).BookIt,
                    onPressed: onBook,
                    loading: isLoading,
                    // fit: ButtonFit.hugContent
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              if (model.showMagnify ?? true)
                context.outlinedButton(
                  blurred: true,
                  data: BaseUiKitButtonData(
                    onPressed: onMagnify,
                    iconInfo: BaseUiKitButtonIconData(
                      iconData: ShuffleUiKitIcons.searchpeople,
                    ),
                  ),
                ),
            ];
          }(),
        ).paddingSymmetric(
          vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
          horizontal: (model.positionModel?.horizontalMargin ?? 0).toDouble(),
        ),
      ),
    );
  }
}
