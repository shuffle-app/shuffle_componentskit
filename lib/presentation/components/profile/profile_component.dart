import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

//ignore_for_file: no-empty-block

class ProfileComponent extends StatelessWidget {
  final UiProfileModel profile;
  final VoidCallback? onHowItWorksPoped;
  final ValueChanged<InvitationData?>? onInvite;
  final bool showHowItWorks;
  final bool businessContentEnabled;
  final bool showRecommendedUsers;
  final List<HangoutRecommendation>? recommendedUsers;
  final List<UiEventModel>? events;
  final List<UiEventModel> favoriteEvents;
  final List<UiPlaceModel> favoritePlaces;
  final Function(UiEventModel)? onEventTap;
  final VoidCallback? onMyEventsPressed;
  final VoidCallback? onFulfillDream;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onMessagePressed;
  final VoidCallback? onAllVideoReactionsPressed;
  final VoidCallback? onAllFeedbacksPressed;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final VoidCallback? onRecommendedUserMessagePressed;
  final ValueChanged<HangoutRecommendation>? onRecommendedUserAvatarPressed;
  final PagingController<int, VideoReactionUiModel>? videoReactionsPagingController;
  final PagingController<int, FeedbackUiModel>? feedbackPagingController;

  const ProfileComponent({
    Key? key,
    required this.profile,
    this.videoReactionsPagingController,
    this.feedbackPagingController,
    this.recommendedUsers,
    this.showHowItWorks = false,
    this.businessContentEnabled = false,
    this.showRecommendedUsers = false,
    this.onHowItWorksPoped,
    this.onMyEventsPressed,
    this.onFulfillDream,
    this.onReactionTapped,
    this.onAllVideoReactionsPressed,
    this.onAllFeedbacksPressed,
    this.onInvite,
    this.events,
    this.onEventTap,
    this.onSettingsPressed,
    this.onMessagePressed,
    this.onRecommendedUserMessagePressed,
    this.favoriteEvents = const [],
    this.favoritePlaces = const [],
    this.onRecommendedUserAvatarPressed,
  }) : super(key: key);

  bool get _noFeedbacks => feedbackPagingController?.itemList?.isEmpty ?? true;

  bool get _noVideoReactions => videoReactionsPagingController?.itemList?.isEmpty ?? true;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    return BlurredAppBarPage(
      centerTitle: true,
      title: S.of(context).MyCard,
      leading: context.iconButtonNoPadding(
        data: BaseUiKitButtonData(
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.settings,
            color: context.uiKitTheme?.colorScheme.inversePrimary,
            size: 26.h,
          ),
          onPressed: onSettingsPressed,
        ),
      ),
      appBarTrailing: context.iconButtonNoPadding(
        data: BaseUiKitButtonData(
          iconInfo: BaseUiKitButtonIconData(
            iconData: ShuffleUiKitIcons.message,
            color: context.uiKitTheme?.colorScheme.inversePrimary,
            size: 26.h,
          ),
          onPressed: onMessagePressed,
        ),
      ),
      bodyBottomSpace: verticalMargin,
      children: [
        verticalMargin.heightBox,
        profile.cardWidget.paddingSymmetric(horizontal: horizontalMargin),
        if (showRecommendedUsers) ...[
          SpacingFoundation.verticalSpace24,
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                if (businessContentEnabled)
                  Text(
                    S.of(context).FindSomeoneToNetworkWith,
                    style: textTheme?.title1,
                  ),
                if (!businessContentEnabled)
                  Text(
                    S.of(context).FindSomeoneToHangOutWith,
                    style: textTheme?.title1,
                  ),
                if (showHowItWorks)
                  HowItWorksWidget(
                    title: S.current.ProfileFindSomeoneHiwTitle,
                    subtitle: S.current.ProfileFindSomeoneHiwSubtitle,
                    hintTiles: [
                      HintCardUiModel(
                        title: S.current.ProfileFindSomeoneHiwHint(0),
                        imageUrl: GraphicsFoundation.instance.png.companions.path,
                      ),
                      HintCardUiModel(
                        title: S.current.ProfileFindSomeoneHiwHint(1),
                        imageUrl: GraphicsFoundation.instance.png.preferences.path,
                      ),
                      HintCardUiModel(
                        title: S.current.ProfileFindSomeoneHiwHint(2),
                        imageUrl: GraphicsFoundation.instance.png.pointsReputation.path,
                      ),
                      HintCardUiModel(
                        title: S.current.ProfileFindSomeoneHiwHint(3),
                        imageUrl: GraphicsFoundation.instance.png.foe.path,
                      ),
                    ],
                    onPop: onHowItWorksPoped,
                    customOffset: Offset(MediaQuery.sizeOf(context).width / 1.5, 35),
                  ),
              ],
            ).paddingSymmetric(horizontal: horizontalMargin),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitHorizontalScroll3D(
            itemBuilder: (BuildContext context, int index) {
              final user = recommendedUsers?[index];

              return UiKitFindSomeoneCard(
                avatarUrl: user?.userAvatar ?? GraphicsFoundation.instance.png.mockUserAvatar.path,
                userNickName: user?.userNickname ?? '',
                userName: user?.userName ?? '',
                userPoints: user?.userPointsBalance ?? 0,
                sameInterests: user?.commonInterests ?? 0,
                userTileType: user?.userTileType ?? UserTileType.ordinary,
                onAvatarTapped: () => onRecommendedUserAvatarPressed?.call(user!),
                onMessage: () {
                  onRecommendedUserMessagePressed?.call();
                  // buildComponent(
                  //   context,
                  //   ComponentModel.fromJson(GlobalConfiguration().appConfig.content['invite_people_places']),
                  //   ComponentBuilder(
                  //     useRootNavigator: true,
                  //     child: Builder(
                  //       builder: (context) {
                  //         var model = UiInviteToFavoritePlacesModel(
                  //           date: DateTime.now(),
                  //         );
                  //         String? selected;
                  //
                  //         return StatefulBuilder(
                  //           builder: (context, state) => InviteToFavoritePlacesComponent(
                  //             places: favoritePlaces
                  //                 .map(
                  //                   (e) => UiKitLeadingRadioTile(
                  //                     title: e.title ?? '',
                  //                     selected: selected == (e.title ?? ''),
                  //                     onTap: () {
                  //                       state(() {
                  //                         selected = e.title ?? '';
                  //                       });
                  //                     },
                  //                     avatarLink: e.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                  //                     tags: e.tags,
                  //                   ),
                  //                 )
                  //                 .toList(),
                  //             events: favoriteEvents
                  //                 .map((e) => UiKitLeadingRadioTile(
                  //                       title: e.title ?? '',
                  //                       selected: selected == (e.title ?? ''),
                  //                       onTap: () {
                  //                         state(() {
                  //                           selected = e.title ?? '';
                  //                         });
                  //                       },
                  //                       avatarLink: e.media.firstWhere((element) => element.type == UiKitMediaType.image).link,
                  //                       tags: e.tags,
                  //                     ))
                  //                 .toList(),
                  //             uiModel: model,
                  //             onInvite: onInvite == null || selected == null
                  //                 ? null
                  //                 : () {
                  //                     Navigator.of(context, rootNavigator: true).pop();
                  //                     onInvite?.call(
                  //                       InvitationData(
                  //                         user: user,
                  //                         placeId: 0,
                  //                         placePhotoUrl: GraphicsFoundation.instance.png.place.path,
                  //                         placeName: selected ?? '',
                  //                         placeTags: [
                  //                           UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                  //                           UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                  //                           UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                  //                           UiKitTag(title: 'title', icon: ShuffleUiKitIcons.cocktail),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   },
                  //             onDatePressed: () async {
                  //               final newDate = await showUiKitCalendarDialog(
                  //                 context,
                  //                 selectableDayPredicate: (day) {
                  //                   log(day.toIso8601String(), name: 'ProfileComponent');
                  //
                  //                   return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
                  //                 },
                  //               );
                  //               if (newDate != null) {
                  //                 state(() => model = UiInviteToFavoritePlacesModel(date: newDate));
                  //               }
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // );
                },
              );
            },
            itemCount: recommendedUsers?.length ?? 3,
          ),
        ],
        SpacingFoundation.verticalSpace24,
        if (videoReactionsPagingController != null)
          ValueListenableBuilder(
            valueListenable: videoReactionsPagingController!,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                color: colorScheme?.surface1,
                contentHeight: _noVideoReactions ? 0.15.sh : 0.26.sh,
                title: Text(
                  "S.current.MyReactions",
                  style: textTheme?.title1,
                ),
                action: context
                    .smallOutlinedButton(
                      blurred: false,
                      data: BaseUiKitButtonData(
                        iconInfo: BaseUiKitButtonIconData(
                          iconData: ShuffleUiKitIcons.chevronright,
                        ),
                        onPressed: onAllVideoReactionsPressed,
                      ),
                    )
                    .paddingOnly(right: SpacingFoundation.horizontalSpacing16),
                content: _noVideoReactions
                    ? Text(
                        "S.current.NoVideoReactionsYet",
                        style: textTheme?.subHeadline,
                      ).paddingAll(EdgeInsetsFoundation.all16)
                    : UiKitHorizontalScrollableList<VideoReactionUiModel>(
                        itemBuilder: (context, reaction, index) {
                          return UiKitReactionPreview(
                            imagePath: reaction.previewImageUrl ?? '',
                            viewed: false,
                            onTap: () => onReactionTapped?.call(reaction),
                          );
                        },
                        pagingController: videoReactionsPagingController!,
                      ),
              );
            },
          ),
        if (videoReactionsPagingController != null) SpacingFoundation.verticalSpace24,
        if (feedbackPagingController != null)
          ValueListenableBuilder(
              valueListenable: feedbackPagingController!,
              builder: (context, value, child) {
                return UiKitColoredAccentBlock(
                  title: Text(
                  "  S.current.MyFeedback",
                    style: textTheme?.title1,
                  ),
                  color: colorScheme?.surface1,
                  contentHeight: _noFeedbacks ? 0.15.sh : 0.28.sh,
                  action: context
                      .smallOutlinedButton(
                        blurred: false,
                        data: BaseUiKitButtonData(
                          iconInfo: BaseUiKitButtonIconData(
                            iconData: ShuffleUiKitIcons.chevronright,
                          ),
                          onPressed: onAllFeedbacksPressed,
                        ),
                      )
                      .paddingOnly(right: SpacingFoundation.horizontalSpacing16),
                  content: _noFeedbacks
                      ? Text(
                    //TODO comment
                          "S.current.NoFeedbacksYet",
                          style: textTheme?.subHeadline,
                        ).paddingAll(EdgeInsetsFoundation.all16)
                      : UiKitHorizontalScrollableList<FeedbackUiModel>(
                          leftPadding: horizontalMargin,
                          spacing: SpacingFoundation.horizontalSpacing8,
                          shimmerLoadingChild: SizedBox(width: 0.85.sw, child: const UiKitFeedbackCard()),
                          itemBuilder: (context, feedback, index) {
                            return SizedBox(
                              width: 0.85.sw,
                              child: UiKitFeedbackCard(
                                title: feedback.feedbackAuthorName,
                                avatarUrl: feedback.feedbackAuthorPhoto,
                                datePosted: feedback.feedbackDateTime,
                                companyAnswered: false,
                                text: feedback.feedbackText,
                              ).paddingOnly(left: index == 0 ? horizontalMargin : 0),
                            );
                          },
                          pagingController: feedbackPagingController!,
                        ),
                );
              }),
        if (feedbackPagingController != null) SpacingFoundation.verticalSpace24,
        if (profile.userTileType == UserTileType.pro) ...[
          MyEventsComponent(
              title: S.of(context).MyEvents,
              onTap: onMyEventsPressed ?? () {},
              onEventTap: onEventTap ?? (_) {},
              events: events ?? []),
          SpacingFoundation.verticalSpace24,
        ],
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Text(
                S.of(context).AskOrSupport,
                style: textTheme?.title1,
              ),
              if (showHowItWorks)
                HowItWorksWidget(
                  title: S.current.ProfileAskOrSupportHiwTitle,
                  subtitle: S.current.ProfileAskOrSupportHiwSubtitle,
                  hintTiles: [
                    HintCardUiModel(
                      title: S.current.ProfileAskOrSupportHiwHint(0),
                      imageUrl: GraphicsFoundation.instance.png.donat.path,
                    ),
                    HintCardUiModel(
                      title: S.current.ProfileAskOrSupportHiwHint(1),
                      imageUrl: GraphicsFoundation.instance.png.shoot.path,
                    ),
                    HintCardUiModel(
                      title: S.current.ProfileAskOrSupportHiwHint(2),
                      imageUrl: GraphicsFoundation.instance.png.honest.path,
                    ),
                    HintCardUiModel(
                      title: S.current.ProfileAskOrSupportHiwHint(3),
                      imageUrl: GraphicsFoundation.instance.png.help.path,
                    ),
                  ],
                  onPop: onHowItWorksPoped,
                  customOffset: Offset(MediaQuery.sizeOf(context).width / 1.4, 8),
                ),
            ],
          ).paddingSymmetric(horizontal: horizontalMargin),
        ),
        SpacingFoundation.verticalSpace16,
        Text(
          S.of(context).AcceptDonations,
          style: context.uiKitTheme?.boldTextTheme.caption1Medium,
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace16,
        GradientableWidget(
          gradient: GradientFoundation.attentionCard,
          child: context.outlinedGradientButton(
            gradient: GradientFoundation.touchIdgradientBorder,
            data: BaseUiKitButtonData(
              fit: ButtonFit.fitWidth,
              text: S.of(context).FulfillTheDream.toUpperCase(),
              onPressed: () => onFulfillDream?.call(),
            ),
          ),
        ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace24,
        kBottomNavigationBarHeight.heightBox,
      ],
    );
  }
}
