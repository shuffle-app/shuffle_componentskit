import 'package:flutter/widgets.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiShuffleModel {
  final AnimationController dislikeController;
  final AnimationController likeController;

  List<UiKitSwiperCard> items;
  bool showHowItWorks;



  UiShuffleModel({
    required this.items,
    this.showHowItWorks = false,
    required this.dislikeController,
    required this.likeController,
  });
}
