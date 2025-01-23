import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/review_ui_model.dart';
import 'package:shuffle_components_kit/presentation/common/common.dart';
import 'package:shuffle_components_kit/presentation/components/components.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:image_picker/image_picker.dart';

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
  final FocusNode _focusNode = FocusNode();
  bool get isKeyboardVisible => MediaQuery.of(context).viewInsets.bottom > 0;
  int rating = 0;

  final ScrollController _scrollController = ScrollController();
  late final GlobalKey<ReorderableListState> _reordablePhotokey = GlobalKey<ReorderableListState>();
  late final GlobalKey<ReorderableListState> _reordableVideokey = GlobalKey<ReorderableListState>();

  final List<BaseUiKitMedia> _videos = [];
  final List<BaseUiKitMedia> _photos = [];

  @override
  void initState() {
    if (widget.reviewUiModel != null) {
      rating = widget.reviewUiModel?.rating ?? 0;
      widget.feedbackTextController.text = widget.reviewUiModel?.reviewDescription ?? '';
      _photos.addAll(widget.reviewUiModel!.media.where((element) => element.type == UiKitMediaType.image));
      _videos.addAll(widget.reviewUiModel!.media.where((element) => element.type == UiKitMediaType.video));
    }
    if (widget.userTileType == UserTileType.influencer) {
      personalRespectToggled = widget.reviewUiModel?.isPersonalRespect ?? false;
      addToPersonalTopToggled = widget.reviewUiModel?.isAddToPersonalTop ?? false;
    }

    _focusNode.addListener(() async {
      if (_focusNode.hasFocus && !isKeyboardVisible) {
        await Future.delayed(Duration(milliseconds: 300));

        unawaited(_scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ));
      }
    });

    super.initState();
  }

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

  _onPhotoAddRequested() async {
    final imageFiles = await ImagePicker().pickMultiImage();
    if (imageFiles.isNotEmpty) {
      setState(() {
        for (final imageFile in imageFiles) {
          _photos.add(UiKitMediaPhoto(link: imageFile.path));
        }
      });
    }
  }

  _onVideoAddRequested() async {
    final videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile != null) {
      setState(() {
        _videos.add(UiKitMediaVideo(link: videoFile.path));
      });
    }
  }

  _onPhotoReorderRequested(int oldIndex, int newIndex) {
    if (oldIndex != newIndex) {
      setState(() {
        _photos.insert(min(newIndex, _photos.length - 1), _photos.removeAt(oldIndex));
      });
    }
  }

  _onVideoReorderRequested(int oldIndex, int newIndex) {
    setState(() {
      _videos.insert(newIndex, _videos.removeAt(oldIndex));
    });
  }

  _onVideoDeleted(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  _onPhotoDeleted(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        controller: _scrollController,
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
            rating: rating,
            onRatingChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
          SpacingFoundation.verticalSpace24,
          PhotoVideoSelector(
            videos: _videos,
            photos: _photos,
            onPhotoAddRequested: _onPhotoAddRequested,
            onPhotoReorderRequested: _onPhotoReorderRequested,
            onPhotoDeleted: _onPhotoDeleted,
            onVideoAddRequested: _onVideoAddRequested,
            onVideoReorderRequested: _onVideoReorderRequested,
            onVideoDeleted: _onVideoDeleted,
            listPhotosKey: _reordablePhotokey,
            listVideosKey: _reordableVideokey,
          ),
          SpacingFoundation.verticalSpace24,
          UiKitTitledWrappedInput(
            title: S.current.AddFeedbackFieldTitle,
            input: UiKitSymbolsCounterInputField(
              focusNode: _focusNode,
              controller: widget.feedbackTextController,
              enabled: true,
              obscureText: false,
              hintText: S.current.AddFeedbackFieldHint,
              maxSymbols: 1500,
              onTap: () async {
                if (!isKeyboardVisible) {
                  await Future.delayed(Duration(milliseconds: 300));

                  unawaited(_scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  ));
                }
              },
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
          ],
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
                                    id: widget.reviewUiModel?.id ?? -1,
                                    isAddToPersonalTop: addToPersonalTopToggled,
                                    isPersonalRespect: personalRespectToggled,
                                    rating: rating,
                                    reviewDescription: widget.feedbackTextController.text,
                                    reviewTime: widget.reviewUiModel?.reviewTime ?? DateTime.now(),
                                    media: [..._photos, ..._videos],
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
