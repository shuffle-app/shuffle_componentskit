import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/data/base_ui_model/uibase_model.dart';
import 'package:shuffle_components_kit/presentation/components/place/uiplace_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlacePreview extends StatelessWidget {
  final Function? onTap;
  final UiPlaceModel place;
  final UiBaseModel model;

  const PlacePreview(
      {Key? key, required this.onTap, required this.place, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
                alignment: Alignment.center,
                child: UiKitPhotoSlider(
                  media: place.media,
                  onTap: onTap != null ? () => onTap!(place.id) : null,
                  width: size.width - horizontalMargin * 2,
                  height: 156.h,
                )),
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
