import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shuffle_uikit/shuffle_uikit.dart';

class UiSpinnerModel {
  final String title;
  final ValueChanged<String>? onSpinChangedCategory;
  final ScrollController scrollController;
  final List<UiKitSpinnerCard> Function(BoxConstraints size) events;
  final List<String> categories;

  UiSpinnerModel(
      {this.title = 'Events you don’t wanna miss',
      this.onSpinChangedCategory,
      ScrollController? scrollController,
      required this.events,
      required this.categories})
      : scrollController = scrollController ?? ScrollController();
}
