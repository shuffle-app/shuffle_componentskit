import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddInfluencerFeedbackComponent extends StatelessWidget {
  final String? placeName;
  final String? placeAvatar;
  final TextEditingController feedbackTextController;
  final TextEditingController topTitleTextController;
  final VoidCallback? onConfirm;
  final ValueChanged<int>? onRatingChanged;
  final ValueChanged<bool>? onPersonalRespectToggled;
  final bool? personalRespectToggled;
  final ValueChanged<bool>? onAddToPersonalTopToggled;
  final bool? addToPersonalTopToggled;

  const AddInfluencerFeedbackComponent({
    Key? key,
    this.placeName,
    this.placeAvatar,
    required this.feedbackTextController,
    required this.topTitleTextController,
    this.onConfirm,
    this.onRatingChanged,
    this.onPersonalRespectToggled,
    this.onAddToPersonalTopToggled,
    this.personalRespectToggled,
    this.addToPersonalTopToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: S.current.AddFeedback,
        childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace16,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: placeName ?? 'At.mosphere',
                imageUrl: placeAvatar ?? GraphicsFoundation.instance.png.place.path,
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                placeName ?? 'At.mosphere',
                style: boldTextTheme?.title2,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitRatingBarWithStars(
            onRatingChanged: onRatingChanged,
          ),
          SpacingFoundation.verticalSpace24,
          UiKitTitledWrappedInput(
            title: S.current.AddFeedbackFieldTitle,
            input: UiKitSymbolsCounterInputField(
              controller: feedbackTextController,
              enabled: true,
              obscureText: false,
              hintText: S.current.AddFeedbackFieldHint,
              maxSymbols: 1500,
            ),
            popOverMessage: S.current.AddInfluencerFeedbackPopOverText,
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  S.current.PersonalRespect,
                  style: boldTextTheme?.caption1Medium,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              UiKitGradientSwitch(
                switchedOn: personalRespectToggled ?? false,
                onChanged: onPersonalRespectToggled,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  S.current.AddToPersonalTop,
                  style: boldTextTheme?.caption1Medium,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              UiKitGradientSwitch(
                switchedOn: addToPersonalTopToggled ?? false,
                onChanged: onAddToPersonalTopToggled,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
        ],
      ),
      bottomNavigationBar: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            child: isKeyboardVisible
                ? const SizedBox()
                : SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: context.button(
                      data: BaseUiKitButtonData(
                        text: S.current.Confirm,
                        onPressed: onConfirm,
                        fit: ButtonFit.fitWidth,
                      ),
                    ),
                  ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16, vertical: EdgeInsetsFoundation.vertical24),
          );
        },
      ),
    );
  }
}
