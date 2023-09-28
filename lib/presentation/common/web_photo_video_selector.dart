import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/data/data.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class WebPhotoVideoSelector extends StatelessWidget {
  final Size itemsSize;
  final List<BaseUiKitMedia> logos;
  final List<BaseUiKitMedia> photos;
  final List<BaseUiKitMedia> videos;
  final VoidCallback onLogoAddRequested;
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
    this.logos = const [],
    this.photos = const [],
    this.videos = const [],
    this.itemsSize = const Size(75, 75),
    required this.onLogoAddRequested,
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
        SpacingFoundation.verticalSpace16,
        Text(
          'Logo (upload Files)',
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
              alignment: Alignment.centerLeft,
              children: [
                ReorderableListView.builder(
                  key: listLogosKey,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Stack(
                    key: ValueKey(photos[index].link),
                    alignment: Alignment.topRight,
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8),
                        ),
                        child: photos[index].widget(itemsSize),
                      ).paddingAll(4),
                      context.outlinedButton(
                        hideBorder: true,
                        data: BaseUiKitButtonData(
                          onPressed: () => onPhotoDeleted.call(index),
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.x,
                            color: Colors.white,
                            height: 8,
                            width: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  itemCount: photos.length,
                  onReorder: onPhotoReorderRequested,
                ),
                context
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
                          child: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.gradientPlus,
                            height: 18,
                            width: 18,
                          ).paddingAll(EdgeInsetsFoundation.all12),
                        ),
                      ),
                    )
                    .paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                Positioned(
                  right: EdgeInsetsFoundation.vertical16,
                  child: Text(
                    'or drag files here',
                    style: theme.boldTextTheme.caption1Medium.copyWith(
                      color: theme.colorScheme.darkNeutral900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Row(
          children: [
            Text(
              'Photo (upload Files)',
              style: theme.boldTextTheme.body.copyWith(
                color: theme.colorScheme.darkNeutral900,
              ),
            ).paddingSymmetric(horizontal: horizontalPadding),
            Text(
              '*',
              style: theme.boldTextTheme.title2.copyWith(
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
              color: theme.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all12,
              border: Border.fromBorderSide(
                BorderSide(width: 1, color: theme.colorScheme.surface5),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
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
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8)),
                        child: photos[index].widget(itemsSize),
                      ).paddingAll(4),
                      context.outlinedButton(
                        hideBorder: true,
                        data: BaseUiKitButtonData(
                          onPressed: () => onPhotoDeleted.call(index),
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.x,
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
                context
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
                          child: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.gradientPlus,
                            height: 18,
                            width: 18,
                          ).paddingAll(EdgeInsetsFoundation.all12),
                        ),
                      ),
                    )
                    .paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                Positioned(
                  right: EdgeInsetsFoundation.vertical16,
                  child: Text(
                    'or drag files here',
                    style: theme.boldTextTheme.caption1Medium.copyWith(
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
          'Video (upload Files)',
          style: theme.boldTextTheme.body.copyWith(
            color: theme.colorScheme.darkNeutral900,
          ),
        ).paddingSymmetric(horizontal: horizontalPadding),
        SpacingFoundation.verticalSpace16,
        SizedBox(
          height: itemsSize.height * 1.2,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface1,
              borderRadius: BorderRadiusFoundation.all12,
              border: Border.fromBorderSide(
                BorderSide(width: 1, color: theme.colorScheme.surface5),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ReorderableListView.builder(
                  key: listVideosKey,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Stack(
                    key: ValueKey(photos[index].link),
                    alignment: Alignment.topRight,
                    children: [
                      ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusFoundation.all8)),
                        child: photos[index].widget(itemsSize),
                      ).paddingAll(4),
                      context.outlinedButton(
                        hideBorder: true,
                        data: BaseUiKitButtonData(
                          onPressed: () => onPhotoDeleted.call(index),
                          icon: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.x,
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
                context
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
                          child: ImageWidget(
                            svgAsset: GraphicsFoundation.instance.svg.gradientPlus,
                            height: 18,
                            width: 18,
                          ).paddingAll(EdgeInsetsFoundation.all12),
                        ),
                      ),
                    )
                    .paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),
                Positioned(
                  right: EdgeInsetsFoundation.vertical16,
                  child: Text(
                    'or drag files here',
                    style: theme.boldTextTheme.caption1Medium.copyWith(
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
