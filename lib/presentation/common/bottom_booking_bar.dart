import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatefulWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;
  final bool isLoading;
  final int? usersCountInInviteList;

  const BottomBookingBar({
    Key? key,
    required this.model,
    this.onShowRoute,
    this.onBook,
    this.usersCountInInviteList = 10,
    this.isLoading = false,
    this.onMagnify,
  }) : super(key: key);

  @override
  State<BottomBookingBar> createState() => _BottomBookingBarState();
}

class _BottomBookingBarState extends State<BottomBookingBar> {
  bool animationEnded = false;

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = widget.model.positionModel?.bodyAlignment;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: animationEnded
              ? const SizedBox()
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UiKitMessageCloud(
                      message: S.of(context).InviteList,
                      subtitle: S.of(context).Users(widget.usersCountInInviteList ?? 0),
                    ),
                    SpacingFoundation.horizontalSpace16,
                  ],
                ),
        ),
        SpacingFoundation.verticalSpace16,
        DecoratedBox(
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
                  if (widget.model.showRoute ?? true)
                    context.outlinedButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        onPressed: widget.onShowRoute,
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
                        onPressed: widget.onBook,
                        loading: widget.isLoading,
                        // fit: ButtonFit.hugContent
                      ),
                    ),
                  ),
                  SpacingFoundation.horizontalSpace12,
                  if ((widget.model.showMagnify ?? true) && widget.usersCountInInviteList == null)
                    context.outlinedButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        onPressed: widget.onMagnify,
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.searchpeople,
                        ),
                      ),
                    ),
                  if ((widget.model.showMagnify ?? true) && widget.usersCountInInviteList != null)
                    UiKitLightUpAnimation(
                      onStarted: () => setState(() => animationEnded = false),
                      onFinished: () => setState(() => animationEnded = true),
                      child: context.outlinedButton(
                        blurred: true,
                        data: BaseUiKitButtonData(
                          onPressed: widget.onMagnify,
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.searchpeople,
                          ),
                        ),
                      ),
                    ),
                ];
              }(),
            ).paddingSymmetric(
              vertical: (widget.model.positionModel?.verticalMargin ?? 0).toDouble(),
              horizontal: (widget.model.positionModel?.horizontalMargin ?? 0).toDouble(),
            ),
          ),
        ),
      ],
    );
  }
}
