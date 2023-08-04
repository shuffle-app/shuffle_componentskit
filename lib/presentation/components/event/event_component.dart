import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EventComponent extends StatelessWidget {
  final UiEventModel event;
  final bool isEligibleForEdit;
  final VoidCallback? onEditPressed;

  const EventComponent(
      {Key? key,
      required this.event,
      this.isEligibleForEdit = false,
      this.onEditPressed})
      : super(key: key);

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
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();

    return Column(
      children: [
        SpacingFoundation.verticalSpace8,
        Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: titleAlignment.mainAxisAlignment,
            crossAxisAlignment: titleAlignment.crossAxisAlignment,
            children: [
              if (event.title != null) ...[
                Stack(
                    alignment: titleAlignment.crossAxisAlignment ==
                            CrossAxisAlignment.center
                        ? Alignment.center
                        : AlignmentDirectional.topStart,
                    children: [
                      AutoSizeText(
                        event.title!,
                        minFontSize: 18.w,
                        stepGranularity: 1.w,
                        style: theme?.boldTextTheme.title2,
                        textAlign: titleAlignment.textAlign,
                      ),
                      if (isEligibleForEdit)
                        Positioned(
                            right: 0,
                            child: IconButton(
                              icon: ImageWidget(
                                  svgAsset:
                                      GraphicsFoundation.instance.svg.pencil,
                                  color: Colors.white,
                                  height: 20.h,
                                  fit: BoxFit.fitHeight),
                              onPressed: () => onEditPressed?.call(),
                            ))
                    ]),
                SpacingFoundation.verticalSpace8,
              ],
              if (event.archived) ...[
                UiKitBadgeOutlined.text(
                  text: 'Archived',
                ),
                SpacingFoundation.verticalSpace4,
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
              SpacingFoundation.verticalSpace14
            ],
            UiKitTagsWidget(
              rating: event.rating,
              baseTags: event.baseTags ?? [],
              uniqueTags: event.tags ?? [],
            ),
            SpacingFoundation.verticalSpace14,
            if (event.description != null) ...[
              DescriptionWidget(description: event.description!),
              SpacingFoundation.verticalSpace16
            ],
            SpacingFoundation.verticalSpace16,
            if (event.descriptionItems != null)
              ...event.descriptionItems!
                  .map((e) => GestureDetector(
                          onTap: () {
                            if (e.description.startsWith('http')) {
                              launchUrlString(e.description);
                            } else if (e.description
                                .replaceAll(RegExp(r'[0-9]'), '')
                                .replaceAll('+', '')
                                .trim()
                                .isEmpty) {
                              launchUrlString('tel:${e.description}');
                            }
                          },
                          child: TitledAccentInfo(
                            title: e.title,
                            info: e.description,
                          ))
                      .paddingSymmetric(
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
