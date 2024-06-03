import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddInfluencerFeedbackComponent extends StatefulWidget {
  final UiUniversalModel? uiUniversalModel;
  final UserTileType userTileType;
  final TextEditingController feedbackTextController;
  final TextEditingController topTitleTextController;
  final ValueChanged<ReviewUiModel>? onConfirm;
  final bool? personalRespectToggled;
  final bool? addToPersonalTopToggled;

  const AddInfluencerFeedbackComponent({
    Key? key,
    required this.feedbackTextController,
    required this.topTitleTextController,
    this.onConfirm,
    this.personalRespectToggled,
    this.addToPersonalTopToggled,
    this.uiUniversalModel,
    required this.userTileType,
  }) : super(key: key);

  @override
  State<AddInfluencerFeedbackComponent> createState() =>
      _AddInfluencerFeedbackComponentState();
}

class _AddInfluencerFeedbackComponentState
    extends State<AddInfluencerFeedbackComponent> {
  bool? personalRespectToggled;
  bool? addToPersonalTopToggled;
  int rating = 0;

  @override
  void initState() {
    if (widget.userTileType == UserTileType.influencer) {
      personalRespectToggled = widget.personalRespectToggled ?? false;
      addToPersonalTopToggled = widget.addToPersonalTopToggled ?? false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        title: S.current.AddFeedback,
        childrenPadding:
            EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
        children: [
          SpacingFoundation.verticalSpace16,
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              context.userAvatar(
                size: UserAvatarSize.x40x40,
                type: UserTileType.ordinary,
                userName: widget.uiUniversalModel?.title ?? '',
                imageUrl: widget.uiUniversalModel?.media.isNotEmpty ?? false
                    ? widget.uiUniversalModel?.media.first.link
                    : null,
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                widget.uiUniversalModel?.title ?? '',
                style: boldTextTheme?.title2,
              ),
            ],
          ),
          SpacingFoundation.verticalSpace24,
          UiKitRatingBarWithStars(
            onRatingChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
          SpacingFoundation.verticalSpace24,
          UiKitTitledWrappedInput(
            title: S.current.AddFeedbackFieldTitle,
            input: UiKitSymbolsCounterInputField(
              controller: widget.feedbackTextController,
              enabled: true,
              obscureText: false,
              hintText: S.current.AddFeedbackFieldHint,
              maxSymbols: 1500,
            ),
            popOverMessage: S.current.AddInfluencerFeedbackPopOverText,
          ),
          SpacingFoundation.verticalSpace24,
          if (widget.userTileType == UserTileType.influencer) ...[
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
                  onChanged: (value) {
                    setState(() {
                      personalRespectToggled = value;
                    });
                  },
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
                  onChanged: (value) {
                    if (value) {
                      showUiKitGeneralFullScreenDialog(
                        context,
                        GeneralDialogData(
                          isWidgetScrollable: false,
                          topPadding: 0.6.sh,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.current.TitleYourTop,
                                style: boldTextTheme?.subHeadline,
                              ),
                              SpacingFoundation.verticalSpace24,
                              UiKitSymbolsCounterInputField(
                                  hintText: S.current.Title,
                                  controller: widget.topTitleTextController,
                                  enabled: true,
                                  obscureText: false,
                                  minLines: 1,
                                  maxLines: 1,
                                  maxSymbols: 100),
                              SpacingFoundation.verticalSpace24,
                              context.gradientButton(
                                data: BaseUiKitButtonData(
                                  fit: ButtonFit.fitWidth,
                                  text: S.current.Confirm,
                                  onPressed: () {
                                    context.pop();
                                  },
                                ),
                              )
                            ],
                          ).paddingAll(16),
                        ),
                      );
                    }
                    setState(() {
                      addToPersonalTopToggled = value;
                    });
                  },
                ),
              ],
            ),
            SpacingFoundation.verticalSpace24,
          ]
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
                        onPressed: widget.feedbackTextController.text.isNotEmpty
                            ? () {
                                widget.onConfirm?.call(
                                  ReviewUiModel(
                                    isAddToPersonalTop: addToPersonalTopToggled,
                                    personalTopTitle:
                                        (addToPersonalTopToggled ?? false)
                                            ? widget.topTitleTextController.text
                                            : null,
                                    isPersonalRespect: personalRespectToggled,
                                    rating: rating,
                                    reviewDescription:
                                        widget.feedbackTextController.text,
                                    reviewTime: DateTime.now(),
                                  ),
                                );
                              }
                            : null,
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
