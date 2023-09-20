import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiShuffleModel {
  List<UiKitSwiperCard> items;
  bool showHowItWorks;

  final AnimationController dislikeController;
  final AnimationController likeController;

  UiShuffleModel({
    required this.items,
    this.showHowItWorks = false,
    required this.dislikeController,
    required this.likeController,
  });
}
