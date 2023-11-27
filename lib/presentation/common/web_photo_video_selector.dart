import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class WebPhotoVideoSelector extends StatelessWidget {
  final Size itemsSize;
  final String? logo;
  final List<BaseUiKitMedia> photos;
  final List<BaseUiKitMedia> videos;
  final VoidCallback? onLogoAddRequested;
  final VoidCallback onPhotoAddRequested;
  final VoidCallback onVideoAddRequested;
  final ReorderCallback onPhotoReorderRequested;
  final ReorderCallback onVideoReorderRequested;
  final PositionModel? positionModel;
  final GlobalKey<ReorderableListState> listPhotosKey = GlobalKey<ReorderableListState>();
  final GlobalKey<ReorderableListState> listLogosKey = GlobalKey<ReorderableListState>();
  final GlobalKey<ReorderableListState> listVideosKey = GlobalKey<ReorderableListState>();
  final Function(int index) onPhotoDeleted;
  final Function(int index) onVideoDeleted;

  WebPhotoVideoSelector({
    super.key,
    this.logo,
    this.photos = const [],
    this.videos = const [],
    this.itemsSize = const Size(75, 75),
    this.onLogoAddRequested,
    required this.onPhotoAddRequested,
    required this.onVideoAddRequested,
    required this.onPhotoReorderRequested,
    required this.onVideoReorderRequested,
    required this.onPhotoDeleted,
    required this.onVideoDeleted,
    this.positionModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final horizontalPadding = positionModel?.horizontalMargin?.toDouble() ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (positionModel?.bodyAlignment).mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onLogoAddRequested != null) ...[
          SpacingFoundation.verticalSpace16,
          Text(
            S.of(context).LogoUploadFiles,
            style: theme?.boldTextTheme.body.copyWith(
              color: theme.colorScheme.darkNeutral900,
            ),
          ).paddingSymmetric(horizontal: horizontalPadding),
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: itemsSize.height * 1.2,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme?.colorScheme.surface1,
                borderRadius: BorderRadiusFoundation.all12,
                border: Border.fromBorderSide(
                  BorderSide(width: 1, color: theme!.colorScheme.surface5),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  if (logo != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8),
                          ),
                          child: ImageWidget(link: logo),
                        ).paddingAll(4),
                      ],
                    ),
                  Positioned(
                    left: 0,
                    child: context
                        .badgeButtonNoValue(
                          data: BaseUiKitButtonData(
                            onPressed: onLogoAddRequested,
                            icon: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.fromBorderSide(
                                  BorderSide(color: context.uiKitTheme!.colorScheme.darkNeutral500, width: 1),
                                ),
                                borderRadius: BorderRadiusFoundation.all12,
                              ),
                              child: const ImageWidget(
                                iconData: ShuffleUiKitIcons.gradientPlus,
                                height: 18,
                                width: 18,
                              ).paddingAll(EdgeInsetsFoundation.all12),
                            ),
                          ),
                        )
                        .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                  ),
                ],
              ),
            ),
          ),
        ],
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Text(
              S.of(context).PhotoUploadFiles,
              style: theme?.boldTextTheme.body.copyWith(
                color: theme.colorScheme.darkNeutral900,
              ),
            ).paddingSymmetric(horizontal: horizontalPadding),
            Text(
              '*',
              style: theme?.boldTextTheme.title2.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: itemsSize.height * 1.2,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all12,
              border: Border.fromBorderSide(
                BorderSide(width: 1, color: theme?.colorScheme.surface5 ?? Colors.black),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                ReorderableListView.builder(
                  key: listPhotosKey,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Stack(
                    key: ValueKey(photos[index].link),
                    alignment: Alignment.topRight,
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8)),
                        child: photos[index].widget(itemsSize),
                      ).paddingAll(4),
                      context.outlinedButton(
                        hideBorder: true,
                        data: BaseUiKitButtonData(
                          onPressed: () => onPhotoDeleted.call(index),
                          icon: const ImageWidget(
                            iconData: ShuffleUiKitIcons.x,
                            color: Colors.white,
                            height: 8,
                            width: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  itemCount: photos.length,
                  onReorder: onPhotoReorderRequested,
                ),
                Positioned(
                  left: 0,
                  child: context
                      .badgeButtonNoValue(
                        data: BaseUiKitButtonData(
                          onPressed: onPhotoAddRequested,
                          icon: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.fromBorderSide(
                                BorderSide(color: context.uiKitTheme!.colorScheme.darkNeutral500, width: 1),
                              ),
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                            child: const ImageWidget(
                              iconData: ShuffleUiKitIcons.gradientPlus,
                              height: 18,
                              width: 18,
                            ).paddingAll(EdgeInsetsFoundation.all12),
                          ),
                        ),
                      )
                      .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                ),
                if (photos.isEmpty)
                  Positioned(
                    right: EdgeInsetsFoundation.vertical16,
                    child: Text(
                      S.of(context).OrDragFilesHere.toLowerCase(),
                      style: theme?.boldTextTheme.caption1Medium.copyWith(
                        color: theme.colorScheme.darkNeutral900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).VideoUploadFiles,
          style: theme?.boldTextTheme.body.copyWith(
            color: theme.colorScheme.darkNeutral900,
          ),
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: itemsSize.height * 1.2,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all12,
              border: Border.fromBorderSide(
                BorderSide(width: 1, color: theme?.colorScheme.surface5 ?? Colors.black),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                ReorderableListView.builder(
                  key: listVideosKey,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Stack(
                    key: ValueKey(videos[index].link),
                    alignment: Alignment.topRight,
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8)),
                        child: videos[index].widget(itemsSize),
                      ).paddingAll(4),
                      context.outlinedButton(
                        hideBorder: true,
                        data: BaseUiKitButtonData(
                          onPressed: () => onVideoDeleted.call(index),
                          icon: const ImageWidget(
                            iconData: ShuffleUiKitIcons.x,
                            color: Colors.white,
                            height: 8,
                            width: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  itemCount: videos.length,
                  onReorder: onVideoReorderRequested,
                ),
                Positioned(
                  left: 0,
                  child: context
                      .badgeButtonNoValue(
                        data: BaseUiKitButtonData(
                          onPressed: onVideoAddRequested,
                          icon: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.fromBorderSide(
                                BorderSide(color: context.uiKitTheme!.colorScheme.darkNeutral500, width: 1),
                              ),
                              borderRadius: BorderRadiusFoundation.all12,
                            ),
                            child: const ImageWidget(
                              iconData: ShuffleUiKitIcons.gradientPlus,
                              height: 18,
                              width: 18,
                            ).paddingAll(EdgeInsetsFoundation.all12),
                          ),
                        ),
                      )
                      .paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                ),
                if (videos.isEmpty)
                  Positioned(
                    right: EdgeInsetsFoundation.vertical16,
                    child: Text(
                      S.of(context).OrDragFilesHere.toLowerCase(),
                      style: theme?.boldTextTheme.caption1Medium.copyWith(
                        color: theme.colorScheme.darkNeutral900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
      ],
    );
  }
}
