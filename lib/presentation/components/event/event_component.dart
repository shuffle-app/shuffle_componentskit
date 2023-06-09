import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventComponent extends StatelessWidget {
  final UiEventModel event;

  const EventComponent({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentEventModel model =
        ComponentEventModel.fromJson(config['event']);

    final theme = context.uiKitTheme;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final titleAlignment = model.positionModel?.titleAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return Column(
      children: [
        SpacingFoundation.verticalSpace8,
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: titleAlignment.mainAxisAlignment,
            crossAxisAlignment: titleAlignment.crossAxisAlignment,
            children: [
              if (event.title != null) ...[
                Text(
                  event.title!,
                  style: theme?.boldTextTheme.title2,
                ),
                SpacingFoundation.verticalSpace8,
              ],
              if (event.owner != null) event.owner!.buildUserTile(context)
            ]),
        SpacingFoundation.verticalSpace16,
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          children: [
            if (event.media != null) ...[
              Align(
                  alignment: Alignment.center,
                  child: UiKitPhotoSlider(
                    media: event.media ?? [],
                    onTap: null,
                    width: 1.sw - horizontalMargin * 2,
                    height: 156.h,
                  )),
              SpacingFoundation.verticalSpace12
            ],
            UiKitTagsWidget(
              rating: event.rating,
              baseTags: event.baseTags ?? [],
              uniqueTags: event.tags ?? [],
            ),
            SpacingFoundation.verticalSpace12,
            if (event.description != null) ...[
              Text(
                event.description!,
                // maxLines: 7,
                // overflow: TextOverflow.ellipsis,
                style: theme?.boldTextTheme.caption1Bold
                    .copyWith(color: Colors.white),
              ),
              SpacingFoundation.verticalSpace16
            ],
            SpacingFoundation.verticalSpace16,
            if (event.descriptionItems != null)
              ...event.descriptionItems!
                  .map((e) => TitledAccentInfo(
                        title: e.title,
                        info: e.description,
                      ).paddingSymmetric(
                          vertical: SpacingFoundation.verticalSpacing4))
                  .toList(),
            SpacingFoundation.verticalSpace16,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(
        vertical: (model.positionModel?.verticalMargin ?? 0).toDouble(),
        horizontal: horizontalMargin);
  }
}
