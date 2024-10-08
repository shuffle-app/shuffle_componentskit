import 'package:flutter/material.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

import '../../../presentation/components/feed/uifeed_model.dart';

class EntertainmentRouteUiModel {
  final String? thumbnailUrl;
  final String routeName;
  final String routeAPointName;
  final String routeBPointName;
  final List<UiUniversalModel> routePoints;
  final IconData icon = ShuffleUiKitIcons.landmark;

  EntertainmentRouteUiModel({
    this.thumbnailUrl,
    required this.routeName,
    required this.routeAPointName,
    required this.routeBPointName,
    required this.routePoints,
  });
}
