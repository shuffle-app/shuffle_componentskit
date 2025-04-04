import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/activity_component/activity_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart' as intl;

class ActivityItemWidget extends StatelessWidget {
  final ActivityUiModel? activityUiModel;

  const ActivityItemWidget({
    super.key,
    this.activityUiModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;

    return LayoutBuilder(
      builder: (context, size) {
        final calculatedHeight = size.maxWidth * 0.22;
        final sideInfoCardsWidth = size.maxWidth * 0.1597;

        return Material(
          borderRadius: BorderRadiusFoundation.all24r,
          clipBehavior: Clip.hardEdge,
          color: theme?.colorScheme.surface1,
          child: Ink(
            height: calculatedHeight,
            child: Row(
              children: [
                1.sw <= 380 ? SpacingFoundation.horizontalSpace12 : SpacingFoundation.horizontalSpace16,
                ClipRRect(
                  borderRadius: BorderRadiusFoundation.all10,
                  child: ImageWidget(
                    link: activityUiModel?.imageUrl,
                    fit: BoxFit.cover,
                    height: 0.13.sw,
                    width: 0.18.sw,
                  ),
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing12),
                SpacingFoundation.horizontalSpace8,
                if (activityUiModel?.title != null && activityUiModel!.title!.isNotEmpty)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final text = activityUiModel!.title!;
                        final style = boldTextTheme?.caption3Medium;
                        final maxWidth = constraints.maxWidth;

                        final textPainter = TextPainter(
                          text: TextSpan(text: text, style: style),
                          maxLines: 1,
                          textDirection: intl.Bidi.isRtlLanguage() ? TextDirection.rtl : TextDirection.ltr,
                        );

                        textPainter.layout(maxWidth: maxWidth - SpacingFoundation.horizontalSpacing12);

                        final isTwoLines = textPainter.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isTwoLines) SpacingFoundation.verticalSpace4,
                            Text(
                              text,
                              style: style,
                              maxLines: 2,
                            ),
                            Flexible(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  if (activityUiModel?.rating != null && activityUiModel?.rating != 0.0)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ImageWidget(
                                          iconData: ShuffleUiKitIcons.starfill,
                                          color: colorScheme?.inverseSurface,
                                          height: 0.040625.sw,
                                          width: 0.040625.sw,
                                          fit: BoxFit.cover,
                                        ),
                                        SpacingFoundation.horizontalSpace2,
                                        Text(
                                          doubleFormat(activityUiModel!.rating!),
                                          style: boldTextTheme?.caption3Medium,
                                        ).paddingOnly(top: SpacingFoundation.horizontalSpacing2),
                                        SpacingFoundation.horizontalSpace12,
                                      ],
                                    ),
                                  if (activityUiModel?.tags != null && activityUiModel!.tags!.isNotEmpty)
                                    ...activityUiModel!.tags!.map(
                                      (e) => UiKitTagWidget(
                                        title: e.title,
                                        icon: e.icon,
                                        customTextStyle: boldTextTheme?.caption3Medium.copyWith(
                                          color: ColorsFoundation.mutedText,
                                        ),
                                      ).paddingOnly(right: SpacingFoundation.horizontalSpacing12),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing10);
                      },
                    ),
                  ),
                SpacingFoundation.horizontalSpace12,
                if (activityUiModel?.activity != null && activityUiModel?.activity != 0)
                  Ink(
                    width: sideInfoCardsWidth,
                    color: theme?.colorScheme.surface3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageWidget(
                          color: colorScheme?.inversePrimary,
                          svgAsset: GraphicsFoundation.instance.svg.twoPeople,
                          fit: BoxFit.fitHeight,
                          height: 18.w,
                        ),
                        SpacingFoundation.verticalSpace4,
                        AutoSizeText(
                          '${activityUiModel!.activity!}',
                          style: boldTextTheme?.body,
                          maxLines: 1,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
