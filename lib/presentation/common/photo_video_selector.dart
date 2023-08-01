import 'package:shuffle_components_kit/data/data.dart';
import 'package:shuffle_components_kit/presentation/presentation.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter/material.dart';

class PhotoVideoSelector extends StatelessWidget {
  static const Size itemsSize = Size(60, 60);
  final List<BaseUiKitMedia> photos;
  final List<BaseUiKitMedia> videos;
  final VoidCallback onPhotoAddRequested;
  final VoidCallback onVideoAddRequested;
  final ReorderCallback onPhotoReorderRequested;
  final ReorderCallback onVideoReorderRequested;
  final PositionModel? positionModel;

  final Function(int index) onPhotoDeleted;
  final Function(int index) onVideoDeleted;

  const PhotoVideoSelector(
      {super.key,
      this.photos = const [],
      this.videos = const [],
      required this.onPhotoAddRequested,
      required this.onVideoAddRequested,
      required this.onPhotoReorderRequested,
      required this.onVideoReorderRequested,
      required this.onPhotoDeleted,
      required this.onVideoDeleted,
      this.positionModel});

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final horizontalPadding = positionModel?.horizontalMargin?.toDouble() ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (positionModel?.bodyAlignment).mainAxisAlignment,
      crossAxisAlignment: (positionModel?.bodyAlignment).crossAxisAlignment,
      children: [
        Text(
          'Photo',
          style: theme?.regularTextTheme.labelSmall,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SizedBox(
            height: itemsSize.height * 1.2,
            child: Stack(alignment: Alignment.centerRight, children: [
              ReorderableList(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      Stack(alignment: Alignment.topRight, children: [
                        ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusFoundation.all8)),
                                child: photos[index].widget(itemsSize))
                            .paddingAll(4),
                        context.outlinedButton(
                            hideBorder: true,
                            data: BaseUiKitButtonData(
                                onPressed: () => onPhotoDeleted.call(index),
                                icon: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.x,
                                  color: Colors.white,
                                  height: 8,
                                  width: 8,
                                )))
                      ]),
                  itemCount: photos.length,
                  onReorder: onPhotoReorderRequested),
              context.outlinedButton(
                data: BaseUiKitButtonData(
                    onPressed: onPhotoAddRequested,
                    icon: ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.cameraPlus,
                      color: Colors.white,
                      height: 18,
                      width: 18,
                    )),
              ).paddingSymmetric(horizontal: horizontalPadding),
            ])),
        Text(
          'Video',
          style: theme?.regularTextTheme.labelSmall,
        ).paddingSymmetric(horizontal: horizontalPadding),
        SizedBox(
            height: itemsSize.height * 1.2,
            child: Stack(alignment: Alignment.centerRight, children: [
              ReorderableList(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      Stack(alignment: Alignment.topRight, children: [
                        ClipPath(
                                clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusFoundation.all8)),
                                child: videos[index].widget(itemsSize))
                            .paddingAll(4),
                        context.outlinedButton(
                            hideBorder: true,
                            data: BaseUiKitButtonData(
                                onPressed: () => onVideoDeleted.call(index),
                                icon: ImageWidget(
                                  svgAsset: GraphicsFoundation.instance.svg.x,
                                  color: Colors.white,
                                  height: 8,
                                  width: 8,
                                )))
                      ]),
                  itemCount: videos.length,
                  onReorder: onVideoReorderRequested),
              context.outlinedButton(
                data: BaseUiKitButtonData(
                    onPressed: onPhotoAddRequested,
                    icon: ImageWidget(
                      svgAsset: GraphicsFoundation.instance.svg.videoPlus,
                      color: Colors.white,
                      height: 18,
                      width: 18,
                    )),
              ).paddingSymmetric(horizontal: horizontalPadding),
            ])),
      ],
    );
  }
}
