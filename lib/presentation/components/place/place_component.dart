import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:duration/duration.dart';
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
  final FutureOr<List<UiEventModel>>? events;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<UiEventModel>? onEventTap;
  final VoidCallback? onSharePressed;

  const PlaceComponent({
    Key? key,
    required this.place,
    this.complaintFormComponent,
    this.isCreateEventAvaliable = false,
    this.onEventCreate,
    this.onEventTap,
    this.onSharePressed,
    this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentPlaceModel model = kIsWeb
        ? ComponentPlaceModel(
            version: '',
            pageBuilderType: PageBuilderType.page,
            positionModel: PositionModel(
              version: '',
              horizontalMargin: 16,
              verticalMargin: 10,
              bodyAlignment: Alignment.centerLeft,
            ),
          )
        : ComponentPlaceModel.fromJson(config['place']);
    final titleAlignment = model.positionModel?.titleAlignment;
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

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
              trailing: GestureDetector(
                onTap: onSharePressed,
                child: Icon(
                  ShuffleUiKitIcons.share,
                  color: theme?.colorScheme.darkNeutral800,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
        UiKitMediaSliderWithTags(
          rating: place.rating,
          media: place.media,
          description: place.description,
          baseTags: place.baseTags,
          uniqueTags: place.tags,
          horizontalMargin: horizontalMargin,
          branches: place.branches
              // ?? Future.value( [
              //     /// mock branches
              //     HorizontalCaptionedImageData(
              //       imageUrl: GraphicsFoundation.instance.png.place.path,
              //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
              //     ),
              //     HorizontalCaptionedImageData(
              //       imageUrl: GraphicsFoundation.instance.png.place.path,
              //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
              //     ),
              //     HorizontalCaptionedImageData(
              //       imageUrl: GraphicsFoundation.instance.png.place.path,
              //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
              //     ),
              //     HorizontalCaptionedImageData(
              //       imageUrl: GraphicsFoundation.instance.png.place.path,
              //       caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
              //     ),
              //   ])
              ,
          actions: [
            if (complaintFormComponent != null)
              context.smallOutlinedButton(
                blurred: true,
                data: BaseUiKitButtonData(
                  iconInfo: BaseUiKitButtonIconData(
                    iconData: ShuffleUiKitIcons.alertcircle,
                    color: context.uiKitTheme?.colorScheme.darkNeutral800,
                  ),
                  onPressed: () {
                    showUiKitGeneralFullScreenDialog(
                      context,
                      GeneralDialogData(
                        topPadding: 0.3.sh,
                        useRootNavigator: false,
                        child: complaintFormComponent!,
                      ),
                    );
                  },
                ),
                color: Colors.white.withOpacity(0.01),
                blurValue: 25,
              ),
          ],
        ),
        SpacingFoundation.verticalSpace8,
        if (isCreateEventAvaliable)
          FutureBuilder(
              future: Future.value(events ?? []),
              builder: (context, snapshot) => UiKitCardWrapper(
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(S.of(context).UpcomingEvent, style: theme?.boldTextTheme.subHeadline),
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) ...[
                      SpacingFoundation.verticalSpace8,
                      for (var event in snapshot.data!)
                        ListTile(
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
                          trailing: context
                              .smallButton(
                                data: BaseUiKitButtonData(
                                  onPressed: () {
                                    if (onEventTap != null) {
                                      onEventTap?.call(event);
                                    } else {
                                      buildComponent(context, ComponentEventModel.fromJson(config['event']),
                                          ComponentBuilder(child: EventComponent(event: event)));
                                    }
                                  },
                                  iconInfo: BaseUiKitButtonIconData(
                                    iconData: CupertinoIcons.right_chevron,
                                    color: theme?.colorScheme.inversePrimary,
                                    size: 20.w,
                                  ),
                                ),
                              )
                              .paddingOnly(top: SpacingFoundation.verticalSpacing4),
                        ),
                    ],
                    SpacingFoundation.verticalSpace4,
                    context.gradientButton(
                      data: BaseUiKitButtonData(
                        text: S.of(context).CreateEvent,
                        onPressed: onEventCreate,
                        fit: ButtonFit.fitWidth,
                      ),
                    )
                  ]).paddingSymmetric(
                    horizontal: SpacingFoundation.horizontalSpacing16,
                    vertical: SpacingFoundation.verticalSpacing8,
                  )).paddingSymmetric(
                    horizontal: horizontalMargin,
                  ))
        else
          FutureBuilder(
              future: Future.value(events ?? []),
              builder: (context, snapshot) => Row(
                    mainAxisSize: MainAxisSize.max,
                    children: () {
                      final AutoSizeGroup group = AutoSizeGroup();

                      final tempSorted = List.from(snapshot.data ?? [])..sort((a, b) => a.date!.compareTo(b.date!));

                      final closestEvent = tempSorted.firstOrNull;

                      final Duration daysToEvent = closestEvent?.date?.difference(DateTime.now()) ?? const Duration(days: 2);

                      return [
                        Expanded(
                          child: UpcomingEventPlaceActionCard(
                            value: 'in ${printDuration(daysToEvent, tersity: DurationTersity.day)}',
                            group: group,
                            rasterIconAsset: GraphicsFoundation.instance.png.events,
                            action: () {
                              if (closestEvent != null) {
                                if (onEventTap != null) {
                                  onEventTap?.call(closestEvent);
                                } else {
                                  buildComponent(context, ComponentEventModel.fromJson(config['event']),
                                      ComponentBuilder(child: EventComponent(event: closestEvent)));
                                }
                              }
                            },
                          ),
                        ),
                        SpacingFoundation.horizontalSpace8,
                        Expanded(
                          child: PointBalancePlaceActionCard(
                            value: '2 650',
                            group: group,
                            rasterIconAsset: GraphicsFoundation.instance.png.money,
                            action: () {
                              log('balance was pressed');
                            },
                          ),
                        ),
                      ];
                    }(),
                  )).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace8,
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing8,
          children: place.descriptionItems!
              .map((e) => GestureDetector(
                  onTap: () {
                    final url = e.descriptionUrl ?? e.description;

                    if (url.startsWith('http')) {
                      launchUrlString(url);
                    } else if (url.replaceAll(RegExp(r'[0-9]'), '').replaceAll('+', '').trim().isEmpty) {
                      log('launching $url', name: 'PlaceComponent');
                      launchUrlString('tel:${url}');
                    }
                  },
                  child: UiKitTitledDescriptionGridWidget(
                    title: e.title,
                    description: e.description,
                    spacing: SpacingFoundation.horizontalSpacing8,
                  )))
              .toList(),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace8,
      ],
    ).paddingSymmetric(vertical: verticalMargin);
  }
}
