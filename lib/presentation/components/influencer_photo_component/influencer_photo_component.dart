import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_staggered_grid_view/flutter_dynamic_staggered_grid_view.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class InfluencerPhotoComponent extends StatefulWidget {
  final Function(int, String)? onReactionsTapped;
  final List<InfluencerPhotoUiModel>? influencerPhoto;
  final List<int>? selectedIds;
  final Future<bool> Function()? onDeleteTap;
  final Future<void> Function()? addNewPhoto;
  final bool isOwner;

  const InfluencerPhotoComponent({
    super.key,
    this.onReactionsTapped,
    this.influencerPhoto,
    this.isOwner = false,
    this.onDeleteTap,
    this.addNewPhoto,
    this.selectedIds,
  });

  @override
  State<InfluencerPhotoComponent> createState() => _InfluencerPhotoComponentState();
}

class _InfluencerPhotoComponentState extends State<InfluencerPhotoComponent> {
  final List<InfluencerPhotoUiModel> _influencerPhoto = List.empty(growable: true);
  bool isDeletingMode = false;
  final String _groupId = 'groupId';

  bool isButtonEnabled = false;
  bool isOverlayVisible = false;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _influencerPhoto.clear();
    _influencerPhoto.addAll(
        (widget.influencerPhoto != null && widget.influencerPhoto!.isNotEmpty) ? widget.influencerPhoto!.toList() : []);
    if (widget.isOwner) {
      if (!(_influencerPhoto.map((e) => e.id).contains(-1))) {
        _influencerPhoto.insert(0, InfluencerPhotoUiModel(id: -1));
      }
    }

    Future.delayed(Duration(milliseconds: 2 * 1000), () {
      setState(() {
        isButtonEnabled = true;
      });
    });
  }

  @override
  void didUpdateWidget(covariant InfluencerPhotoComponent oldWidget) {
    if (oldWidget.influencerPhoto != widget.influencerPhoto) {
      _influencerPhoto.clear();
      _influencerPhoto.addAll((widget.influencerPhoto != null && widget.influencerPhoto!.isNotEmpty)
          ? widget.influencerPhoto!.toList()
          : []);

      if (widget.isOwner) {
        if (!(_influencerPhoto.map((e) => e.id).contains(-1))) {
          _influencerPhoto.insert(0, InfluencerPhotoUiModel(id: -1));
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorsScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;
    final reactionTextColor = colorsScheme?.bodyTypography;

    return BlurredAppBarPage(
      title: S.of(context).Photo,
      autoImplyLeading: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      appBarTrailing: isDeletingMode
          ? TapRegion(
              groupId: _groupId,
              child: GestureDetector(
                onTap: () async {
                  final deletedIt = await widget.onDeleteTap?.call();
                  if (deletedIt ?? false) isDeletingMode = false;
                  setState(() {});
                },
                child: ImageWidget(
                  iconData: ShuffleUiKitIcons.trash,
                  color: colorsScheme?.inversePrimary,
                ),
              ),
            )
          : SizedBox(width: 22.w),
      children: [
        if (_influencerPhoto.isNotEmpty) ...[
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: EdgeInsetsFoundation.all16,
            crossAxisSpacing: EdgeInsetsFoundation.all16,
            children: _influencerPhoto.map((item) {
              if (widget.isOwner && item.id == -1) {
                return Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusFoundation.all24r,
                        color: colorsScheme?.surface2,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 0.33.sw,
                        child: GestureDetector(
                          onTap: () async {
                            await widget.addNewPhoto?.call();
                            setState(() {});
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                            child: GradientableWidget(
                              gradient: GradientFoundation.defaultLinearGradient,
                              child: ImageWidget(
                                iconData: ShuffleUiKitIcons.plus,
                                height: 32.w,
                                width: 32.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SpacingFoundation.verticalSpace12,
                    Row(
                      children: [
                        Text(
                          S.current.Title,
                          style: boldTextTheme?.caption2Bold.copyWith(color: ColorsFoundation.mutedText),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                final indexOfPhoto = _influencerPhoto.indexOf(item) - (widget.isOwner ? 1 : 0);
                final microseconds = DateTime.now().microsecondsSinceEpoch;
                final String heroTag = '${item.url}--${microseconds}';
                bool hasAnyReactions = (item.heartEyeCount != null && item.heartEyeCount! > 0) ||
                    (item.thumbsUpCount != null && item.thumbsUpCount! > 0) ||
                    (item.sunglassesCount != null && item.sunglassesCount! > 0) ||
                    (item.fireCount != null && item.fireCount! > 0) ||
                    (item.smileyCount != null && item.smileyCount! > 0);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadiusFoundation.all24r,
                            child: TapRegion(
                              groupId: _groupId,
                              onTapOutside: (event) {
                                if (widget.isOwner) {
                                  isDeletingMode = false;
                                  if (!isDeletingMode) widget.selectedIds?.clear();

                                  setState(() {});
                                }
                              },
                              child: GestureDetector(
                                onLongPress: () {
                                  if (widget.isOwner) {
                                    isDeletingMode = !isDeletingMode;
                                    if (!isDeletingMode) widget.selectedIds?.clear();

                                    setState(() {});
                                  }
                                },
                                onTap: () {
                                  if (isDeletingMode) {
                                    if (widget.selectedIds?.contains(item.id) ?? false) {
                                      widget.selectedIds?.removeWhere((e) => e == item.id);
                                    } else {
                                      widget.selectedIds?.add(item.id);
                                    }
                                    setState(() {});
                                  } else {
                                    context.push(
                                      PhotoDialog(
                                        images: _influencerPhoto.map((e) => e.url).nonNulls.toList(),
                                        initialIndex: indexOfPhoto,
                                        tag: heroTag,
                                      ),
                                      nativeTransition: false,
                                      transitionDuration: const Duration(milliseconds: 500),
                                      useRootNavigator: true,
                                    );
                                  }
                                },
                                child: ImageWidget(link: item.url),
                              ),
                            ),
                          ),
                        ),
                        if (isDeletingMode)
                          Positioned(
                            top: EdgeInsetsFoundation.all12,
                            right: EdgeInsetsFoundation.all12,
                            child: TapRegion(
                              groupId: _groupId,
                              child: UiKitCheckbox(
                                isActive: widget.selectedIds?.contains(item.id) ?? false,
                                borderColor: colorsScheme?.surface4,
                                onChanged: () {
                                  if (widget.selectedIds?.contains(item.id) ?? false) {
                                    widget.selectedIds?.removeWhere((e) => e == item.id);
                                  } else {
                                    widget.selectedIds?.add(item.id);
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        if (!widget.isOwner)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Builder(
                              builder: (c) {
                                return TapRegion(
                                  behavior: HitTestBehavior.opaque,
                                  onTapInside: (value) {
                                    if (!isButtonEnabled) return;

                                    if (widget.onReactionsTapped != null) {
                                      isOverlayVisible
                                          ? hideReactionOverlay(overlayEntry)
                                          : showReactionOverlay(
                                              c,
                                              overlayEntry,
                                              reactionTextColor,
                                              (value) => widget.onReactionsTapped?.call(item.id, value),
                                              isFeedItemCard: false,
                                            );
                                      isOverlayVisible = !isOverlayVisible;
                                    }
                                  },
                                  onTapOutside: (event) {
                                    isOverlayVisible = false;
                                    hideReactionOverlay(overlayEntry);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusFoundation.all40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadiusFoundation.all40,
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                        child: ImageWidget(
                                          height: 18.w,
                                          width: 18.w,
                                          iconData: ShuffleUiKitIcons.thumbup,
                                          color: Colors.black,
                                        ).paddingAll(EdgeInsetsFoundation.all4),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      ],
                    ),
                    SpacingFoundation.verticalSpace12,
                    if (item.title != null && item.title!.isNotEmpty)
                      Text(
                        item.title!,
                        style: boldTextTheme?.caption2Bold,
                      ),
                    SpacingFoundation.verticalSpace2,
                    if (hasAnyReactions)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (item.heartEyeCount != null && item.heartEyeCount! > 0)
                            UiKitEmojiReaction(
                              reactionsCount: item.heartEyeCount!,
                              iconSvgGen: GraphicsFoundation.instance.svg.heartEyes,
                            ).paddingOnly(right: EdgeInsetsFoundation.horizontal2),
                          if (item.thumbsUpCount != null && item.thumbsUpCount! > 0)
                            UiKitEmojiReaction(
                              reactionsCount: item.thumbsUpCount!,
                              iconSvgGen: GraphicsFoundation.instance.svg.thumbsUpReversed,
                            ).paddingOnly(right: EdgeInsetsFoundation.horizontal2),
                          if (item.sunglassesCount != null && item.sunglassesCount! > 0)
                            UiKitEmojiReaction(
                              reactionsCount: item.sunglassesCount!,
                              iconSvgGen: GraphicsFoundation.instance.svg.sunglasses,
                            ).paddingOnly(right: EdgeInsetsFoundation.horizontal2),
                          if (item.fireCount != null && item.fireCount! > 0)
                            UiKitEmojiReaction(
                              reactionsCount: item.fireCount!,
                              iconSvgGen: GraphicsFoundation.instance.svg.fireEmoji,
                            ).paddingOnly(right: EdgeInsetsFoundation.horizontal2),
                          if (item.smileyCount != null && item.smileyCount! > 0)
                            UiKitEmojiReaction(
                              reactionsCount: item.smileyCount!,
                              iconSvgGen: GraphicsFoundation.instance.svg.smiley,
                            ),
                        ],
                      ),
                  ],
                );
              }
            }).toList(),
          ).paddingAll(EdgeInsetsFoundation.all16),
          SpacingFoundation.bottomNavigationBarSpacing
        ] else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(S.current.NothingFound, style: boldTextTheme?.body)],
          ),
      ],
    );
  }
}
