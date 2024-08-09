import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../../domain/config_models/profile/component_profile_model.dart';

class PublicProProfileComponent extends StatelessWidget {
  final UiProfileModel uiProfileModel;
  final ProfileStats? profileStats;
  final UiKitLineChartData<num>? bookingsAndInvitesChartData;
  final List<UiEventModel>? events;
  final bool loadingEvents;
  final ValueChanged<FeedbackUiModel>? onFeedbackLiked;
  final ValueChanged<VideoReactionUiModel>? onVideoReactionTapped;
  final ValueChanged<FeedbackUiModel>? onFeedbackTapped;
  final Map<int, int?> feedbacksHelpfulCountsData;

  const PublicProProfileComponent({
    super.key,
    required this.uiProfileModel,
    required this.feedbacksHelpfulCountsData,
    this.profileStats,
    this.bookingsAndInvitesChartData,
    this.events,
    this.loadingEvents = false,
    this.onFeedbackLiked,
    this.onVideoReactionTapped,
    this.onFeedbackTapped,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;

    return BlurredAppBarPage(
      centerTitle: true,
      title: uiProfileModel.name ?? '',
      autoImplyLeading: true,
      bodyBottomSpace: verticalMargin,
      childrenPadding: EdgeInsets.zero,
      children: uiProfileModel.userTileType != UserTileType.pro
          ? [
              0.2.sh.heightBox,
              ImageWidget(
                rasterAsset: GraphicsFoundation.instance.png.noPhoto,
                height: 0.175.sh,
              ),
              Stack(
                children: [
                  GradientableWidget(
                    gradient: GradientFoundation.badgeIcon,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: S.current.UserHasNoPublicProfileStart,
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                          ),
                          TextSpan(
                            text: ' @${uiProfileModel.nickname ?? ''} ',
                            style: boldTextTheme?.title2.copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: S.current.UserHasNoPublicProfileEnd,
                            style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.current.UserHasNoPublicProfileStart,
                          style: boldTextTheme?.title2,
                        ),
                        TextSpan(
                          text: ' @${uiProfileModel.nickname ?? ''} ',
                          style: boldTextTheme?.title2.copyWith(color: Colors.transparent),
                        ),
                        TextSpan(
                          text: S.current.UserHasNoPublicProfileEnd,
                          style: boldTextTheme?.title2,
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingAll(EdgeInsetsFoundation.all16),
            ]
          : [
              verticalMargin.heightBox,
              uiProfileModel.cardWidgetPublic.paddingSymmetric(horizontal: horizontalMargin),
              if (profileStats != null)
                ProfileHighlights(
                  placesVisited: profileStats!.placesVisited,
                  reviewsPosted: profileStats!.reviewsPosted,
                  points: profileStats!.points,
                ).paddingOnly(
                    left: horizontalMargin, right: horizontalMargin, bottom: SpacingFoundation.verticalSpacing16),
              if (bookingsAndInvitesChartData != null)
                UiKitLineChart(chartData: bookingsAndInvitesChartData!).paddingAll(horizontalMargin),
              if (events != null)
                UiKitExpandableList(
                  items: events!
                      .map<Widget>(
                        (event) => UiKitProUserProfileEventCard(
                          title: event.title ?? '',
                          previewImage: event.verticalPreview?.link ?? '',
                          contentDate: event.startDate ?? DateTime.now(),
                          properties: [...event.tags, ...event.baseTags],
                          videoReactions: event.reactions
                              ?.map<ProfileVideoReaction>(
                                (reaction) => ProfileVideoReaction(
                                  image: reaction.previewImageUrl ?? '',
                                  isEmpty: reaction.empty,
                                  viewed: reaction.isViewed,
                                  onTap: () => onVideoReactionTapped?.call(reaction),
                                ),
                              )
                              .toList(),
                          reviews: event.reviews
                              ?.map(
                                (feedback) => UiKitFeedbackCard(
                                  title: feedback.feedbackAuthorName,
                                  avatarUrl: feedback.feedbackAuthorPhoto,
                                  userTileType: feedback.feedbackAuthorType,
                                  datePosted: feedback.feedbackDateTime,
                                  companyAnswered: false,
                                  text: feedback.feedbackText,
                                  rating: feedback.feedbackRating,
                                  isHelpful: feedback.helpfulForUser,
                                  helpfulCount: feedbacksHelpfulCountsData[feedback.id],
                                  onPressed: () {
                                    if (onFeedbackTapped != null) {
                                      onFeedbackTapped?.call(feedback);
                                    } else {
                                      feedback.onTap?.call();
                                    }
                                  },
                                  onLike: () => onFeedbackLiked?.call(feedback),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                  itemsTitle: S.current.Events,
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16, horizontal: horizontalMargin),
              if (loadingEvents)
                UiKitShimmerProgressIndicator(
                  gradient: GradientFoundation.shunyGreyGradient,
                  child: UiKitProUserProfileEventCard(
                    title: '',
                    contentDate: DateTime.now(),
                    videoReactions: [ProfileVideoReaction(image: GraphicsFoundation.instance.png.place.path)],
                    reviews: [
                      UiKitFeedbackCard(),
                    ],
                  ),
                ).paddingSymmetric(vertical: SpacingFoundation.verticalSpacing16, horizontal: horizontalMargin),
            ],
    );
  }
}
