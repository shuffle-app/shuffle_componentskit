import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback? onSubmit;
  final UiPreferencesModel preferences;
  final Function onSelect;

  PreferencesComponent(
      {Key? key,  this.onSubmit, required this.preferences, required this.onSelect})
      : super(key: key);

  final GlobalKey _myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final subHeadline = context.uiKitTheme?.boldTextTheme.subHeadline;

    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us more\nabout yourself',
          style: context.uiKitTheme?.boldTextTheme.title1,
        ),
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
                      ..shader = GradientFoundation.buttonGradient.createShader(
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
        ),
        SpacingFoundation.verticalSpace16,
        Expanded(
            child:
            SingleChildScrollView(
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
                  spacing: SpacingFoundation.verticalSpacing8,
                  runSpacing: SpacingFoundation.verticalSpacing8,
                  children: preferences.chips.map((chip) {
                    final rand = Random(preferences.chips.indexOf(chip));

                    return Transform.translate(
                        offset:
                            Offset(rand.nextInt(30) / 2, rand.nextInt(30) / 2),
                        child: chip);
                  }).toList(),
                )
            )
    ),
        SpacingFoundation.verticalSpace16,
        SizedBox(
            width: double.infinity,
            child: context.button(
                text: 'start to explore'.toUpperCase(), onPressed: onSubmit)),
        SpacingFoundation.verticalSpace16,
      ],
    ));
  }
}
