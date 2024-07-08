import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/influencer/linear_influencer_indicator.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:intl/intl.dart';

class PointsComponent extends StatelessWidget {
  final VoidCallback onSpendCallBack;
  final VoidCallback onHistoryCallBack;
  final int userPointsCount;
  final List<ItemPoints> listChallengeFeelings;
  final List<ItemPoints> listItemPoint;

  PointsComponent({
    super.key,
    required this.onSpendCallBack,
    required this.onHistoryCallBack,
    required this.listChallengeFeelings,
    required this.listItemPoint,
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
            onPressed: () {},
          ),
        ),
        title: S.of(context).Points,
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
                  onPressed: () => onSpendCallBack,
                ),
              )
              .paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
          SpacingFoundation.verticalSpace16,
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface2,
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: SpacingFoundation.horizontalSpacing8,
                mainAxisSpacing: SpacingFoundation.verticalSpacing6,
              ),
              itemCount: listItemPoint.length,
              itemBuilder: (context, index) {
                final itemPoits = listItemPoint[index];

                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme?.colorScheme.surface,
                    borderRadius: BorderRadiusFoundation.all24,
                  ),
                  child: Stack(
                    children: [
                      ImageWidget(
                        height: 60.h,
                        width: 90.w,
                        fit: BoxFit.fitWidth,
                        link: itemPoits.imagePath,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Text(
                            itemPoits.title,
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
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme?.colorScheme.surface2,
            ),
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
                      listChallengeFeelings.length,
                      (index) {
                        final itemChallengeFeelings = listChallengeFeelings[index];

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
                                  itemChallengeFeelings.title,
                                  style: theme?.boldTextTheme.caption3Medium,
                                ),
                                Text(
                                  '${itemChallengeFeelings.getPoints} ${S.of(context).PointsCount(itemChallengeFeelings.getPoints)}',
                                  style: theme?.boldTextTheme.caption2Bold,
                                ),
                                Text(
                                  '${parseDoubleToInt(itemChallengeFeelings.sum)}/${parseDoubleToInt(itemChallengeFeelings.actualSum)}',
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
                        );
                      },
                    ),
                  )
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

class ItemPoints {
  final String title;
  final int getPoints;
  final double actualSum;
  final double sum;
  final String imagePath;

  ItemPoints({
    required this.title,
    required this.getPoints,
    required this.actualSum,
    required this.sum,
    required this.imagePath,
  });
}
