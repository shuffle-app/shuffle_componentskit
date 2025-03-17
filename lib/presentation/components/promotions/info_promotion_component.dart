import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/notification_offer_reminder_components/universal_not_offer_rem_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/ui_models/promotion_launch_result_ui_model.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/widgets/audience_definition_widget.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/widgets/custom_title_widget_promo.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InfoPromotionComponent extends StatefulWidget {
  final VoidCallback? onNotificationTap;
  final ValueChanged<int>? onPopUpMenuTap;
  final UniversalNotOfferRemUiModel model;
  final List<String> popupMenuItems;

  const InfoPromotionComponent({
    super.key,
    required this.model,
    this.onNotificationTap,
    this.onPopUpMenuTap,
    this.popupMenuItems = const [],
  });

  @override
  State<InfoPromotionComponent> createState() => _InfoPromotionComponentState();
}

class _InfoPromotionComponentState extends State<InfoPromotionComponent> {
  ///Mock
  final List<PromotionLaunchResultUiModel> promotionLaunchList = [
    PromotionLaunchResultUiModel(
      title: S.current.Views,
      toDayCount: 110,
      popOverText: S.current.CardViewsWithinAPromotion,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.Clicks,
      toDayCount: 110,
      popOverText: S.current.ClicksOnTheCardWithinAPromotion,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.Coverage,
      toDayCount: 92000,
      popOverText: S.current.NumberOfUniqueViews,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.BookingsPromo,
      toDayCount: 3,
      popOverText: S.current.BookingsForYourEvent,
      yesterdayCount: 10,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.Favorites,
      toDayCount: 3,
      popOverText: S.current.AddToFavorites,
      yesterdayCount: 10,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.Invitations,
      toDayCount: 300,
      popOverText: S.current.NumberOfParticipantsInTheInvitationList,
    ),
    PromotionLaunchResultUiModel(
      title: S.current.BudgetPromo,
      toDayCount: 5,
      popOverText: S.current.SpentOnPromotionToday,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final textStyle = theme?.boldTextTheme.caption1Medium;

    return BlurredAppBarPage(
      autoImplyLeading: true,
      customToolbarBaseHeight: 70.h,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      customTitle: SizedBox(
        width: 0.75.sw,
        child: CustomTitleWidgetPromo(model: widget.model),
      ),
      children: [
        SpacingFoundation.verticalSpace16,
        AudienceDefinitionWidget(
          potentialCoverage: 38900,
          promotionEvaluation: 10,
          promotionLaunchList: promotionLaunchList,
          popupMenuItems: widget.popupMenuItems,
          onPopUpMenuTap: widget.onPopUpMenuTap,
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        SpacingFoundation.verticalSpace16,
        UiKitCardWrapper(
          color: theme?.colorScheme.surface2,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${S.of(context).YourIndicatorsHasSetTheBarHighItCanBe} ',
                                style: textStyle,
                              ),
                              TextSpan(
                                text: S.of(context).EvenHigher,
                                style: textStyle?.copyWith(color: Colors.transparent),
                              ),
                              TextSpan(
                                text: ' ${S.of(context).IfYouApplyThePromotion}',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                        GradientableWidget(
                          gradient: GradientFoundation.showUpGradient,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${S.of(context).YourIndicatorsHasSetTheBarHighItCanBe} ',
                                  style: textStyle?.copyWith(color: Colors.transparent),
                                ),
                                TextSpan(
                                  text: S.of(context).EvenHigher,
                                  style: textStyle,
                                ),
                                TextSpan(
                                  text: ' ${S.of(context).IfYouApplyThePromotion}',
                                  style: textStyle?.copyWith(color: Colors.transparent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(right: SpacingFoundation.horizontalSpacing32),
                    SpacingFoundation.verticalSpace8,
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: context.smallButton(
                            data: BaseUiKitButtonData(
                              autoSizeGroup: AutoSizeGroup(),
                              text: S.of(context).Notification,
                              onPressed: widget.onNotificationTap,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    )
                  ],
                ).paddingAll(EdgeInsetsFoundation.all16),
                Positioned(
                  right: SpacingFoundation.horizontalSpacing16,
                  bottom: SpacingFoundation.verticalSpacing16,
                  child: ImageWidget(
                    height: 60.h,
                    fit: BoxFit.fitHeight,
                    rasterAsset: GraphicsFoundation.instance.png.likeHands,
                  ),
                ),
              ],
            ),
          ),
        ).paddingSymmetric(horizontal: SpacingFoundation.horizontalSpacing16),
        SpacingFoundation.bottomNavigationBarSpacing,
      ],
    );
  }
}
