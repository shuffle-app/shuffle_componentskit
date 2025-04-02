import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiShuffleModel {
  final AnimationController dislikeController;
  final AnimationController likeController;

  final List<BaseUiKitSwiperCard> items;
  final bool showHowItWorks;

  const UiShuffleModel({
    required this.items,
    this.showHowItWorks = false,
    required this.dislikeController,
    required this.likeController,
  });
}
