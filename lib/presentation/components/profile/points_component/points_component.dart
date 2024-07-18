import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_components_kit/presentation/components/profile/points_component/ui_points_model.dart';
import 'package:shuffle_components_kit/presentation/components/profile/points_component/ui_user_points_progress_bar_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:intl/intl.dart';

import 'rectangle_circle_animation.dart';
import 'row_gradient_circle.dart';

class PointsComponent extends StatelessWidget {
  final VoidCallback? onSpendCallBack;
  final VoidCallback? onHistoryCallBack;
  final int userPointsCount;
  final List<UiPointsModel>? listChallengeFeelings;
  final List<UiPointsModel>? listItemPoint;
  final UiUserPointsProgressBarModel uiUserPointsProgressBarModel;

  PointsComponent({
    super.key,
    this.onSpendCallBack,
    this.onHistoryCallBack,
    this.listChallengeFeelings,
    this.listItemPoint,
    required this.uiUserPointsProgressBarModel,
    required this.userPointsCount,
  });

  final ScrollController _scrollController = ScrollController();

  LinearInfluencerIndicator _linearInfluencerIndicator(
          UiUserPointsProgressBarModel? uiUserPointsProgressBarModel) =>
      LinearInfluencerIndicator(
        actualSum: uiUserPointsProgressBarModel?.actual ?? 0,
        sum: uiUserPointsProgressBarModel?.sum ?? 100,
        width: 1.sw <= 380 ? 180.w : 200.w,
        heingh: 12.h,
        customGradient: GradientFoundation.goldGradient,
      );

  String stringWithSpace(int text) {
    NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(text).replaceAll(',', ' ');
  }

  String parseDoubleToInt(double text) {
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
        title: S.of(context).Points,
        centerTitle: true,
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
                '${stringWithSpace(userPointsCount)} ${S.of(context).PointsCount(2650)}',
                style: theme?.boldTextTheme.subHeadline,
              ),
            ],
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
          context
              .smallOutlinedButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).Spend.toUpperCase(),
                  onPressed: onSpendCallBack,
                ),
              )
              .paddingSymmetric(
                  horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme?.colorScheme.darkNeutral900.withOpacity(0.16),
              borderRadius: BorderRadiusFoundation.all16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RowGradientCircle(
                  level: uiUserPointsProgressBarModel.level,
                ).paddingAll(EdgeInsetsFoundation.all8),
                SpacingFoundation.horizontalSpace8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GradientableWidget(
                            gradient: GradientFoundation.defaultLinearGradient,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        uiUserPointsProgressBarModel.isMenGender
                                            ? S.of(context).WiseacreOfSands
                                            : S.of(context).WiseacreLadyOfSands,
                                    style: theme?.regularTextTheme.caption1
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SpacingFoundation.verticalSpace2,
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            children: [
                              _linearInfluencerIndicator(
                                uiUserPointsProgressBarModel,
                              ),
                              Container(
                                width: _linearInfluencerIndicator(
                                  uiUserPointsProgressBarModel,
                                ).progressPosition,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusFoundation.all40,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme?.colorScheme.inversePrimary
                                              .withOpacity(0.5) ??
                                          Colors.white.withOpacity(0.8),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: _linearInfluencerIndicator(
                                  uiUserPointsProgressBarModel,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${uiUserPointsProgressBarModel.actual.toInt()}/${uiUserPointsProgressBarModel.sum.toInt()}',
                            style: theme?.regularTextTheme.caption2.copyWith(
                              color: theme.colorScheme.inverseBodyTypography,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ).paddingAll(EdgeInsetsFoundation.all8),
          ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace24,
          listItemPoint != null
              ? ColoredBox(
                  color:
                      theme?.colorScheme.surface2 ?? ColorsFoundation.surface2,
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

                      return UiKitCardWrapper(
                        color: theme?.colorScheme.surface,
                        borderRadius: BorderRadiusFoundation.all24,
                        child: Stack(
                          children: [
                            ImageWidget(
                              height: 1.sw <= 380 ? 70.h : 60.h,
                              width: 90.w,
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
                                itemPoits.showStar
                                    ? ImageWidget(
                                        link: GraphicsFoundation
                                            .instance.svg.star2.path,
                                        height: 12.h,
                                        color:
                                            theme?.colorScheme.bodyTypography,
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
                                Text(
                                  '${parseDoubleToInt(itemPoits.actualSum)}/${parseDoubleToInt(itemPoits.sum)}',
                                  style: theme?.regularTextTheme.labelSmall
                                      .copyWith(
                                    color: theme.colorScheme.darkNeutral900,
                                  ),
                                ),
                                SpacingFoundation.verticalSpace2,
                                LinearInfluencerIndicator(
                                  actualSum: itemPoits.actualSum,
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme?.colorScheme.surface,
                  borderRadius: BorderRadiusFoundation.all24,
                ),
                child: Column(
                  children: [
                    Text(
                      S.of(context).ChallengeFeelings,
                      style: theme?.boldTextTheme.caption1Bold,
                    ).paddingOnly(
                      bottom: SpacingFoundation.verticalSpacing8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        listChallengeFeelings!.length,
                        (index) {
                          final itemChallengeFeelings =
                              listChallengeFeelings![index];

                          return Stack(
                            children: [
                              ImageWidget(
                                height: 45.h,
                                width: 45.w,
                                fit: BoxFit.fitHeight,
                                link: itemChallengeFeelings.imagePath,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 30.h),
                                  Text(
                                    itemChallengeFeelings.title ??
                                        S.of(context).NothingFound,
                                    style: theme?.boldTextTheme.caption3Medium,
                                  ),
                                  Text(
                                    '${itemChallengeFeelings.getPoints} ${S.of(context).PointsCount(itemChallengeFeelings.getPoints)}',
                                    style: theme?.boldTextTheme.caption2Bold,
                                  ),
                                  Text(
                                    '${parseDoubleToInt(itemChallengeFeelings.sum)}/${parseDoubleToInt(itemChallengeFeelings.actualSum)}',
                                    style: theme?.regularTextTheme.labelSmall
                                        .copyWith(
                                      color: theme.colorScheme.darkNeutral900,
                                    ),
                                  ),
                                  SpacingFoundation.verticalSpace2,
                                  LinearInfluencerIndicator(
                                    actualSum: itemChallengeFeelings.actualSum,
                                    sum: itemChallengeFeelings.sum,
                                    width: 70.w,
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ).paddingAll(EdgeInsetsFoundation.all16),
              ).paddingOnly(
                left: SpacingFoundation.horizontalSpacing16,
                right: SpacingFoundation.horizontalSpacing16,
                bottom: SpacingFoundation.verticalSpacing16,
              ),
            ),
        ],
      ),
    );
  }
}
