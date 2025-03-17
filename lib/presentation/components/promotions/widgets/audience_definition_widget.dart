import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/promotions/ui_models/promotion_launch_result_ui_model.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'promotion_launch_result_widget.dart';
import 'speedometer_painter.dart';

class AudienceDefinitionWidget extends StatefulWidget {
  final int potentialCoverage;
  final int promotionEvaluation;
  final List<PromotionLaunchResultUiModel> promotionLaunchList;
  final List<String> popupMenuItems;
  final ValueChanged<int>? onPopUpMenuTap;

  const AudienceDefinitionWidget({
    super.key,
    this.potentialCoverage = 0,
    this.promotionEvaluation = 0,
    this.promotionLaunchList = const [],
    this.popupMenuItems = const [],
    this.onPopUpMenuTap,
  });

  @override
  State<AudienceDefinitionWidget> createState() => _AudienceDefinitionWidgetState();
}

class _AudienceDefinitionWidgetState extends State<AudienceDefinitionWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _valueAnimation;
  final bool isSmallDevice = 1.sw <= 380;

  @override
  void initState() {
    super.initState();

    final int evaluation = widget.promotionEvaluation.clamp(0, 10);
    final double endAngle = -math.pi / 2 + (evaluation / 10) * (math.pi * 0.98);
    final double colorEvaluation = evaluation.toDouble();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2 * 1000),
    );

    _valueAnimation = Tween<double>(begin: 0, end: colorEvaluation).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: -math.pi / 2,
      end: endAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.uiKitTheme;
    final boldTextTheme = theme?.boldTextTheme;
    final regularTextTheme = theme?.regularTextTheme;
    final colorScheme = theme?.colorScheme;

    return UiKitCardWrapper(
      color: colorScheme?.surface2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SpacingFoundation.verticalSpacing12,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  S.current.AudienceDefinition,
                  style: boldTextTheme?.labelLarge,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {},
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.over,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusFoundation.all16,
                ),
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme?.inverseSurface,
                ),
                itemBuilder: (context) => widget.popupMenuItems
                    .map<PopupMenuItem<String>>(
                      (option) => PopupMenuItem(
                        onTap: () => widget.onPopUpMenuTap?.call(widget.popupMenuItems.indexOf(option)),
                        child: Text(
                          option,
                          style: boldTextTheme?.caption2Medium.copyWith(color: colorScheme?.inverseBodyTypography),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          AutoSizeText(
            S.current.TodaysSummaryX(DateTime.now().toCustomString()),
            style: boldTextTheme?.caption1Medium.copyWith(color: ColorsFoundation.mutedText),
            maxLines: 1,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: AutoSizeText(
                  S.of(context).PromotionEvaluation,
                  style: boldTextTheme?.caption2Medium.copyWith(color: ColorsFoundation.mutedText),
                  maxLines: 2,
                  minFontSize: 8,
                ),
              ),
              SpacingFoundation.horizontalSpace12,
              Text(
                '${widget.promotionEvaluation}',
                style: regularTextTheme?.title1,
              ),
              SpacingFoundation.horizontalSpace24,
              Column(
                children: [
                  SizedBox(
                    width: 120.w,
                    height: isSmallDevice ? 80.w : 60.w,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            CustomPaint(
                              painter: SpeedometerPainter(currentValue: _valueAnimation.value),
                              child: SizedBox(
                                width: 120.w,
                                height: isSmallDevice ? 70.w : 50.w,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: AnimatedBuilder(
                                animation: _rotationAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationAnimation.value,
                                    alignment: Alignment.bottomCenter,
                                    child: ImageWidget(
                                      height: 45.w,
                                      fit: BoxFit.fitHeight,
                                      link: GraphicsFoundation.instance.svg.arrowPromoStat2.path,
                                      color: const Color(0xFFD9D9D9),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: isSmallDevice ? 130.w : 120.w,
                    child: Row(
                      children: [
                        Text(
                          '0',
                          style: regularTextTheme?.labelSmall,
                        ).paddingOnly(
                          left: isSmallDevice
                              ? SpacingFoundation.horizontalSpacing2
                              : SpacingFoundation.horizontalSpacing4,
                        ),
                        Spacer(),
                        Text(
                          '10',
                          style: regularTextTheme?.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  S.current.PotentialCoverageOfXPeople(stringWithSpace(widget.potentialCoverage)),
                  style: regularTextTheme?.labelSmall.copyWith(color: ColorsFoundation.mutedText),
                ),
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => showUiKitPopover(
                    context,
                    customMinHeight: 30.h,
                    showButton: false,
                    title: Text(
                      S.of(context).HowManyPeopleRegisteredInTheAppWillPotentiallySeeThePost,
                      style: theme?.regularTextTheme.body.copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  child: ImageWidget(
                    iconData: ShuffleUiKitIcons.info,
                    width: 16.w,
                    color: theme?.colorScheme.darkNeutral900,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: colorScheme?.surface3,
            thickness: 2.w,
          ),
          Text(
            S.current.PromotionLaunchResults,
            style: boldTextTheme?.labelLarge,
          ),
          ...widget.promotionLaunchList.map(
            (e) => Column(
              children: [
                PromotionLaunchResultWidget(model: e).paddingOnly(top: SpacingFoundation.verticalSpacing12),
                if (e != widget.promotionLaunchList.last)
                  Divider(
                    color: colorScheme?.surface3,
                    thickness: 2.w,
                  ).paddingOnly(top: SpacingFoundation.verticalSpacing12),
              ],
            ),
          ),
        ],
      ).paddingAll(EdgeInsetsFoundation.all16),
    );
  }
}
