import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shuffle_components_kit/domain/config_models/profile/component_profile_model.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

//ignore_for_file: no-empty-block

class ProfileComponent extends StatelessWidget {
  final UiProfileModel profile;
  final VoidCallback? onHowItWorksPoped;
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
  final ValueChanged<int>? onRecommendedUserCardChanged;
  final VoidCallback? onRecommendedUserMessagePressed;
  final ValueChanged<HangoutRecommendation>? onRecommendedUserAvatarPressed;
  final PagingController<int, VideoReactionUiModel>?
      videoReactionsPagingController;
  final PagingController<int, FeedbackUiModel>? feedbackPagingController;
  final ValueChanged<FeedbackUiModel>? onFeedbackCardPressed;
  final int? unreadMessagesCount;

  const ProfileComponent({
    super.key,
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
    this.events,
    this.onEventTap,
    this.onSettingsPressed,
    this.onMessagePressed,
    this.onRecommendedUserMessagePressed,
    this.favoriteEvents = const [],
    this.favoritePlaces = const [],
    this.onRecommendedUserAvatarPressed,
    this.onRecommendedUserCardChanged,
    this.onFeedbackCardPressed,
    this.unreadMessagesCount,
  });

  bool get _noFeedbacks => feedbackPagingController?.itemList?.isEmpty ?? true;

  // bool get _noVideoReactions => videoReactionsPagingController?.itemList?.isEmpty ?? true;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.uiKitTheme?.boldTextTheme;
    final colorScheme = context.uiKitTheme?.colorScheme;
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model =
        ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin =
        (model.positionModel?.verticalMargin ?? 0).toDouble();
    final AutoSizeGroup _statsConstGroup = AutoSizeGroup();

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
      appBarTrailing: unreadMessagesCount == null
          ? context.iconButtonNoPadding(
              data: BaseUiKitButtonData(
                iconInfo: BaseUiKitButtonIconData(
                  iconData: ShuffleUiKitIcons.message,
                  color: context.uiKitTheme?.colorScheme.inversePrimary,
                  size: 26.h,
                ),
                onPressed: onMessagePressed,
              ),
            )
          : context.badgeButton(
              badgeValue: unreadMessagesCount,
              badgeAlignment: Alignment.topLeft,
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
        SpacingFoundation.verticalSpace24,
        Center(child:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // UiKitStatsActionCard(
              //   group: _statsConstGroup,
              //   stats: UiKitStats(
              //     title: S.current.Balance,
              //     value: '${profile.balance ?? 100}\$',
              //     actionButton: context.smallOutlinedButton(
              //       blurred: false,
              //       data: BaseUiKitButtonData(
              //         onPressed: profile.onBalanceDetails,
              //         iconInfo: BaseUiKitButtonIconData(
              //           size: 10.h,
              //           iconData: ShuffleUiKitIcons.chevronright,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SpacingFoundation.horizontalSpace16,
              UiKitStatsActionCard(
                group: _statsConstGroup,
                stats: UiKitStats(
                  title: S.current.Points,
                  value: profile.points?.toString() ?? '0',
                  actionButton: context.smallOutlinedButton(
                    data: BaseUiKitButtonData(
                      onPressed: profile.onPointsDetails,
                      iconInfo: BaseUiKitButtonIconData(
                        size: 10.h,
                        iconData: ShuffleUiKitIcons.chevronright,
                      ),
                    ),
                  ),
                ),
              ),
              SpacingFoundation.horizontalSpace16,
              UiKitSupportShuffle(
                onCustomDonate: profile.onCustomDonate,
                onDonate: profile.onDonate,
              ),
            ],
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.all16),
        )),
        if (showRecommendedUsers) ...[
          SpacingFoundation.verticalSpace24,
          SizedBox(
            width: double.infinity,
            child: TitleWithHowItWorks(
              title: businessContentEnabled
                  ? S.of(context).FindSomeoneToNetworkWith
                  : S.of(context).FindSomeoneToHangOutWith,
              textStyle: textTheme?.title1,
              shouldShow: showHowItWorks,
              howItWorksWidget: HowItWorksWidget(
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
                    imageUrl:
                        GraphicsFoundation.instance.png.pointsReputation.path,
                  ),
                  HintCardUiModel(
                    title: S.current.ProfileFindSomeoneHiwHint(3),
                    imageUrl: GraphicsFoundation.instance.png.foe.path,
                  ),
                ],
                onPop: onHowItWorksPoped,
              ),
            ).paddingSymmetric(horizontal: horizontalMargin),
          ),
          SpacingFoundation.verticalSpace24,
          UiKitHorizontalScroll3D(
            onItemChanged: onRecommendedUserCardChanged,
            itemBuilder: (BuildContext context, int index) {
              try {
                final user = recommendedUsers?[index];

                return UiKitFindSomeoneCard(
                  avatarUrl: user?.userAvatar,
                  userNickName: user?.userNickname ?? '',
                  userName: user?.userName ?? '',
                  userPoints: user?.userPointsBalance ?? 0,
                  sameInterests: user?.commonInterests ?? 0,
                  userTileType: user?.userTileType ?? UserTileType.ordinary,
                  onAvatarTapped: () =>
                      onRecommendedUserAvatarPressed?.call(user!),
                  onMessage: onRecommendedUserMessagePressed,
                );
              } catch (e) {
                return const SizedBox.shrink();
              }
            },
            itemCount: recommendedUsers?.length ?? 3,
          ),
        ],
        SpacingFoundation.verticalSpace24,
        // if (videoReactionsPagingController != null)
        if (videoReactionsPagingController != null)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: UiKitColoredAccentBlock(
              color: colorScheme?.surface1,
              contentHeight: 0.205.sh,
              titlePadding: EdgeInsetsFoundation.all16,
              title: Text(
                S.current.MyReactions,
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
              content: UiKitHorizontalScrollableList<VideoReactionUiModel>(
                spacing: SpacingFoundation.horizontalSpacing8,
                shimmerLoadingChild: UiKitReactionPreview(
                  customHeight: 0.205.sh,
                  imagePath: GraphicsFoundation.instance.png.place.path,
                ).paddingOnly(left: EdgeInsetsFoundation.horizontal16),
                noItemsFoundIndicator: SizedBox(
                    width: 1.sw,
                    child: Text(
                      S.current.NoVideoReactionsYet,
                      style: textTheme?.subHeadline,
                    ).paddingAll(EdgeInsetsFoundation.all16)),
                itemBuilder: (context, reaction, index) {
                  return UiKitReactionPreview(
                    customHeight: 0.205.sh,
                    imagePath: reaction.previewImageUrl ?? '',
                    viewed: reaction.isViewed,
                    onTap: () => onReactionTapped?.call(reaction),
                  ).paddingOnly(
                    left: index == 0
                        ? EdgeInsetsFoundation.all16
                        : EdgeInsetsFoundation.zero,
                  );
                },
                pagingController: videoReactionsPagingController!,
              ),
            ),
          ),
        if (videoReactionsPagingController != null)
          SpacingFoundation.verticalSpace24,
        if (feedbackPagingController != null)
          ValueListenableBuilder(
            valueListenable: feedbackPagingController!,
            builder: (context, value, child) {
              return UiKitColoredAccentBlock(
                title: Text(
                  S.current.MyFeedback,
                  style: textTheme?.title1,
                ),
                titlePadding: EdgeInsetsFoundation.all16,
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
                        S.current.NoFeedbacksYet,
                        style: textTheme?.subHeadline,
                      ).paddingAll(EdgeInsetsFoundation.all16)
                    : UiKitHorizontalScrollableList<FeedbackUiModel>(
                        spacing: SpacingFoundation.horizontalSpacing8,
                        shimmerLoadingChild: SizedBox(
                            width: 0.95.sw, child: const UiKitFeedbackCard()),
                        itemBuilder: (context, feedback, index) {
                          return SizedBox(
                            width: 0.95.sw,
                            child: UiKitFeedbackCard(
                              title: feedback.feedbackAuthorName,
                              avatarUrl: feedback.feedbackAuthorPhoto,
                              datePosted: feedback.feedbackDateTime,
                              companyAnswered: false,
                              text: feedback.feedbackText,
                              isHelpful: feedback.helpfulForUser,
                              helpfulCount: feedback.helpfulCount == 0
                                  ? null
                                  : feedback.helpfulCount,
                              onPressed: () =>
                                  onFeedbackCardPressed?.call(feedback),
                            ).paddingOnly(
                                left: index == 0
                                    ? EdgeInsetsFoundation.all16
                                    : 0),
                          );
                        },
                        pagingController: feedbackPagingController!,
                      ),
              );
            },
          ),
        if (feedbackPagingController != null) SpacingFoundation.verticalSpace24,
        if (profile.userTileType == UserTileType.pro) ...[
          MyEventsComponent(
              title: S.of(context).MyEvents,
              onTap: onMyEventsPressed ?? () {},
              onEventTap: onEventTap ?? (_) {},
              events: events ?? []),
          SpacingFoundation.verticalSpace24,
        ],
        // SizedBox(
        //   width: double.infinity,
        //   child: Stack(
        //     children: [
        //       Text(
        //         S.of(context).AskOrSupport,
        //         style: textTheme?.title1,
        //       ),
        //       if (showHowItWorks)
        //         HowItWorksWidget(
        //           title: S.current.ProfileAskOrSupportHiwTitle,
        //           subtitle: S.current.ProfileAskOrSupportHiwSubtitle,
        //           hintTiles: [
        //             HintCardUiModel(
        //               title: S.current.ProfileAskOrSupportHiwHint(0),
        //               imageUrl: GraphicsFoundation.instance.png.donat.path,
        //             ),
        //             HintCardUiModel(
        //               title: S.current.ProfileAskOrSupportHiwHint(1),
        //               imageUrl: GraphicsFoundation.instance.png.shoot.path,
        //             ),
        //             HintCardUiModel(
        //               title: S.current.ProfileAskOrSupportHiwHint(2),
        //               imageUrl: GraphicsFoundation.instance.png.honest.path,
        //             ),
        //             HintCardUiModel(
        //               title: S.current.ProfileAskOrSupportHiwHint(3),
        //               imageUrl: GraphicsFoundation.instance.png.help.path,
        //             ),
        //           ],
        //           onPop: onHowItWorksPoped,
        //           customOffset: Offset(MediaQuery.sizeOf(context).width / 1.4, 8),
        //         ),
        //     ],
        //   ).paddingSymmetric(horizontal: horizontalMargin),
        // ),
        // SpacingFoundation.verticalSpace16,
        // Text(
        //   S.of(context).AcceptDonations,
        //   style: context.uiKitTheme?.boldTextTheme.caption1Medium,
        // ).paddingSymmetric(horizontal: horizontalMargin),
        // SpacingFoundation.verticalSpace16,
        // GradientableWidget(
        //   gradient: GradientFoundation.attentionCard,
        //   child: context.outlinedGradientButton(
        //     gradient: GradientFoundation.touchIdgradientBorder,
        //     data: BaseUiKitButtonData(
        //       fit: ButtonFit.fitWidth,
        //       text: S.of(context).FulfillTheDream.toUpperCase(),
        //       onPressed: () => onFulfillDream?.call(),
        //     ),
        //   ),
        // ).paddingSymmetric(horizontal: horizontalMargin),
        SpacingFoundation.verticalSpace24,
        kBottomNavigationBarHeight.heightBox,
      ],
    );
  }
}
