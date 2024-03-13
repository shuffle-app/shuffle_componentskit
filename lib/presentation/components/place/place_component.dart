import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlaceComponent extends StatelessWidget {
  final UiPlaceModel place;
  final bool isCreateEventAvaliable;
  final VoidCallback? onEventCreate;
  final VoidCallback? onAddReactionTapped;
  final FutureOr<List<UiEventModel>>? events;
  final ComplaintFormComponent? complaintFormComponent;
  final ValueChanged<UiEventModel>? onEventTap;
  final VoidCallback? onSharePressed;
  final PagingController<int, VideoReactionUiModel>? reactionsPagingController;
  final PagingController<int, FeedbackUiModel>? feedbacksPagingController;

  const PlaceComponent({
    Key? key,
    required this.place,
    this.complaintFormComponent,
    this.isCreateEventAvaliable = false,
    this.onEventCreate,
    this.onAddReactionTapped,
    this.onEventTap,
    this.onSharePressed,
    this.events,
    this.reactionsPagingController,
    this.feedbacksPagingController,
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
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final colorScheme = theme?.colorScheme;
    final boldTextTheme = theme?.boldTextTheme;

    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      children: [
        SpacingFoundation.verticalSpace16,
        TitleWithAvatar(
          title: place.title,
          avatarUrl: place.logo,
          horizontalMargin: horizontalMargin,
          trailing: GestureDetector(
            onTap: onSharePressed,
            child: Icon(
              ShuffleUiKitIcons.share,
              color: colorScheme?.darkNeutral800,
            ),
          ),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace16,
        UiKitMediaSliderWithTags(
          rating: place.rating,
          media: place.media,
          description: place.description,
          baseTags: place.baseTags,
          uniqueTags: place.tags,
          horizontalMargin: horizontalMargin,
          branches: model.showBranches ?? false
              ? [
                  /// mock branches
                  HorizontalCaptionedImageData(
                    imageUrl: GraphicsFoundation.instance.png.place.path,
                    caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
                  ),
                  HorizontalCaptionedImageData(
                    imageUrl: GraphicsFoundation.instance.png.place.path,
                    caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
                  ),
                  HorizontalCaptionedImageData(
                    imageUrl: GraphicsFoundation.instance.png.place.path,
                    caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
                  ),
                  HorizontalCaptionedImageData(
                    imageUrl: GraphicsFoundation.instance.png.place.path,
                    caption: 'Dubai mall 1st floor, next to the Aquarium. This is a mock branch to see how it looks in app',
                  ),
                ]
              : place.branches,
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
        if (reactionsPagingController != null)
          UiKitColoredAccentBlock(
            color: colorScheme?.surface1,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  S.current.ReactionsBy,
                  style: boldTextTheme?.body,
                ),
                SpacingFoundation.horizontalSpace12,
                const Expanded(child: MemberPlate()),
              ],
            ),
            contentHeight: 0.2605.sh,
            content: reactionsPagingController?.itemList?.isEmpty ?? true
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: UiKitReactionPreview.empty(onTap: onAddReactionTapped).paddingSymmetric(horizontal: horizontalMargin),
                  )
                : UiKitHorizontalScrollableList<VideoReactionUiModel>(
                    leftPadding: horizontalMargin,
                    spacing: SpacingFoundation.horizontalSpacing8,
                    itemBuilder: (context, reaction, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UiKitReactionPreview.empty(onTap: onAddReactionTapped),
                            SpacingFoundation.horizontalSpace8,
                            UiKitReactionPreview(
                              imagePath: reaction.previewImageUrl ?? '',
                              viewed: false,
                              onTap: () {},
                            ),
                          ],
                        );
                      }

                      return UiKitReactionPreview(
                        imagePath: reaction.previewImageUrl ?? '',
                        viewed: false,
                        onTap: () {},
                      );
                    },
                    pagingController: reactionsPagingController!,
                  ),
          ),
        if (isCreateEventAvaliable)
          FutureBuilder(
            future: Future.value(events ?? []),
            builder: (context, snapshot) => UiKitCardWrapper(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).UpcomingEvent, style: boldTextTheme?.subHeadline),
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
                          style: boldTextTheme?.caption1Bold,
                        ),
                        subtitle: event.date != null
                            ? Text(
                                DateFormat('MMMM d').format(event.date!),
                                style: boldTextTheme?.caption1Medium.copyWith(
                                  color: colorScheme?.darkNeutral500,
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
                                  color: colorScheme?.inversePrimary,
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
                ],
              ).paddingSymmetric(
                horizontal: SpacingFoundation.horizontalSpacing16,
                vertical: SpacingFoundation.verticalSpacing8,
              ),
            ).paddingSymmetric(
              horizontal: horizontalMargin,
              vertical: EdgeInsetsFoundation.vertical8,
            ),
          )
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
                      value: S.current.WithInDays(daysToEvent.inDays),
                      group: group,
                      rasterIconAsset: GraphicsFoundation.instance.png.events,
                      action: () {
                        if (closestEvent != null) {
                          onEventTap?.call(closestEvent!);
                        } else {
                          buildComponent(context, ComponentEventModel.fromJson(config['event']),
                              ComponentBuilder(child: EventComponent(event: closestEvent!)));
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
            ),
          ).paddingSymmetric(horizontal: horizontalMargin, vertical: EdgeInsetsFoundation.vertical8),
        Wrap(
          runSpacing: SpacingFoundation.verticalSpacing8,
          children: place.descriptionItems!
              .map(
                (e) => GestureDetector(
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
                  ),
                ),
              )
              .toList(),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace8,
        (kBottomNavigationBarHeight * 1.5).heightBox,
      ],
    ).paddingSymmetric(vertical: verticalMargin);
  }
}
