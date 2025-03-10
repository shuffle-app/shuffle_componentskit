import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PhotoVideoSelector extends StatelessWidget {
  final Size itemsSize;
  final List<BaseUiKitMedia> photos;
  final List<BaseUiKitMedia> videos;
  final VoidCallback onPhotoAddRequested;
  final VoidCallback? onVideoAddRequested;
  final ReorderCallback onPhotoReorderRequested;
  final ReorderCallback? onVideoReorderRequested;
  final PositionModel? positionModel;
  final GlobalKey<ReorderableListState> listPhotosKey;
  final GlobalKey<ReorderableListState> listVideosKey;
  final Function(int index) onPhotoDeleted;
  final Function(int index)? onVideoDeleted;

  const PhotoVideoSelector({
    super.key,
    this.photos = const [],
    this.videos = const [],
    this.itemsSize = const Size(120, 75),
    required this.onPhotoAddRequested,
    this.onVideoAddRequested,
    required this.onPhotoReorderRequested,
    this.onVideoReorderRequested,
    required this.onPhotoDeleted,
    this.onVideoDeleted,
    this.positionModel,
    required this.listPhotosKey,
    required this.listVideosKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final horizontalPadding = positionModel?.horizontalMargin?.toDouble() ?? 0;

    //sorting photos array with preview type != null first and all others after
    photos.sort((a, b) {
      if (a.previewType == null && b.previewType == null) {
        return 0;
      } else if (a.previewType == null) {
        return 1;
      } else if (b.previewType == null) {
        return -1;
      } else {
        return 0;
      }
    });

    final autoSizeGroup= AutoSizeGroup();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (positionModel?.bodyAlignment).mainAxisAlignment,
      crossAxisAlignment: (positionModel?.bodyAlignment).crossAxisAlignment,
      children: [
        SizedBox(
          height: itemsSize.height * 1.2,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).Photo,
                    style: theme?.regularTextTheme.labelSmall,
                  ).paddingSymmetric(horizontal: horizontalPadding),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => showUiKitPopover(
                        context,
                        customMinHeight: 30.h,
                        showButton: false,
                        title: Text(
                          S.of(context).SupportedFormatsBooking,
                          style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.info,
                        width: 16.w,
                        color: theme?.colorScheme.darkNeutral900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      key: listPhotosKey,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        key: ValueKey(photos[index].link),
                        alignment: Alignment.topRight,
                        children: [
                          ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusFoundation.all8,
                              ),
                            ),
                            child: photos[index].widget(photos[index].previewType != null
                                ? Size(
                                    photos[index].previewType == UiKitPreviewType.horizontal
                                        ? itemsSize.width / 1.2
                                        : itemsSize.width / 2,
                                    itemsSize.height)
                                : itemsSize),
                            // child: photos[index].widget(itemsSize),
                          ).paddingAll(4),
                          context.outlinedButton(
                            hideBorder: true,
                            data: BaseUiKitButtonData(
                              onPressed: () => onPhotoDeleted.call(index),
                              iconInfo: BaseUiKitButtonIconData(
                                iconData: ShuffleUiKitIcons.x,
                                size: 8,
                              ),
                            ),
                          ),
                          if (photos[index].previewType != null)
                            Positioned(
                                right: 0,
                                bottom: 10,
                                left: 0,
                                child: ColoredBox(
                                    color: Colors.black.withOpacity(0.5),
                                    child: AutoSizeText(S.current.Cover.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            group: autoSizeGroup,
                                            style: theme?.boldTextTheme.caption3Medium.copyWith(color: Colors.white))
                                        .paddingOnly(top: 4)))
                        ],
                      ),
                      itemCount: photos.length,
                      onReorder: onPhotoReorderRequested,
                    ),
                  )
                ],
              ),
              context
                  .smallOutlinedButton(
                    data: BaseUiKitButtonData(
                      onPressed: onPhotoAddRequested,
                      iconInfo: BaseUiKitButtonIconData(
                        iconData: ShuffleUiKitIcons.cameraplus,
                        size: 16.h,
                      ),
                    ),
                  )
                  .paddingSymmetric(horizontal: horizontalPadding),
            ],
          ),
        ),
        SizedBox(
          height: itemsSize.height * 1.2,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).Video,
                    style: theme?.regularTextTheme.labelSmall,
                  ).paddingSymmetric(horizontal: horizontalPadding),
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => showUiKitPopover(
                        context,
                        customMinHeight: 30.h,
                        showButton: false,
                        title: Text(
                          S.of(context).SupportedFormatsVideo,
                          style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      child: ImageWidget(
                        iconData: ShuffleUiKitIcons.info,
                        width: 16.w,
                        color: theme?.colorScheme.darkNeutral900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      key: listVideosKey,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        key: ValueKey(videos[index].link),
                        alignment: Alignment.topRight,
                        children: [
                          ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusFoundation.all8,
                              ),
                            ),
                            child: videos[index].widget(itemsSize),
                          ).paddingAll(4),
                          context.outlinedButton(
                            hideBorder: true,
                            data: BaseUiKitButtonData(
                              onPressed: () => onVideoDeleted?.call(index),
                              iconInfo: BaseUiKitButtonIconData(
                                iconData: ShuffleUiKitIcons.x,
                                size: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemCount: videos.length,
                      onReorder: onVideoReorderRequested!,
                    ),
                  ),
                ],
              ),
              context
                  .smallOutlinedButton(
                    data: BaseUiKitButtonData(
                      onPressed: onVideoAddRequested,
                      iconInfo: BaseUiKitButtonIconData(
                        iconData: ShuffleUiKitIcons.videoplus,
                        size: 16.h,
                      ),
                    ),
                  )
                  .paddingSymmetric(horizontal: horizontalPadding)
            ],
          ),
        ),
      ],
    );
  }
}
