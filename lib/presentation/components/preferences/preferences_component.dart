import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final UiPreferencesModel preferences;
  final Function onSelect;
  final bool isLoading;

  PreferencesComponent(
      {Key? key,
      this.onSubmit,
      required this.preferences,
      this.isLoading = false,
      required this.onSelect})
      : super(key: key);

  final GlobalKey _myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    final screenHeight = 1.sh;

    final config =
        GlobalComponent.of(context)?.globalConfiguration.appConfig.content ??
            GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model =
        ComponentAboutUserModel.fromJson(config['about_user']);
    final horizontalMargin =
        (model.positionModel?.horizontalMargin ?? 0).toDouble();
    final verticalMargin =
        (model.positionModel?.verticalMargin ?? 0).toDouble();

    final double padding = 27.h;
    const deviceHeightConst = 650;

    final List<Widget> widgets = [];
    for (MapEntry<int, UiKitImportanceChip> map
        in preferences.chips.asMap().entries) {
      if ((screenHeight <= deviceHeightConst && (map.key) % 2 != 0) ||
          (screenHeight > deviceHeightConst && (map.key) % 3 != 0)) continue;
      final rand = Random(map.key);
      final double topPadding =
          (map.key % (screenHeight <= deviceHeightConst ? 4 : 6)) == 0 ? padding : 0;
      widgets.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          screenHeight <= deviceHeightConst ? 2 : 3,
          (index) => Transform.translate(
                  offset: Offset(
                      rand.nextInt(40).w * (rand.nextInt(2) > 1 ? -1 : 1), 0),
                  // offset: Offset(-rand.nextInt(15) / 2, rand.nextInt(30) / 2),
                  child: preferences.chips[map.key + index])
              .paddingOnly(top: rand.nextInt(30) / 2 + SpacingFoundation.verticalSpacing2),
        ),
      ).paddingLTRB(SpacingFoundation.horizontalSpacing6, topPadding,
          SpacingFoundation.horizontalSpacing4, (topPadding - padding).abs()));
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tell us more\nabout yourself',
            style: context.uiKitTheme?.boldTextTheme.title1,
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
          RichText(
            key: _myKey,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tap once to ',
                  style: subHeadline,
                ),
                TextSpan(
                  text: 'choose what you like',
                  style: subHeadline?.copyWith(
                      foreground: Paint()
                        ..shader = GradientFoundation.buttonGradient
                            .createShader(_myKey.currentContext
                                    ?.findRenderObject()
                                    ?.paintBounds ??
                                Rect.zero)),
                ),
                TextSpan(
                  text: '. Tap twice to mark your favorites.',
                  style: subHeadline,
                )
              ],
            ),
          ).paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
          SizedBox(
              width: double.infinity,
              child: UiKitInputFieldRightIcon(
                hintText: 'search'.toUpperCase(),
                controller: TextEditingController(),
                icon: ImageWidget(
                  svgAsset: GraphicsFoundation.instance.svg.search,
                  color: Colors.white.withOpacity(0.5),
                ),
                onPressed: () {
                  print('search');
                },
              )).paddingSymmetric(horizontal: horizontalMargin),
          // SpacingFoundation.verticalSpace16,
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widgets,
                  ).paddingOnly(right: SpacingFoundation.horizontalSpacing24*1.5))),
          SpacingFoundation.verticalSpace8,
          SizedBox(
                  width: double.infinity,
                  child: context
                      .button(
                      data: BaseUiKitButtonData(
                          text: 'start to explore'.toUpperCase(),
                          onPressed: onSubmit))
                      .loadingWrap(isLoading))
              .paddingSymmetric(horizontal: horizontalMargin),
          // SpacingFoundation.verticalSpace8,
        ],
      ).paddingSymmetric(vertical: verticalMargin),
    );
  }
}
