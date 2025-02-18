import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/profile_highlights.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../domain/config_models/profile/component_profile_model.dart';

class PublicInfluencerProfileComponent extends StatefulWidget {
  final UiProfileModel uiProfileModel;
  final ProfileStats? profileStats;
  final bool loadingContent;
  final ValueNotifier<double>? tiltNotifier;
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;
  final List<ProfilePlace>? profilePlaces;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final List<InfluencerTopCategory>? influencerTopCategories;
  final List<ContentPreviewWithRespect>? contentPreviewWithRespects;
  final Function(int? placeId, int? eventId)? onItemTap;
  final bool isLoading;

  const PublicInfluencerProfileComponent({
    super.key,
    required this.uiProfileModel,
    this.profileStats,
    this.loadingContent = false,
    this.tiltNotifier,
    this.storiesPagingController,
    this.profilePlaces,
    this.onReactionTapped,
    this.influencerTopCategories,
    this.contentPreviewWithRespects,
    this.onItemTap,
    this.isLoading = false,
  });

  @override
  State<PublicInfluencerProfileComponent> createState() => _PublicInfluencerProfileComponentState();
}

class _PublicInfluencerProfileComponentState extends State<PublicInfluencerProfileComponent> {
  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
    final ComponentProfileModel model = ComponentProfileModel.fromJson(config['profile']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0).toDouble();

    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;

    TextStyle? textStyle = boldTextTheme?.title1 ?? Theme.of(context).primaryTextTheme.titleMedium;
    textStyle = textStyle?.copyWith(color: theme?.colorScheme.inversePrimary);

    return BlurredAppBarPage(
      centerTitle: true,
      customTitle: Expanded(
          child: AutoSizeText(
        widget.uiProfileModel.name ?? '',
        maxLines: 2,
        style: textStyle,
        textAlign: TextAlign.center,
      )),
      customToolbarBaseHeight: (widget.uiProfileModel.name ?? '').length > 15 ? 100 : null,
      autoImplyLeading: true,
      bodyBottomSpace: verticalMargin,
      childrenPadding: EdgeInsets.zero,
      children: widget.uiProfileModel.userTileType != UserTileType.influencer
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
                            text: ' @${widget.uiProfileModel.nickname ?? ''} ',
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
                          text: ' @${widget.uiProfileModel.nickname ?? ''} ',
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
              widget.uiProfileModel.cardWidgetPublic.paddingSymmetric(horizontal: horizontalMargin),
              if (widget.profileStats != null)
                ProfileHighlights(profileStats: widget.profileStats!)
                    .paddingSymmetric(horizontal: horizontalMargin, vertical: SpacingFoundation.verticalSpacing16),
              if (widget.loadingContent)
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
              if (widget.isLoading)
                Center(child: CircularProgressIndicator())
                    .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing32)
              else
                InfluencerReviewsTopRespectWidget(
                  contentPreviewWithRespects: widget.contentPreviewWithRespects,
                  influencerTopCategories: widget.influencerTopCategories,
                  onItemTap: widget.onItemTap,
                  onReactionTapped: widget.onReactionTapped,
                  profilePlaces: widget.profilePlaces,
                  storiesPagingController: widget.storiesPagingController,
                  tiltNotifier: widget.tiltNotifier,
                )
            ],
    );
  }
}
