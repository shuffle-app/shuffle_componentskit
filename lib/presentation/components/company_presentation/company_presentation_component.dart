import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/domain/data_uimodels/feedback_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../shuffle_components_kit.dart';
import '../components.dart';

class CompanyPresentationComponent extends StatelessWidget {
  const CompanyPresentationComponent(
      {super.key,
      required this.infoCardPagingController,
      required this.feedbacksPagingController,
      this.onFeedbackHelpfulTap,
      this.onFeedbackShowMoreTap,
      this.motivationBannerImage,
      this.motivationBannerTitle,
      required this.place,
      this.onSharePressed});

  final PagingController<int, String> infoCardPagingController;
  final PagingController<int, FeedbackUiModel> feedbacksPagingController;
  final VoidCallback? onFeedbackHelpfulTap;
  final VoidCallback? onFeedbackShowMoreTap;
  final String? motivationBannerImage;
  final String? motivationBannerTitle;
  final UiPlaceModel place;
  final VoidCallback? onSharePressed;

  @override
  Widget build(BuildContext context) {
    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
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
    final regularTextTheme = theme?.regularTextTheme;




    return Scaffold(
      body: BlurredAppBarPage(
        autoImplyLeading: true,
        centerTitle: true,
        customTitle: Expanded(
          child: Text(
            'Push up your business',
            style: context.uiKitTheme?.boldTextTheme.title1,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        customToolbarBaseHeight: 0.13.sh,
        children: [
          SpacingFoundation.verticalSpace16,
          SizedBox(
            height: 0.17.sh,
            child: PagedListView<int, String>(
              pagingController: infoCardPagingController,
              scrollDirection: Axis.horizontal,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return UiKitCardWrapper(
                    gradient: theme?.themeMode == ThemeMode.light
                        ? GradientFoundation.lightShunyGreyGradient
                        : GradientFoundation.shunyGreyGradient,
                    child: SizedBox(
                      width: 1.sw - (2 * EdgeInsetsFoundation.horizontal16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfluencerAccountMark(),
                          SpacingFoundation.horizontalSpace4,
                          Expanded(
                            child: Text(
                              item,
                              style: regularTextTheme?.caption1,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).paddingAll(EdgeInsetsFoundation.all16),
                    ),
                  ).paddingOnly(
                      left: index != 0
                          ? EdgeInsetsFoundation.horizontal8
                          : EdgeInsetsFoundation.zero,
                      right:
                          index != infoCardPagingController.itemList!.length - 1
                              ? EdgeInsetsFoundation.horizontal8
                              : EdgeInsetsFoundation.zero);
                },
              ),
            ),
          ).paddingSymmetric(horizontal: EdgeInsetsFoundation.horizontal16),

          SpacingFoundation.verticalSpace16,
          TitleWithAvatar(
            title: place.title,
            avatarUrl:place.logo,
            horizontalMargin: horizontalMargin,
            trailing: GestureDetector(
              onTap: onSharePressed,
              child: Icon(
                ShuffleUiKitIcons.share,
                color: colorScheme?.darkNeutral800,
              ),
            ),
          ),
          SpacingFoundation.verticalSpace16,
          UiKitMediaSliderWithTags(
            rating: place.rating,
            media: place.media,
            description:place.description,
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
          ),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            borderRadius: BorderRadiusFoundation.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.ReviewsByCritics,
                  style: regularTextTheme?.body,
                ).paddingAll(EdgeInsetsFoundation.all16),
                SizedBox(
                  height: 0.25.sh,
                  width: 1.sw,
                  child: PagedListView<int, FeedbackUiModel>(
                    scrollDirection: Axis.horizontal,
                    pagingController: feedbacksPagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        if (index ==
                            (feedbacksPagingController.itemList?.length ?? 0) -
                                1) {
                          return UiKitCardWrapper(
                            color: theme?.colorScheme.surface3,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onFeedbackShowMoreTap,
                                child: Ink(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Show\nmore",
                                        style: boldTextTheme?.caption1Bold,
                                      ),
                                      SpacingFoundation.horizontalSpace8,
                                      Icon(
                                        ShuffleUiKitIcons.chevronright,
                                        size: 24.sp,
                                        color:
                                            theme?.themeMode == ThemeMode.dark
                                                ? ColorsFoundation.lightSurface
                                                : ColorsFoundation.surface,
                                      )
                                    ],
                                  ).paddingSymmetric(
                                      horizontal:
                                          EdgeInsetsFoundation.horizontal12),
                                ),
                              ),
                            ),
                          ).paddingOnly(
                              left: EdgeInsetsFoundation.horizontal6,
                              right: EdgeInsetsFoundation.horizontal16);
                        } else {
                          return SizedBox(
                            width:
                                1.sw - (2 * EdgeInsetsFoundation.horizontal16),
                            child: UiKitFeedbackCard(
                              rating: item.feedbackRating,
                              title: item.feedbackAuthorName,
                              text: item.feedbackText,
                              datePosted: item.feedbackDateTime,
                              avatarUrl: item.feedbackAuthorPhoto,
                              helpfulCount: item.helpfulCount,
                              onLike: onFeedbackHelpfulTap,
                            ),
                          ).paddingOnly(
                              left: index == 0
                                  ? EdgeInsetsFoundation.horizontal16
                                  : EdgeInsetsFoundation.horizontal6,
                              right: EdgeInsetsFoundation.horizontal6);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ).paddingOnly(bottom: EdgeInsetsFoundation.vertical16),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusFoundation.all24,
                child: ImageWidget(
                  link: motivationBannerImage ??
                      GraphicsFoundation.instance.png.place.path,
                ),
              ),
              UiKitBlurWrapper(
                borderRadius: BorderRadiusFoundation.all24,
                border: Border.all(width: 0),
                childHorizontalPadding: EdgeInsetsFoundation.horizontal16,
                childVerticalPadding: EdgeInsetsFoundation.vertical16,
                child: Text(
                  motivationBannerTitle ?? '',
                  style: boldTextTheme?.title1,
                ),
              ).paddingAll(EdgeInsetsFoundation.all4)
            ],
          ).paddingAll(EdgeInsetsFoundation.all16)
        ],
      ),
    );
  }
}
