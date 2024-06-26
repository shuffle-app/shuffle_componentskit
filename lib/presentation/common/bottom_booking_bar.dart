import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class BottomBookingBar extends StatefulWidget {
  final BookingElementModel model;
  final VoidCallback? onShowRoute;
  final VoidCallback? onBook;
  final VoidCallback? onMagnify;
  final bool isLoading;
  final Future<int>? usersCountInInviteList;
  final bool? isInviteEnable;

  const BottomBookingBar({
    super.key,
    required this.model,
    this.onShowRoute,
    this.onBook,
    this.usersCountInInviteList,
    this.isLoading = false,
    this.onMagnify,
    this.isInviteEnable,
  });

  @override
  State<BottomBookingBar> createState() => _BottomBookingBarState();
}

class _BottomBookingBarState extends State<BottomBookingBar> {
  bool animationEnded = false;
  int? inviteCount;

  @override
  void initState() {
    if (widget.usersCountInInviteList != null) {
      widget.usersCountInInviteList!.then((value) {
        setState(() {
          inviteCount = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyAlignment = widget.model.positionModel?.bodyAlignment;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isInviteEnable ?? true)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: animationEnded ? const SizedBox() : child,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UiKitMessageCloud(
                  message: S.of(context).InviteList,
                  subtitle: (inviteCount ?? 0) == 0
                      ? S.of(context).BeFirstToInvite
                      : S.of(context).Users(inviteCount ?? 0),
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
                context.uiKitTheme?.colorScheme.surface.withOpacity(0.5) ??
                    Colors.transparent,
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
                  if ((widget.model.showMagnify ?? true) && inviteCount == null)
                    context.outlinedButton(
                      blurred: true,
                      data: BaseUiKitButtonData(
                        onPressed: widget.onMagnify,
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.searchpeople,
                        ),
                      ),
                    ),
                  if ((widget.model.showMagnify ?? true) && inviteCount != null)
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
              vertical:
                  (widget.model.positionModel?.verticalMargin ?? 0).toDouble(),
              horizontal: (widget.model.positionModel?.horizontalMargin ?? 0)
                  .toDouble(),
            ),
          ),
        ),
      ],
    );
  }
}
