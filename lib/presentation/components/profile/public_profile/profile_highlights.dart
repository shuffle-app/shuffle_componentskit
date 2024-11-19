import 'package:flutter/material.dart';
import 'package:shuffle_uikit/ui_kit/organisms/profile/data/profile_stats.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class ProfileHighlights extends StatelessWidget {
  final ProfileStats profileStats;

  const ProfileHighlights({
    super.key,
    required this.profileStats,
  });

  @override
  Widget build(BuildContext context) {
    final cards = profileStats.profileHighlightCards;

    /// Frame 364 in Figma
    return Row(
      children: cards.map((e) => Flexible(child: e)).toList().separated(SpacingFoundation.horizontalSpacing8),
    );
  }
}

extension SeparatedList on List<Widget> {
  List<Widget> separated(double horizontalSpacing) {
    final result = List<Widget>.empty(growable: true);
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(horizontalSpacing.horizontalSpace);
      }
    }
    return result;
  }
}
