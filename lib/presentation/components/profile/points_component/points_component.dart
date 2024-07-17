import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_components_kit/presentation/components/profile/points_component/ui_points_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:intl/intl.dart';

class PointsComponent extends StatelessWidget {
  final VoidCallback? onSpendCallBack;
  final VoidCallback? onHistoryCallBack;
  final int userPointsCount;
  final List<UiPointsModel>? listChallengeFeelings;
  final List<UiPointsModel>? listItemPoint;

  PointsComponent({
    super.key,
    this.onSpendCallBack,
    this.onHistoryCallBack,
    this.listChallengeFeelings,
    this.listItemPoint,
    required this.userPointsCount,
  });

  final ScrollController _scrollController = ScrollController();

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
              .midSizeOutlinedButton(
                data: BaseUiKitButtonData(
                  text: S.of(context).Spend.toUpperCase(),
                  onPressed: onSpendCallBack,
                ),
              )
              .paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
                                  style: theme?.regularTextTheme.labelSmall.copyWith(
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
                      children: listChallengeFeelings
                              ?.map((itemChallengeFeelings) => Stack(
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
                                            itemChallengeFeelings.title ?? S.of(context).NothingFound,
                                            style: theme?.boldTextTheme.caption3Medium,
                                          ),
                                          Text(
                                            '${itemChallengeFeelings.getPoints} ${S.of(context).PointsCount(itemChallengeFeelings.getPoints)}',
                                            style: theme?.boldTextTheme.caption2Bold,
                                          ),
                                          Text(
                                            '${parseDoubleToInt(itemChallengeFeelings.actualSum)}/${parseDoubleToInt(itemChallengeFeelings.sum)}',
                                            style: theme?.regularTextTheme.labelSmall.copyWith(
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
                                  ))
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
