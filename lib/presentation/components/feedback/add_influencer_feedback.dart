import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AddInfluencerFeedbackComponent extends StatefulWidget {
  final UiUniversalModel? uiUniversalModel;
  final UserTileType userTileType;
  final TextEditingController feedbackTextController;
  final ValueChanged<ReviewUiModel>? onConfirm;
  final ReviewUiModel? reviewUiModel;
  final Future<bool> Function(bool value)? onAddToPersonalTopToggled;
  final Future<bool> Function(bool value)? onPersonalRespectToggled;
  final bool? loading;

  const AddInfluencerFeedbackComponent({
    super.key,
    required this.feedbackTextController,
    required this.userTileType,
    this.uiUniversalModel,
    this.onConfirm,
    this.reviewUiModel,
    this.onAddToPersonalTopToggled,
    this.onPersonalRespectToggled,
    this.loading,
  });

  @override
  State<AddInfluencerFeedbackComponent> createState() => _AddInfluencerFeedbackComponentState();
}

class _AddInfluencerFeedbackComponentState extends State<AddInfluencerFeedbackComponent> {
  bool? personalRespectToggled;
  bool? addToPersonalTopToggled;
  int rating = 0;

  @override
  void didUpdateWidget(covariant AddInfluencerFeedbackComponent oldWidget) {
    if (oldWidget.reviewUiModel != widget.reviewUiModel) {
      rating = widget.reviewUiModel?.rating ?? 0;

      if (widget.reviewUiModel != null) {
        personalRespectToggled = widget.reviewUiModel?.isPersonalRespect ?? false;
        addToPersonalTopToggled = widget.reviewUiModel?.isAddToPersonalTop ?? false;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (widget.reviewUiModel != null) {
      rating = widget.reviewUiModel?.rating ?? 0;
      widget.feedbackTextController.text = widget.reviewUiModel?.reviewDescription ?? '';
    }
    if (widget.userTileType == UserTileType.influencer) {
      personalRespectToggled = widget.reviewUiModel?.isPersonalRespect ?? false;
      addToPersonalTopToggled = widget.reviewUiModel?.isAddToPersonalTop ?? false;
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        childrenPadding: EdgeInsets.symmetric(horizontal: EdgeInsetsFoundation.horizontal16),
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
              Expanded(
                child: Text(
                  widget.uiUniversalModel?.title ?? '',
                  style: boldTextTheme?.title2,
                ),
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
                    widget.onAddToPersonalTopToggled?.call(value).then(
                          (v) => setState(() {
                            personalRespectToggled = v;
                          }),
                        );
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
                    widget.onAddToPersonalTopToggled?.call(value).then(
                          (v) => setState(() {
                            addToPersonalTopToggled = v;
                          }),
                        );
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
                        loading: widget.loading,
                        text: S.current.Confirm,
                        onPressed: widget.feedbackTextController.text.isNotEmpty
                            ? () {
                                widget.onConfirm?.call(
                                  ReviewUiModel(
                                    isAddToPersonalTop: addToPersonalTopToggled,
                                    isPersonalRespect: personalRespectToggled,
                                    rating: rating,
                                    reviewDescription: widget.feedbackTextController.text,
                                    reviewTime: widget.reviewUiModel?.reviewTime ?? DateTime.now(),
                                  ),
                                );
                              }
                            : null,
                        fit: ButtonFit.fitWidth,
                      ),
                    ),
                  ).paddingSymmetric(
                    horizontal: EdgeInsetsFoundation.horizontal16, vertical: EdgeInsetsFoundation.vertical24),
          );
        },
      ),
    );
  }
}
