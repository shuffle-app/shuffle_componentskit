import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddFeedbackComponent extends StatefulWidget {
  final ValueChanged<ReviewUiModel>? onConfirm;
  final ReviewUiModel? reviewUiModel;
  final TextEditingController feedbackTextController;
  final UiProfileModel uiProfileModel;



  const AddFeedbackComponent({
    super.key,
    required this.feedbackTextController,
    this.onConfirm,
    this.reviewUiModel,
    required this.uiProfileModel
  });

  @override
  State<AddFeedbackComponent> createState() => _AddFeedbackComponentState();
}

class _AddFeedbackComponentState extends State<AddFeedbackComponent> {
  int rating = 0;
  ValueChanged<int>? onRatingChanged;

  @override
  void initState() {
    super.initState();
    onRatingChanged = (value) {
      setState(() {
        rating = value;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredAppBarPage(
        centerTitle: true,
        autoImplyLeading: true,
        title: S.current.AddFeedback,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace24,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: widget.uiProfileModel.name ?? 'At.mosphere',
                imageUrl: widget.uiProfileModel.avatarUrl ??
                    GraphicsFoundation.instance.png.place.path,
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                widget.uiProfileModel.name ?? 'At.mosphere',
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
              controller: widget.feedbackTextController,
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
                        onPressed: () {
                          widget.onConfirm?.call(
                            ReviewUiModel(
                              rating: rating,
                              reviewDescription:
                                  widget.feedbackTextController.text,
                              reviewTime: DateTime.now(),
                              userType: UserTileType.ordinary,
                            ),
                          );
                        },
                        fit: ButtonFit.fitWidth,
                      ),
                    ),
                  ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16,
                    vertical: EdgeInsetsFoundation.vertical24),
          );
        },
      ),
    );
  }
}
