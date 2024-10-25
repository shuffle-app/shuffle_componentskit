import 'package:flutter/material.dart';
import 'package:shuffle_components_kit/presentation/components/profile/public_profile/profile_stats.dart';
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
    return SizedBox(
      width: 1.sw,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => cards[index],
          separatorBuilder: (_, __) => SpacingFoundation.horizontalSpace8,
          itemCount: cards.length),
    );
  }
}
