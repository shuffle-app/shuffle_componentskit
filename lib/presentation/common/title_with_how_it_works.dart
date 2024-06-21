import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../shuffle_components_kit.dart';

class TitleWithHowItWorks extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final HowItWorksWidget howItWorksWidget;
  final bool shouldShow;

  const TitleWithHowItWorks({
    super.key,
    required this.title,
    required this.textStyle,
    required this.howItWorksWidget,
    required this.shouldShow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: textStyle,
          ),
          WidgetSpan(
            child: shouldShow ? howItWorksWidget : SpacingFoundation.none,
          )
        ],
      ),
    );
  }
}
