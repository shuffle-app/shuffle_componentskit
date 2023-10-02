import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel place;
  final bool isCreateEventAvaliable;
  final VoidCallback? onEventCreate;
  final List<UiEventModel>? events;
  final ComplaintFormComponent? complaintFormComponent;

  const PlaceComponent(
      {Key? key,
      required this.place,
      this.complaintFormComponent,
      this.isCreateEventAvaliable = false,
      this.onEventCreate,
      this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
                version: '', horizontalMargin: 16, verticalMargin: 10, bodyAlignment: Alignment.centerLeft))
        : ComponentPlaceModel.fromJson(config['place']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final bodyAlignment = model.positionModel?.bodyAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final AutoSizeGroup gridGroup = AutoSizeGroup();
    final theme = context.uiKitTheme;

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: titleAlignment.mainAxisAlignment,
          crossAxisAlignment: titleAlignment.crossAxisAlignment,
          children: [
            TitleWithAvatar(
              title: place.title,
              avatarUrl: place.logo,
              horizontalMargin: horizontalMargin,
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: bodyAlignment.mainAxisAlignment,
          crossAxisAlignment: bodyAlignment.crossAxisAlignment,
          children: [
            Stack(children: [
              UiKitMediaSliderWithTags(
                rating: place.rating,
                media: place.media,
                description: place.description,
                baseTags: place.baseTags,
                uniqueTags: place.tags,
                horizontalMargin: horizontalMargin,
              ),
              if (complaintFormComponent != null)
                Positioned(
                    top: (kIsWeb ? 156 : 0.48.sw) - 40,
                    right: 0,
                    child: Transform.scale(
                        scale: 0.5.sp,
                        child: context.smallOutlinedButton(
                            color: UiKitColors.darkNeutral800.withOpacity(0.5),
                            data: BaseUiKitButtonData(
                              onPressed: () {
                                showUiKitGeneralFullScreenDialog(
                                    context,
                                    GeneralDialogData(
                                        topPadding: 0.3.sh, useRootNavigator: false, child: complaintFormComponent!));
                              },
                              icon: Transform.scale(
                                  scale: 1.5.sp,
                                  child: ImageWidget(
                                    // height: 20,
                                    svgAsset: GraphicsFoundation.instance.svg.alertCircle,
                                  )),
                            ),
                            blurred: true))),
            ]),
            SpacingFoundation.verticalSpace8,
            if (isCreateEventAvaliable)
              UiKitCardWrapper(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Upcoming event', style: theme?.boldTextTheme.subHeadline),
                if (events != null && events!.isNotEmpty) ...[
                  SpacingFoundation.verticalSpace8,
                  Expanded(
                    child: ListView.separated(
                      itemCount: events!.length,
                      itemBuilder: (context, index) {
                        final event = events![index];

                        return ListTile(
                          isThreeLine: true,
                          contentPadding: EdgeInsets.zero,
                          leading: BorderedUserCircleAvatar(
                            imageUrl: event.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                            size: 40.w,
                          ),
                          title: Text(
                            event.title ?? '',
                            style: theme?.boldTextTheme.caption1Bold,
                          ),
                          subtitle: event.date != null
                              ? Text(
                                  DateFormat('MMMM d').format(event.date!),
                                  style: theme?.boldTextTheme.caption1Medium.copyWith(
                                    color: theme.colorScheme.darkNeutral500,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          trailing: context.smallButton(
                            data: BaseUiKitButtonData(
                              onPressed: () {
                                buildComponent(context, ComponentPlaceModel.fromJson(config['event']),
                                    ComponentBuilder(child: EventComponent(event: event)));
                              },
                              icon: Icon(
                                CupertinoIcons.right_chevron,
                                color: theme?.colorScheme.inversePrimary,
                                size: 20.w,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SpacingFoundation.verticalSpace4,
                    ),
                  ),
                ],
                SpacingFoundation.verticalSpace8,
                context.gradientButton(
                    data: BaseUiKitButtonData(text: 'Create Event', onPressed: onEventCreate, fit: ButtonFit.fitWidth))
              ]).paddingSymmetric(
                horizontal: horizontalMargin,
                vertical: SpacingFoundation.verticalSpacing8,
              )).paddingSymmetric(
                horizontal: horizontalMargin,
              )
            else
              Row(
                mainAxisSize: MainAxisSize.max,
                children: () {
                  final AutoSizeGroup g = AutoSizeGroup();

                  return [
                    Expanded(
                      child: UpcomingEventPlaceActionCard(
                        value: 'in 2 days',
                        group: g,
                        rasterIconAsset: GraphicsFoundation.instance.png.events,
                        action: () {
                          log('calendar was pressed');
                        },
                      ),
                    ),
                    SpacingFoundation.horizontalSpace8,
                    Expanded(
                      child: PointBalancePlaceActionCard(
                        value: '2 650',
                        group: g,
                        rasterIconAsset: GraphicsFoundation.instance.png.coin,
                        action: () {
                          log('balance was pressed');
                        },
                      ),
                    ),
                  ];
                }(),
              ),
            SpacingFoundation.verticalSpace8,
            GridView.count(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
              childAspectRatio: 2,
              children: place.descriptionItems!
                  .map((e) => GestureDetector(
                      onTap: () {
                        if (e.description.startsWith('http')) {
                          launchUrlString(e.description);
                        } else if (e.description.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                          log('launching $e.description', name: 'PlaceComponent');
                          launchUrlString('tel:${e.description}');
                        }
                      },
                      child: UiKitTitledDescriptionGridWidget(
                        title: e.title,
                        group: gridGroup,
                        description: e.description,
                        spacing: SpacingFoundation.horizontalSpacing8,
                      )))
                  .toList(),
            ).paddingSymmetric(horizontal: horizontalMargin),
            SpacingFoundation.verticalSpace8,
          ],
        ),
      ],
      // ),
    ).paddingSymmetric(vertical: verticalMargin);
  }
}
