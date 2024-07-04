import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class AdditionalInfoPremium extends StatelessWidget {
  final String userName;
  final String name;

  const AdditionalInfoPremium({
    super.key,
    required this.userName,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return UiKitCardWrapper(
      gradient: GradientFoundation.defaultLinearGradientWithOpacity02,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientableWidget(
                gradient: GradientFoundation.defaultLinearGradient,
                child: ImageWidget(
                  height: 18.h,
                  fit: BoxFit.fitHeight,
                  link: GraphicsFoundation.instance.svg.shuffleCut.path,
                  color: Colors.white,
                ),
              ),
              SpacingFoundation.horizontalSpace8,
              Expanded(
                child: Text(
                  S.of(context).PremiumSubscriptionFeature6,
                  style: context.uiKitTheme?.regularTextTheme.body,
                ),
              )
            ],
          ),
          Stack(
            children: [
              context
                  .userTile(
                    data: BaseUiKitUserTileData(
                      username: userName,
                      avatarUrl: GraphicsFoundation.instance.png.mockAvatar.path,
                      name: name,
                      type: UserTileType.influencer,
                      showBadge: true,
                    ),
                  )
                  .paddingSymmetric(horizontal: 10.0, vertical: 23.0),
              Positioned(
                bottom: 7.h,
                left: 0.26.sw,
                child: Flexible(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorsFoundation.shunyGreyGradientEnd.withOpacity(0.84),
                      borderRadius: BorderRadiusFoundation.all24,
                    ),
                    child: Text(
                      S.of(context).EntertainmentSpecialist,
                      style: context.uiKitTheme?.regularTextTheme.caption3,
                    ).paddingSymmetric(vertical: 4.0, horizontal: 8.0),
                  ),
                ),
              ),
            ],
          ),
          SpacingFoundation.verticalSpace16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientableWidget(
                gradient: GradientFoundation.defaultLinearGradient,
                child: ImageWidget(
                  height: 16.h,
                  link: GraphicsFoundation.instance.svg.shuffleCut.path,
                  color: Colors.white,
                ),
              ),
              SpacingFoundation.horizontalSpace8,
              Expanded(
                child: Text(
                  S.of(context).InfluencerSubscriptionFeature1,
                  style: context.uiKitTheme?.regularTextTheme.caption1,
                ),
              )
            ],
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
