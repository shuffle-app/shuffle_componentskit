import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final UiPreferencesModel preferences;
  final Function onSelect;
  final bool isLoading;

  PreferencesComponent({Key? key,
    this.onSubmit,
    this.isLoading = false,
    required this.preferences,
    required this.onSelect})
      : super(key: key);

  final GlobalKey _myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;
    final List<Widget> rowChips = [];
    for (MapEntry<int, UiKitImportanceChip> map
    in preferences.chips
        .asMap()
        .entries) {
      if (map.key.isOdd) continue;

      final rand = Random(map.key);
      rowChips.add(Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment
            .values[rand.nextInt(MainAxisAlignment.values.length)],
        children: [
          Transform.translate(
              offset: Offset(-rand.nextInt(15) / 2, rand.nextInt(30) / 2),
              child: preferences.chips[map.key]),
          SpacingFoundation.verticalSpace8,
          if (preferences.chips.length != map.key + 1)
            Transform.translate(
                offset: Offset(rand.nextInt(30) / 2, -rand.nextInt(30) / 2),
                child: preferences.chips[map.key + 1])
        ],
      ).paddingSymmetric(
          vertical: SpacingFoundation.verticalSpacing4,
          horizontal: SpacingFoundation.horizontalSpacing8));
    }
    final config = GlobalComponent
        .of(context)
        ?.globalConfiguration
        .appConfig
        .content ?? GlobalConfiguration().appConfig.content;
    final ComponentAboutUserModel model = ComponentAboutUserModel.fromJson(
        config['about_user']);
    final horizontalMargin = (model.positionModel?.horizontalMargin ?? 0)
        .toDouble();
    final verticalMargin = (model.positionModel?.verticalMargin ?? 0)
        .toDouble();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                            .createShader(
                            _myKey.currentContext
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
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  //     GridView.custom(
                  //       scrollDirection: Axis.horizontal,
                  //       primary: false,
                  //       shrinkWrap: true,
                  //       gridDelegate:
                  //       SliverWovenGridDelegate.count(
                  //         crossAxisCount: 4,
                  //         mainAxisSpacing: 8,
                  //         crossAxisSpacing: 8,
                  //         pattern: [
                  //           WovenGridTile(0.7),
                  //           WovenGridTile(1),
                  //           WovenGridTile(
                  //             0.2,
                  //             crossAxisRatio: 0.9,
                  //             alignment: AlignmentDirectional.centerEnd,
                  //           ),
                  //         ]),
                  //   SliverStairedGridDelegate(
                  //   // crossAxisSpacing: SpacingFoundation.verticalSpacing8,
                  //   // mainAxisSpacing: SpacingFoundation.verticalSpacing8,
                  //   startCrossAxisDirectionReversed: true,
                  //   pattern: [
                  //     StairedGridTile(0.5, 1.2),
                  //     StairedGridTile(0.2, 0.9),
                  //     StairedGridTile(0.36, 0.82),
                  //     StairedGridTile(0.5, 0.8),
                  //     // StairedGridTile(0.2, 1.2),
                  //   ],
                  // ),
                  //   childrenDelegate: SliverChildBuilderDelegate(
                  //   childCount:preferences.chips.length,
                  //       (context, index) => preferences.chips[index],
                  // ),)
                  Wrap(
                      direction: Axis.vertical,
                      // spacing: SpacingFoundation.verticalSpacing8,
                      // runSpacing: SpacingFoundation.verticalSpacing8,
                      children: rowChips
                    // preferences.chips.map((chip) {
                    //   final rand = Random(preferences.chips.indexOf(chip));
                    //
                    //   return Transform.translate(
                    //       offset:
                    //           Offset(rand.nextInt(30) / 2, rand.nextInt(30) / 2),
                    //       child: chip);
                    // }).toList(),
                  ))),
          SpacingFoundation.verticalSpace16,
          SizedBox(
              width: double.infinity,
              child: context.button(
                  text: 'start to explore'.toUpperCase(), onPressed: onSubmit).loadingWrap(isLoading))
              .paddingSymmetric(horizontal: horizontalMargin),
          SpacingFoundation.verticalSpace16,
        ],
      ).paddingSymmetric(vertical: verticalMargin),);
  }
}
