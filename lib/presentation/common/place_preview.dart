import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shimmer/shimmer.dart';

class PlacePreview extends StatelessWidget {
  final Function? onTap;
  final UiPlaceModel place;
  final UiBaseModel model;
  final bool showFavoriteBtn;
  final bool isFavorite;
  final Size? cellSize;
  final VoidCallback? onFavoriteChanged;
  final String? status;
  final DateTime? updatedAt;

  const PlacePreview(
      {Key? key,
      required this.onTap,
      required this.place,
      required this.model,
      this.onFavoriteChanged,
      this.cellSize,
      this.status,
      this.updatedAt,
      this.showFavoriteBtn = false,
      this.isFavorite = false})
      : super(key: key);

  PlacePreview.eventPreview(
      {super.key,
      required this.onTap,
      required UiEventModel event,
      required this.model,
      this.onFavoriteChanged,
      this.cellSize,
      this.updatedAt,
      this.status,
      this.showFavoriteBtn = false,
      this.isFavorite = false})
      : place = UiPlaceModel(
            id: event.id,
            title: event.title ?? '',
            description: event.description ?? '',
            media: event.media!,
            tags: event.tags ?? [],
            baseTags: event.baseTags ?? []);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = cellSize ?? MediaQuery.sizeOf(context);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
                alignment: Alignment.center,
                child: Stack(clipBehavior: Clip.none, children: [
                  UiKitPhotoSlider(
                    media: place.media,
                    onTap: () => onTap?.call(place.id),
                    width: size.width - horizontalMargin * 2,
                    height: cellSize?.height ?? 156.h,
                  ),
                  if (showFavoriteBtn)
                    Positioned(
                        bottom: -20.h,
                        right: -5.w,
                        child: context.button(
                            blurred: true,
                            data: BaseUiKitButtonData(
                                onPressed: onFavoriteChanged,
                                icon: ImageWidget(
                                    height: isFavorite ? 15.w : null,
                                    fit: isFavorite ? BoxFit.fitWidth : null,
                                    color: Colors.white,
                                    svgAsset: isFavorite
                                        ? GraphicsFoundation.instance.svg.star
                                        : GraphicsFoundation.instance.svg.starOutline)))),
                  if (status != null && status!.isNotEmpty)
                    Shimmer(
                        gradient: GradientFoundation.greyGradient,
                        child: SizedBox(
                            width: size.width - horizontalMargin * 2,
                            height: cellSize?.height ?? 156.h,
                            child: Center(
                              child: Text(
                                '$status\n${DateFormat('dd.MM.yy').format(updatedAt ?? DateTime.now())}',
                                textAlign: TextAlign.center,
                                style: theme?.boldTextTheme.body,
                              ),
                            )))
                ])),
            SpacingFoundation.verticalSpace8,
            Text(place.title ?? '', style: theme?.boldTextTheme.caption1Bold)
                .paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace4,
            UiKitTagsWidget(
              baseTags: place.baseTags ?? [],
              uniqueTags: place.tags,
            ).paddingSymmetric(horizontal: horizontalMargin)
          ],
        ));
  }
}
