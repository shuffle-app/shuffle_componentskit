import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/profile_highlights.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  final int? heartEyesCount;
  final int? likesCount;
  final int? sunglassesCount;
  final int? firesCount;
  final int? smileyCount;

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
    this.heartEyesCount,
    this.likesCount,
    this.sunglassesCount,
    this.firesCount,
    this.smileyCount,
  });

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();
    final boldTextTheme = context.uiKitTheme?.boldTextTheme;
    final theme = context.uiKitTheme;

    TextStyle? textStyle = theme?.boldTextTheme.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return BlurredAppBarPage(
      centerTitle: true,
      customTitle: Expanded(
          child: AutoSizeText(
        uiProfileModel.name ?? '',
        maxLines: 2,
        style: textStyle,
        textAlign: TextAlign.center,
      )),
      customToolbarBaseHeight: 100,
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
                ProfileHighlights(profileStats: profileStats!)
                    .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
              if (bookingsAndInvitesChartData != null)
                UiKitLineChart(chartData: bookingsAndInvitesChartData!).paddingAll(horizontalMargin),
              if (events != null)
                UiKitExpandableList(
                  items: events!
                      .map<Widget>(
                        (event) => UiKitProUserProfileEventCard(
                          title: event.title ?? '',
                          previewImage: event.verticalPreview?.link ?? '',
                          contentDate: event.startDayForEvent ?? DateTime.now(),
                          properties: [...event.tags, ...event.baseTags],
                          firesCount: firesCount,
                          heartEyesCount: heartEyesCount,
                          likesCount: likesCount,
                          smileyCount: smileyCount,
                          sunglassesCount: sunglassesCount,
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
