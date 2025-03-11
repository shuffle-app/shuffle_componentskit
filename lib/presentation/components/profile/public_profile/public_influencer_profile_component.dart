import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/profile_highlights.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../domain/config_models/profile/component_profile_model.dart';

class PublicInfluencerProfileComponent extends StatelessWidget {
  final UiProfileModel uiProfileModel;
  final ProfileStats? profileStats;
  final bool loadingContent;
  final ValueNotifier<double>? tiltNotifier;
  final PagingController<int, VideoReactionUiModel>? storiesPagingController;
  final List<ProfilePlace>? profilePlaces;
  final ValueChanged<VideoReactionUiModel>? onReactionTapped;
  final List<InfluencerTopCategory>? influencerTopCategories;
  final List<ContentPreviewWithRespect>? contentPreviewWithRespects;
  final List<InfluencerPhotoUiModel>? influencerPhotos;
  final Future<void> Function(int)? onShowMoreTap;
  final Function(int? placeId, int? eventId)? onItemTap;
  final bool isLoading;
  final List<VoiceUiModel>? voices;

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
    this.influencerPhotos,
    this.onShowMoreTap,
    this.contentPreviewWithRespects,
    this.onItemTap,
    this.isLoading = false,
    this.voices,
  });

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
        uiProfileModel.name ?? '',
        maxLines: 2,
        style: textStyle,
        textAlign: TextAlign.center,
      )),
      customToolbarBaseHeight: (uiProfileModel.name ?? '').length > 15 ? 100 : null,
      autoImplyLeading: true,
      bodyBottomSpace: verticalMargin,
      childrenPadding: EdgeInsets.zero,
      children: uiProfileModel.userTileType != UserTileType.influencer
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
              if (loadingContent)
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
              if (isLoading)
                Center(child: CircularProgressIndicator())
                    .paddingSymmetric(vertical: SpacingFoundation.verticalSpacing32)
              else
                InfluencerReviewsTopRespectWidget(
                  voices: voices,
                  isPublic: true,
                  onShowMoreTap: onShowMoreTap,
                  influencerPhotos: influencerPhotos,
                  contentPreviewWithRespects: contentPreviewWithRespects,
                  influencerTopCategories: influencerTopCategories,
                  onItemTap: onItemTap,
                  onReactionTapped: onReactionTapped,
                  profilePlaces: profilePlaces,
                  storiesPagingController: storiesPagingController,
                  tiltNotifier: tiltNotifier,
                )
            ],
    );
  }
}
