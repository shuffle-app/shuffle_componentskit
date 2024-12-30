import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import 'rectangle_circle_animation.dart';
import 'row_gradient_circle.dart';

class PointsComponent extends StatelessWidget {
  final VoidCallback? onSpendCallBack;
  final VoidCallback? onHistoryCallBack;
  final bool showHIW;
  final int userPointsCount;
  final List<UiPointsModel>? listChallengeFeelings;
  final List<UiPointsModel>? listItemPoint;
  final UiUserPointsProgressBarModel uiUserPointsProgressBarModel;
  final UserTileType userType;

  PointsComponent({
    super.key,
    this.onSpendCallBack,
    this.onHistoryCallBack,
    this.listChallengeFeelings,
    this.listItemPoint,
    this.userType = UserTileType.ordinary,
    required this.uiUserPointsProgressBarModel,
    required this.userPointsCount,
    this.showHIW = false,
  });

  final ScrollController _scrollController = ScrollController();
  final AutoSizeGroup challengeFeelingsGroup = AutoSizeGroup();

  double get progressIndicatorHeight => 1.sw <= 380 ? 16.h : 12.h;

  LinearInfluencerIndicator _linearInfluencerIndicator(
    UiUserPointsProgressBarModel? uiUserPointsProgressBarModel,
    Color? customColor,
  ) {
    Gradient getCustomGradient() {
      if (uiUserPointsProgressBarModel != null) {
        if (uiUserPointsProgressBarModel.level < 1) {
          return GradientFoundation.bronzeGradient;
        } else if (1 <= uiUserPointsProgressBarModel.level && uiUserPointsProgressBarModel.level < 2) {
          return GradientFoundation.silverGradient;
        } else if (2 <= uiUserPointsProgressBarModel.level) {
          return GradientFoundation.goldGradient;
        } else {
          return GradientFoundation.bronzeGradient;
        }
      } else {
        return GradientFoundation.bronzeGradient;
      }
    }

    return LinearInfluencerIndicator(
      actualSum: (uiUserPointsProgressBarModel?.actual ?? 0) % 100,
      sum: uiUserPointsProgressBarModel?.sum ?? 100,
      width: 1.sw <= 380 ? 185.w : 215.w,
      height: progressIndicatorHeight,
      customGradient: getCustomGradient(),
      customColor: customColor,
    );
  }

  String getLevelTitle() {
    if (uiUserPointsProgressBarModel.level < 1) {
      switch (uiUserPointsProgressBarModel.isMenGender) {
        case true:
          return S.current.TravelerMen;
        default:
          return S.current.TravelerWom;
      }
    } else if (1 <= uiUserPointsProgressBarModel.level && uiUserPointsProgressBarModel.level < 2) {
      switch (uiUserPointsProgressBarModel.isMenGender) {
        case true:
          return S.current.SeekingWandererMen;
        default:
          return S.current.SeekingWandererWom;
      }
    } else if (2 <= uiUserPointsProgressBarModel.level) {
      switch (uiUserPointsProgressBarModel.isMenGender) {
        case true:
          return S.current.WiseacreOfSands;
        default:
          return S.current.WiseacreLadyOfSands;
      }
    } else {
      return S.current.TravelerMen;
    }
  }

  String stringWithSpace(int text) {
    NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(text).replaceAll(',', ' ');
  }

  String parseDoubleToInt(num text) {
    return text.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;

    return Scaffold(
      body: BlurredAppBarPage(
        controller: _scrollController,
        autoImplyLeading: true,
        appBarTrailing: context.iconButtonNoPadding(
          data: BaseUiKitButtonData(
            iconInfo: BaseUiKitButtonIconData(
              iconData: ShuffleUiKitIcons.history,
              iconAlignment: Alignment.centerRight,
            ),
            onPressed: onHistoryCallBack,
          ),
        ),
        customTitle: TitleWithHowItWorks(
          title: S.of(context).Points,
          textStyle: theme?.boldTextTheme.title1,
          shouldShow: showHIW,
          howItWorksWidget: HowItWorksWidget(
            title: S.of(context).PointsAre,
            subtitle: S.of(context).ShuffleExchangeSystem,
            hintTiles: [
              HintCardUiModel(
                title: S.of(context).PointsHiwItems(0),
                imageUrl: GraphicsFoundation.instance.png.reputation.path,
              ),
              HintCardUiModel(
                title: S.of(context).PointsHiwItems(1),
                imageUrl: GraphicsFoundation.instance.png.encreaseRaiting.path,
              ),
              HintCardUiModel(
                title: S.of(context).PointsHiwItems(2),
                imageUrl: GraphicsFoundation.instance.png.action.path,
              ),
              HintCardUiModel(
                title: S.of(context).PointsHiwItems(3),
                imageUrl: GraphicsFoundation.instance.png.earning.path,
              ),
            ],
          ),
        ),
        centerTitle: showHIW ? true : false,
        children: [
          SpacingFoundation.verticalSpace16,
          Row(
            children: [
              Text(
                S.of(context).Balance,
                style: theme?.regularTextTheme.caption1.copyWith(
                  color: theme.colorScheme.darkNeutral900,
                ),
              ),
              const Spacer(),
              Text(
                '${stringWithSpace(userPointsCount)} ${S.of(context).PointsCount(userPointsCount)}',
                style: theme?.boldTextTheme.subHeadline,
              ),
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
          context
              .midSizeOutlinedButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).Spend.toUpperCase(),
                  onPressed: onSpendCallBack,
                ),
              )
              .paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
          UiKitCardWrapper(
            color: theme?.colorScheme.surface2,
            borderRadius: BorderRadiusFoundation.all16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    GradientableWidget(
                      gradient: GradientFoundation.defaultLinearGradient,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: getLevelTitle(),
                              style: theme?.regularTextTheme.caption1.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: SpacingFoundation.verticalSpacing4),
                Row(
                  children: [
                    RowGradientCircle(
                      level: uiUserPointsProgressBarModel.level,
                      progressInCircle:
                          ((uiUserPointsProgressBarModel.actual - (uiUserPointsProgressBarModel.level * 400)) / 100)
                              .toInt(),
                    ).paddingAll(EdgeInsetsFoundation.all8),
                    SpacingFoundation.horizontalSpace4,
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _linearInfluencerIndicator(
                            uiUserPointsProgressBarModel,
                            ColorsFoundation.neutral16,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${(uiUserPointsProgressBarModel.actual % 100).floor()}/',
                                  style: theme?.regularTextTheme.caption2.copyWith(
                                    color: (uiUserPointsProgressBarModel.actual % 100).floor() >=
                                            (uiUserPointsProgressBarModel.sum / 2.2)
                                        ? ColorsFoundation.lightBodyTypographyColor
                                        : ColorsFoundation.mutedText,
                                  ),
                                ),
                                TextSpan(
                                  text: '${uiUserPointsProgressBarModel.sum.toInt()}',
                                  style: theme?.regularTextTheme.caption2.copyWith(
                                    color: (uiUserPointsProgressBarModel.actual % 100).floor() >
                                            (uiUserPointsProgressBarModel.sum / 1.5)
                                        ? ColorsFoundation.lightBodyTypographyColor
                                        : ColorsFoundation.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ).paddingAll(EdgeInsetsFoundation.all8),
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace24,
          listItemPoint != null
              ? ColoredBox(
                  color: theme?.colorScheme.surface2 ?? ColorsFoundation.surface2,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
                      mainAxisSpacing: SpacingFoundation.verticalSpacing6,
                    ),
                    itemCount: listItemPoint!.length,
                    itemBuilder: (context, index) {
                      final itemPoits = listItemPoint![index];
                      print(itemPoits.actualSum > itemPoits.sum);

                      return UiKitCardWrapper(
                        color: theme?.colorScheme.surface,
                        borderRadius: BorderRadiusFoundation.all24,
                        child: Stack(
                          children: [
                            ImageWidget(
                              height: 1.sw <= 380 ? 85.h : 75.h,
                              width: 85.w,
                              fit: BoxFit.fitWidth,
                              link: itemPoits.imagePath,
                            ),
                            const Align(
                              alignment: Alignment.topCenter,
                              child: TriangleAnimation(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                userType == UserTileType.premium && itemPoits.showStar
                                    ? ImageWidget(
                                        iconData: ShuffleUiKitIcons.star2,
                                        height: 12.h,
                                        color: theme?.colorScheme.bodyTypography,
                                      )
                                    : SpacingFoundation.none,
                                const Spacer(),
                                Text(
                                  itemPoits.title ?? S.of(context).NothingFound,
                                  style: theme?.boldTextTheme.caption3Medium,
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  '${itemPoits.getPoints} ${S.of(context).PointsCount(itemPoits.getPoints)}',
                                  style: theme?.boldTextTheme.caption2Bold,
                                ),
                                SpacingFoundation.verticalSpace4,
                                userType != UserTileType.premium && itemPoits.showStar
                                    ? ImageWidget(
                                        iconData: ShuffleUiKitIcons.star2,
                                        height: 12.h,
                                        color: theme?.colorScheme.bodyTypography,
                                      )
                                    : Text(
                                        '${parseDoubleToInt(itemPoits.actualSum)}/${parseDoubleToInt(itemPoits.sum)}',
                                        style: theme?.regularTextTheme.labelSmall.copyWith(
                                          color: ColorsFoundation.mutedText,
                                        ),
                                      ),
                                SpacingFoundation.verticalSpace2,
                                LinearInfluencerIndicator(
                                  actualSum:
                                      userType != UserTileType.premium && itemPoits.showStar ? 0 : itemPoits.actualSum,
                                  sum: itemPoits.sum,
                                  width: 120.w,
                                ),
                                // SpacingFoundation.verticalSpace16,
                              ],
                            ).paddingAll(EdgeInsetsFoundation.all16)
                          ],
                        ),
                      );
                    },
                  ).paddingOnly(
                    left: SpacingFoundation.horizontalSpacing16,
                    right: SpacingFoundation.horizontalSpacing16,
                    bottom: SpacingFoundation.verticalSpacing8,
                    top: SpacingFoundation.verticalSpacing16,
                  ),
                )
              : SpacingFoundation.none,
          if (listChallengeFeelings != null)
            ColoredBox(
              color: theme?.colorScheme.surface2 ?? ColorsFoundation.surface2,
              child: UiKitCardWrapper(
                color: theme?.colorScheme.surface,
                child: Column(
                  children: [
                    Text(
                      S.of(context).ChallengeFeelings,
                      style: theme?.boldTextTheme.caption1Bold,
                    ).paddingOnly(bottom: SpacingFoundation.verticalSpacing8),
                    Row(
                      children: listChallengeFeelings
                              ?.map(
                                (itemChallengeFeelings) => Expanded(
                                  child: Stack(
                                    children: [
                                      ImageWidget(
                                        height: 1.sw <= 380 ? 60.h : 45.h,
                                        width: 1.sw <= 380 ? 55.w : 45.w,
                                        fit: BoxFit.fitHeight,
                                        link: itemChallengeFeelings.imagePath,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 30.h),
                                          Text(
                                            '${parseDoubleToInt(itemChallengeFeelings.sum)} ${itemChallengeFeelings.title}',
                                            style: theme?.boldTextTheme.caption3Medium,
                                          ),
                                          AutoSizeText(
                                            '${itemChallengeFeelings.getPoints} ${S.of(context).PointsCount(itemChallengeFeelings.getPoints)}',
                                            maxLines: 1,
                                            minFontSize: 8,
                                            group: challengeFeelingsGroup,
                                            textAlign: TextAlign.right,
                                            style: theme?.boldTextTheme.caption2Bold,
                                          ),
                                          Text(
                                            '${parseDoubleToInt(itemChallengeFeelings.actualSum)}/${parseDoubleToInt(itemChallengeFeelings.sum)}',
                                            style: theme?.regularTextTheme.labelSmall.copyWith(
                                              color: ColorsFoundation.mutedText,
                                            ),
                                          ),
                                          SpacingFoundation.verticalSpace2,
                                          LinearInfluencerIndicator(
                                            actualSum: itemChallengeFeelings.actualSum,
                                            sum: itemChallengeFeelings.sum,
                                            width: 65.w,
                                          )
                                        ],
                                      ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing8)
                                    ],
                                  ),
                                ),
                              )
                              .toList() ??
                          [],
                    ),
                  ],
                ).paddingAll(EdgeInsetsFoundation.all16),
              ).paddingOnly(
                left: SpacingFoundation.horizontalSpacing16,
                right: SpacingFoundation.horizontalSpacing16,
                bottom: SpacingFoundation.verticalSpacing16,
              ),
            )
        ],
      ),
    );
  }
}
