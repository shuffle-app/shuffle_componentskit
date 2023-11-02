import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

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
  final DateTime? shouldVisitAt;

  const PlacePreview(
      {Key? key,
      required this.onTap,
      required this.place,
      required this.model,
      this.onFavoriteChanged,
      this.cellSize,
      this.status,
      this.shouldVisitAt,
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
      this.shouldVisitAt,
      this.status,
      this.showFavoriteBtn = false,
      this.isFavorite = false})
      : place = UiPlaceModel(
            id: event.id,
            title: event.title ?? '',
            description: event.description ?? '',
            media: event.media,
            weekdays: event.weekdays,
            openFrom: event.time,
            openTo: event.timeTo,
            location: event.location,
            placeType: event.eventType,
            tags: event.tags,
            baseTags: event.baseTags);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = cellSize ?? MediaQuery.sizeOf(context);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return SizedBox(
        width: double.infinity,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          if (shouldVisitAt != null)
            Text(shouldVisitAt!.isAtSameDay ? S.of(context).Today : DateFormat('MMM dd, yyyy').format(shouldVisitAt!),
                    style: theme?.boldTextTheme.title2)
                .paddingOnly(top: SpacingFoundation.verticalSpacing6, bottom: SpacingFoundation.verticalSpacing24),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                    Opacity(
                        opacity: shouldVisitAt?.isAtSameDay ?? true ? 1 : 0.4,
                        child: UiKitPhotoSlider(
                          media: place.media.isEmpty ? [UiKitMediaPhoto(link: '')] : place.media,
                          onTap: () => onTap?.call(place.id),
                          width: size.width - horizontalMargin * 2,
                          height: cellSize?.height ?? 156.h,
                        )),
                    if (showFavoriteBtn)
                      Positioned(
                          top: -5.h,
                          right: -5.w,
                          child: context.smallButton(
                              blurred: true,
                              data: BaseUiKitButtonData(
                                  onPressed: onFavoriteChanged,
                                  icon: ImageWidget(
                                      height: isFavorite ? 15.w : null,
                                      fit: isFavorite ? BoxFit.fitWidth : null,
                                      color: Colors.white,
                                      svgAsset: isFavorite
                                          ? GraphicsFoundation.instance.svg.star
                                          : GraphicsFoundation.instance.svg.starOutline))))
                    else if (shouldVisitAt?.isAtSameDay ?? false)
                      Positioned(
                          top: -10.h,
                          right: -5.w,
                          child: context.smallOutlinedButton(
                              blurred: true,
                              color: Colors.white,
                              gradient: GradientFoundation.attentionCard,
                              data: BaseUiKitButtonData(
                                  onPressed: () {
                                    log('check in');
                                  },
                                  text: S.of(context).CheckIn.toUpperCase()))),
                    if (shouldVisitAt != null && !shouldVisitAt!.isAtSameDay)
                      Positioned(
                          bottom: -20.h,
                          child: UiKitCardWrapper(
                            color: theme?.colorScheme.surface2.withOpacity(0.7),
                            child: Center(
                              child: Text(S.of(context).VisitFirstToOpenNext, style: theme?.boldTextTheme.body),
                            ).paddingSymmetric(
                                horizontal: SpacingFoundation.horizontalSpacing16,
                                vertical: SpacingFoundation.verticalSpacing8),
                          )),
                    if (status != null && status!.isNotEmpty)
                      ClipRRect(
                          borderRadius: BorderRadiusFoundation.all24,
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: SizedBox(
                                  width: size.width - horizontalMargin * 2,
                                  height: cellSize?.height ?? 156.h,
                                  child: Center(
                                    child: Text(
                                      '$status\n${DateFormat('dd.MM.yy').format(updatedAt ?? DateTime.now())}',
                                      textAlign: TextAlign.center,
                                      style: theme?.boldTextTheme.body,
                                    ),
                                  ))))
                  ])),
              SpacingFoundation.verticalSpace8,
              Opacity(
                  opacity: shouldVisitAt?.isAtSameDay ?? true ? 1 : 0.4,
                  child: Text(place.title ?? '', style: theme?.boldTextTheme.caption1Bold)
                      .paddingSymmetric(horizontal: horizontalMargin)),
              SpacingFoundation.verticalSpace4,
              Opacity(
                  opacity: shouldVisitAt?.isAtSameDay ?? true ? 1 : 0.4,
                  child: UiKitTagsWidget(
                    baseTags: place.baseTags,
                    uniqueTags: place.tags,
                  )).paddingSymmetric(horizontal: horizontalMargin)
            ],
          ),
        ]));
  }
}
