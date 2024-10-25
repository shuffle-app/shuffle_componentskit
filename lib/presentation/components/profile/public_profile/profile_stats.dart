import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

abstract class ProfileStats {
  String getStringValue(int value) {
    if (value >= 1000000) {
      return '99k+';
    }
    return '${value > 1000 ? '${value ~/ 1000}k+' : value}';
  }

  Gradient? getGradient(int value) {
    if (value < 500) return null;
    if (value < 1000) return GradientFoundation.bronzeGradient;
    if (value < 2000) return GradientFoundation.silverGradient;
    return GradientFoundation.goldGradient;
  }

  List<ProfileHighlightCard> get profileHighlightCards;
}

class InfluencerStats extends ProfileStats {
  final int placesVisited;
  final int reviewsPosted;
  final int points;

  InfluencerStats({required this.placesVisited, required this.reviewsPosted, required this.points});

  @override
  List<ProfileHighlightCard> get profileHighlightCards => [
        ProfileHighlightCard(
          title: 'Places visited',
          value: getStringValue(placesVisited),
          valueGradient: getGradient(placesVisited),
        ),
        ProfileHighlightCard(
          title: 'Reviews posted',
          value: getStringValue(reviewsPosted),
          valueGradient: getGradient(reviewsPosted),
        ),
        ProfileHighlightCard(
          title: S.current.Points,
          value: getStringValue(points),
          valueGradient: getGradient(points),
        ),
      ];
}

class ProProfileStats extends ProfileStats {
  final int eventsCreated;
  final int reviewsReceived;
  final int bookingsReceived;

  ProProfileStats({required this.eventsCreated, required this.reviewsReceived, required this.bookingsReceived});

  @override
  List<ProfileHighlightCard> get profileHighlightCards => [
        ProfileHighlightCard(
          title: S.current.Events,
          value: getStringValue(eventsCreated),
          valueGradient: getGradient(eventsCreated),
        ),
        ProfileHighlightCard(
          title: 'Reviews received',
          value: getStringValue(reviewsReceived),
          valueGradient: getGradient(reviewsReceived),
        ),
        ProfileHighlightCard(
          title: 'Bookings',
          value: getStringValue(bookingsReceived),
          valueGradient: getGradient(bookingsReceived),
        ),
      ];
}
