import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/data/base_ui_model/base_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/place/place_uimodel.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlacePreview extends StatelessWidget {
  final Function? onTap;
  final UiPlaceModel place;
  final BaseModel model;

  const PlacePreview(
      {Key? key, required this.onTap, required this.place, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final size = MediaQuery.of(context).size;
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
                  width: size.width -
                      (model.positionModel?.horizontalMargin ?? 0) * 2,
                  height: 106.h,
                )),
            SpacingFoundation.verticalSpace4,
            Text(place.title ?? '', style: theme?.boldTextTheme.caption1Bold)
                .paddingSymmetric(
                    horizontal: model.positionModel?.horizontalMargin ?? 0),
            SpacingFoundation.verticalSpace4,
            UiKitTagsWidget(
              baseTags: place.baseTags ?? [],
              uniqueTags: place.tags,
            )
          ],
        ));
  }
}
