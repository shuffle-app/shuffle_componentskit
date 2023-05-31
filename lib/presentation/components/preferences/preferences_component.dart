import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:shuffle_components_kit/shuffle_components_kit.dart';

class PreferencesComponent extends StatelessWidget {
  final VoidCallback onSubmit;
  final UiPreferencesModel preferences;

  const PreferencesComponent(
      {Key? key, required this.onSubmit, required this.preferences})
      : super(key: key);

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
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tap once to ',
                style: subHeadline,
              ),

              // GradientText(
              //     text: 'choose what you like',
              //     style: subHeadline
              //         .copyWith(color: ColorsFoundation.darkNeutral900) ??
              //         fallBackStyle,
              //   ),
              TextSpan(
                text: '. Tap twice to mark your favorites.',
                style: subHeadline,
              )
            ],
          ),
        ),
        SpacingFoundation.verticalSpace16,
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: SpacingFoundation.verticalSpacing8,
                  runSpacing: SpacingFoundation.verticalSpacing8,
                  children: preferences.chips.map((chip) {
                    final rand = Random(preferences.chips.indexOf(chip));

                    return  chip.paddingLTRB(
                        rand.nextDouble() * 10,
                        rand.nextDouble() * 5,
                        rand.nextDouble(),
                        rand.nextDouble());
                  }).toList(),
                ))),
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
