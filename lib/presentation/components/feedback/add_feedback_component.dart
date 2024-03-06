import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddFeedbackComponent extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String? placeTitle;
  final String? placeImageUrl;
  final ValueChanged<int>? onRatingChanged;
  final TextEditingController feedbackTextController;

  const AddFeedbackComponent({
    Key? key,
    required this.feedbackTextController,
    this.onConfirm,
    this.placeImageUrl,
    this.placeTitle,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredAppBarPage(
        centerTitle: true,
        autoImplyLeading: true,
        title: S.current.AddFeedback,
        childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: placeTitle ?? 'At.mosphere',
                imageUrl: placeImageUrl ?? GraphicsFoundation.instance.png.place.path,
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                placeTitle ?? 'At.mosphere',
                style: context.uiKitTheme?.boldTextTheme.title1,
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
              hintText: S.current.AddFeedbackFieldHint.toUpperCase(),
              maxSymbols: 500,
              obscureText: false,
            ),
          )
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
